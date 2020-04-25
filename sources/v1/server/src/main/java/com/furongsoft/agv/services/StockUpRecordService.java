package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.MaterialBoxMaterial;
import com.furongsoft.agv.entities.StockUpRecord;
import com.furongsoft.agv.frog.models.BomDetailModel;
import com.furongsoft.agv.frog.models.BomModel;
import com.furongsoft.agv.frog.services.BomService;
import com.furongsoft.agv.mappers.*;
import com.furongsoft.agv.models.*;
import com.furongsoft.base.misc.DateUtils;
import com.furongsoft.base.misc.StringUtils;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 备货服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class StockUpRecordService extends BaseService<StockUpRecordDao, StockUpRecord> {

    private final StockUpRecordDao stockUpRecordDao;
    private final SiteDetailDao siteDetailDao;
    private final MaterialBoxDao materialBoxDao;
    private final MaterialBoxMaterialDao materialBoxMaterialDao;
    private final MaterialDao materialDao;
    private final BomService bomService;
    private final WaveDao waveDao;
    private final WaveDetailDao waveDetailDao;

    @Autowired
    public StockUpRecordService(StockUpRecordDao stockUpRecordDao, SiteDetailDao siteDetailDao, MaterialBoxDao materialBoxDao, MaterialBoxMaterialDao materialBoxMaterialDao, MaterialDao materialDao, BomService bomService, WaveDao waveDao, WaveDetailDao waveDetailDao) {
        super(stockUpRecordDao);
        this.stockUpRecordDao = stockUpRecordDao;
        this.siteDetailDao = siteDetailDao;
        this.materialBoxDao = materialBoxDao;
        this.materialBoxMaterialDao = materialBoxMaterialDao;
        this.materialDao = materialDao;
        this.bomService = bomService;
        this.waveDao = waveDao;
        this.waveDetailDao = waveDetailDao;
    }

    /**
     * 通过主键获取备货详情
     *
     * @param id 备货ID
     * @return 备货信息
     */
    public StockUpRecordModel selectStockUpRecordById(Long id) {
        return stockUpRecordDao.selectStockUpRecordById(id);
    }

    /**
     * 通过二维码查找站点详情
     *
     * @param qrCode 二维码
     * @return 站点详情
     */
    public SiteDetailModel selectSiteDetailModelByQrCode(String qrCode) {
        return siteDetailDao.selectSiteDetailModelByQrCode(qrCode);
    }

    /**
     * 通过二维码查询料框信息
     *
     * @param qrCode 二维码
     * @return 料框信息
     */
    public MaterialBoxModel selectMaterialBoxModelByQrCode(String qrCode) {
        return materialBoxDao.selectMaterialBoxModelByQrCode(qrCode);
    }

    /**
     * 获取今日的配送任务（今日任务=今日配送+明日备货）
     *
     * @return 获取今日的配送产品列表
     */
    public List<MaterialModel> getTodayDistributionTask() {
        Map<String, Date> map = DateUtils.getYesterdayTodayTomorrow();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String startDay = sdf.format(map.get("today")) + " 00:00:00";
        String endDay = sdf.format(map.get("tomorrow")) + " 23:59:59";
        // 查询出今天需要配送的灌装区波次
        List<WaveModel> waveModels = waveDao.selectWaveModelsByDate(1, startDay, endDay);
        // 包装区波次
        List<WaveModel> packagingWaveModels = waveDao.selectWaveModelsByDate(2, startDay, endDay);
        // 返回的原料列表
        List<MaterialModel> backMaterials = new ArrayList<>();
        Map<String, WaveModel> waveModelMap = new HashMap<>();
        if (!CollectionUtils.isEmpty(waveModels)) {
            waveModels.forEach(waveModel -> {
                String waveKey = waveModel.getMaterialCode() + "_GZ";
                WaveModel exitModel = waveModelMap.get(waveKey);
                if (null == exitModel) {
                    // 查找BOM获取满料数量  产品ID、名称、数量、编号、类型
                    BomModel bomModel = bomService.selectBomByMaterialUuid(waveModel.getMaterialCode());
                    MaterialModel materialModel = new MaterialModel(waveModel.getMaterialId(), waveModel.getMaterialName() + "[灌装]", waveKey, bomModel.getFullCount(), 1);
                    backMaterials.add(materialModel);
                    waveModelMap.put(waveKey, waveModel);
                }
            });
        }
        if (!CollectionUtils.isEmpty(packagingWaveModels)) {
            packagingWaveModels.forEach(waveModel -> {
                String waveKey = waveModel.getMaterialCode() + "_BZ";
                WaveModel exitModel = waveModelMap.get(waveKey);
                if (null == exitModel) {
                    // 查找BOM获取满料数量  产品ID、名称、数量、编号、类型
                    BomModel bomModel = bomService.selectBomByMaterialUuid(waveModel.getMaterialCode());
                    MaterialModel materialModel = new MaterialModel(waveModel.getMaterialId(), waveModel.getMaterialName() + "[包装]", waveKey, bomModel.getFullCount(), 2);
                    backMaterials.add(materialModel);
                    waveModelMap.put(waveKey, waveModel);
                }
            });
        }
        return backMaterials;
    }

    /**
     * 备货：修改站点上的料框，并将站点设置成有货；将料框设置为有货或者空车状态；删除料框原本的原料列表；根据原料列表添加料框-原料
     * 需要有：产品ID、产品数量、料框ID、站点ID
     *
     * @param stockUpRecordModel 备货信息
     * @return 是否成功
     */
    public boolean stockUp(StockUpRecordModel stockUpRecordModel) {
        // 料车
        MaterialBoxModel materialBoxModel = selectMaterialBoxModelByQrCode(stockUpRecordModel.getMaterialCarName());
        // 站点
        SiteDetailModel siteDetailModel = selectSiteDetailModelByQrCode(stockUpRecordModel.getLandMaskName());
        materialBoxMaterialDao.deleteMaterialBoxMaterialByMaterialId(materialBoxModel.getId()); // 将料框上的原料移除
        if (!StringUtils.isNullOrEmpty(stockUpRecordModel.getMaterialName())) {
            int materialType;
            String materialUuid;
            int endIndex;
            if (stockUpRecordModel.getMaterialName().indexOf("_GZ") > 0) {
                materialType = 1;
                endIndex = stockUpRecordModel.getMaterialName().indexOf("_GZ");
                materialUuid = stockUpRecordModel.getMaterialName().substring(0, endIndex);
            } else {
                materialType = 2;
                endIndex = stockUpRecordModel.getMaterialName().indexOf("_BZ");
                materialUuid = stockUpRecordModel.getMaterialName().substring(0, endIndex);
            }
            // 通过产品查找出产品信息
            MaterialModel materialModel = materialDao.selectMaterialByUuid(materialUuid);
            // 通过UUID查出BOM详情
            BomModel bomModel = bomService.selectBomByMaterialUuid(materialUuid);
            List<BomDetailModel> bomDetailModels = bomService.selectBomDetailsByMaterialUuid(materialModel.getUuid());
            if (!CollectionUtils.isEmpty(bomDetailModels)) {
                // 有原料列表
                materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 1); // 设成有货
                bomDetailModels.forEach(bomDetailModel -> {
                    if (bomDetailModel.getType() == materialType) {
                        MaterialBoxMaterial materialBoxMaterial = new MaterialBoxMaterial(materialBoxModel.getId(), bomDetailModel.getMaterialId(), bomModel.getFullCount() * bomDetailModel.getCount(), 0);
                        materialBoxMaterialDao.insert(materialBoxMaterial);
                    }
                });
            } else {
                // 无原料列表
                materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 0); // 设成空车
            }
        } else {
            // 无原料列表
            materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 0); // 设成空车
        }
        return siteDetailDao.addMaterialBoxBySiteId(siteDetailModel.getSiteId(), materialBoxModel.getId()); // 通过站点添加料框并设置站点为有货
    }
}
