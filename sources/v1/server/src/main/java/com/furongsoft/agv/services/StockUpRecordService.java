package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.MaterialBoxMaterial;
import com.furongsoft.agv.entities.StockUpRecord;
import com.furongsoft.agv.frog.models.BomDetailModel;
import com.furongsoft.agv.frog.models.BomModel;
import com.furongsoft.agv.frog.services.BomService;
import com.furongsoft.agv.mappers.*;
import com.furongsoft.agv.models.*;
import com.furongsoft.base.misc.DateUtils;
import com.furongsoft.base.misc.StringUtils;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;

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
    private final SiteService siteService;
    private final DeliveryTaskService deliveryTaskService;

    @Autowired
    public StockUpRecordService(StockUpRecordDao stockUpRecordDao, SiteDetailDao siteDetailDao, MaterialBoxDao materialBoxDao, MaterialBoxMaterialDao materialBoxMaterialDao, MaterialDao materialDao, BomService bomService, WaveDao waveDao, WaveDetailDao waveDetailDao, SiteService siteService, DeliveryTaskService deliveryTaskService) {
        super(stockUpRecordDao);
        this.stockUpRecordDao = stockUpRecordDao;
        this.siteDetailDao = siteDetailDao;
        this.materialBoxDao = materialBoxDao;
        this.materialBoxMaterialDao = materialBoxMaterialDao;
        this.materialDao = materialDao;
        this.bomService = bomService;
        this.waveDao = waveDao;
        this.waveDetailDao = waveDetailDao;
        this.siteService = siteService;
        this.deliveryTaskService = deliveryTaskService;
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
     * 获取今日的配送任务（今日任务=今日配送+明日备货+之前未完成）
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
        // 查找灌装区今天之前未完成的
        List<WaveModel> unFinished = waveDao.selectUnFinishedByDate(2, startDay);
        // 查找包装区今天之前未完成的
        List<WaveModel> packagingUnFinished = waveDao.selectUnFinishedByDate(2, startDay);
        // 返回的原料列表
        List<MaterialModel> backMaterials = new ArrayList<>();
        Map<String, WaveModel> waveModelMap = new HashMap<>();
        // 灌装区波次
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
        if (!CollectionUtils.isEmpty(unFinished)) {
            unFinished.forEach(waveModel -> {
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
        // 包装区波次
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
        if (!CollectionUtils.isEmpty(packagingUnFinished)) {
            packagingUnFinished.forEach(waveModel -> {
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
        return backMaterials;
    }

//    /**
//     * 备货：修改站点上的料框，并将站点设置成有货；将料框设置为有货或者空车状态；删除料框原本的原料列表；根据原料列表添加料框-原料
//     * 需要有：产品ID、产品数量、料框ID、站点ID  TODO 待修改
//     *
//     * @param stockUpRecordModel 备货信息
//     * @return 是否成功
//     */
//    public boolean stockUp(StockUpRecordModel stockUpRecordModel) {
//        // 料车
//        MaterialBoxModel materialBoxModel = selectMaterialBoxModelByQrCode(stockUpRecordModel.getMaterialCarName());
//        // 站点
//        SiteDetailModel siteDetailModel = selectSiteDetailModelByQrCode(stockUpRecordModel.getLandMaskName());
//        materialBoxMaterialDao.deleteMaterialBoxMaterialByMaterialId(materialBoxModel.getId()); // 将料框上的原料移除
//        // TODO 通过站点查找区域
//        // TODO 通过区域判断备货类型
//        // TODO 获取所有未备货的波次 TODO
//        // TODO 通过产品编号，查找出波次
//        // TODO 通过波次编号、备货类型，删除备货表的备货信息
//        if (!StringUtils.isNullOrEmpty(stockUpRecordModel.getMaterialName())) {
//            // 有选择产品，即有原料
//            int materialType; // 原料类型
//            String materialUuid; // 原料uuid
//            int endIndex;
//            if (stockUpRecordModel.getMaterialName().indexOf("_GZ") > 0) {
//                materialType = 1;
//                endIndex = stockUpRecordModel.getMaterialName().indexOf("_GZ");
//                materialUuid = stockUpRecordModel.getMaterialName().substring(0, endIndex);
//            } else {
//                materialType = 2;
//                endIndex = stockUpRecordModel.getMaterialName().indexOf("_BZ");
//                materialUuid = stockUpRecordModel.getMaterialName().substring(0, endIndex);
//            }
//            // 通过产品uuid查找出产品信息
//            MaterialModel materialModel = materialDao.selectMaterialByUuid(materialUuid);
//            // 通过UUID查出BOM详情
//            BomModel bomModel = bomService.selectBomByMaterialUuid(materialUuid);
//            List<BomDetailModel> bomDetailModels = bomService.selectBomDetailsByMaterialUuid(materialModel.getUuid());
//            if (!CollectionUtils.isEmpty(bomDetailModels)) {
//                // 有原料列表
//                materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 1); // 将料车设成有货
//                bomDetailModels.forEach(bomDetailModel -> {
//                    if (bomDetailModel.getType() == materialType) {
//                        MaterialBoxMaterial materialBoxMaterial = new MaterialBoxMaterial(materialBoxModel.getId(), bomDetailModel.getMaterialId(), bomModel.getFullCount() * bomDetailModel.getCount(), 0);
//                        materialBoxMaterialDao.insert(materialBoxMaterial);
//                    }
//                });
//            } else {
//                // 无原料列表
//                materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 0); // 设成空车
//            }
//        } else {
//            // 无原料列表
//            materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 0); // 设成空车
//        }
//        return siteDetailDao.addMaterialBoxBySiteId(siteDetailModel.getSiteId(), materialBoxModel.getId()); // 通过站点添加料框并设置站点为有货
//    }

    /**
     * 发货
     *
     * @param materialCode 波次编码_类型_叫料区域ID_叫料站点ID
     * @param materialCarCode 料车编号
     * @param landMaskCode 地标编号
     * @return 发货结果
     */
    public String stockUp(String materialCode, String materialCarCode, String landMaskCode) {
        if (StringUtils.isNullOrEmpty(materialCarCode)) {
            Tracker.agv("PDA发货失败：原料编号为空");
            return "发货失败，原料编号为空，请刷新重试";
        }
        // 波次编码_类型_叫料区域ID_叫料站点ID
        String[] items = materialCode.split("_");
        if (items.length < 4) {
            Tracker.agv("PDA发货失败，编号格式不正确");
            return "发货失败，编号格式不正确，请刷新重试";
        }
        // 料车
        MaterialBoxModel materialBoxModel = selectMaterialBoxModelByQrCode(materialCarCode);
        if (ObjectUtils.isEmpty(materialBoxModel)) {
            return "发货失败,请确认料车编号";
        }
        // 站点
        SiteModel siteModel = siteService.selectSiteModeByQrCode(landMaskCode);
        materialBoxMaterialDao.deleteMaterialBoxMaterialByMaterialId(materialBoxModel.getId()); // 将料框上的原料移除
        // 发货区域  TODO 空
        AgvArea agvArea = siteService.selectAgvAreaBySiteId(siteModel.getId());
        // 如果区域类型是库位
        if (agvArea.getType() == 8) {
            //
            AgvAreaModel parentArea = siteService.selectParentAreaByAreaId(agvArea.getId());
            // 备货
            List<WaveDetailModel> waveDetailModels = waveDetailDao.selectWaveDetails(items[0]);
            if (!CollectionUtils.isEmpty(waveDetailModels)) {
                // 有原料列表
                materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 1); // 将料车设成有货
                waveDetailModels.forEach(waveDetailModel -> {
                    MaterialBoxMaterial materialBoxMaterial = new MaterialBoxMaterial(materialBoxModel.getId(), waveDetailModel.getMaterialId(), waveDetailModel.getCount(), 0);
                    materialBoxMaterialDao.insert(materialBoxMaterial);
                });
            } else {
                // 无原料列表
                materialBoxDao.updateMaterialBoxState(materialBoxModel.getId(), 0); // 设成空车
            }
            siteDetailDao.addMaterialBoxBySiteId(siteModel.getId(), materialBoxModel.getId()); // 通过站点添加料框并设置站点为有货
            // 发货
            DeliveryTaskModel deliveryTaskModel = new DeliveryTaskModel();
            deliveryTaskModel.setStartSiteId(siteModel.getId());
            deliveryTaskModel.setEndSiteId(Long.valueOf(items[3]));
            deliveryTaskModel.setMaterialBoxId(materialBoxModel.getId());
            deliveryTaskModel.setWaveCode(items[0]);
            if (parentArea.getCode().equalsIgnoreCase("WAREHOUSE")) {
                // 包材仓（包材仓-包装区；包材仓-拆包间）
                Long endSiteId = Long.valueOf(items[3]);
                Long areaId = Long.valueOf(items[2]);
                if (endSiteId > 0) {
                    AgvAreaModel agvAreaModel = siteService.selectAgvAreaById(areaId);
                    // 包材仓-包装区
                    deliveryTaskModel.setType(5);
                    deliveryTaskModel.setProductLine(agvAreaModel.getCode());
                } else {
                    // 包材仓-拆包间
                    deliveryTaskModel.setType(3);
                }
            } else if (parentArea.getCode().equalsIgnoreCase("DISINFECTION")) {
                Long areaId = Long.valueOf(items[2]);
                // 消毒间（消毒间-灌装区）
                deliveryTaskModel.setType(1);
                AgvAreaModel agvAreaModel = siteService.selectAgvAreaById(areaId);
                deliveryTaskModel.setProductLine(agvAreaModel.getCode());
            }

            try {
                return deliveryTaskService.addDeliveryTask(deliveryTaskModel);
            } catch (Exception e) {
                Tracker.error(e);
                return "发货失败，数据异常，请刷新重试";
            }
        }

        return "发货失败，请在库位上执行发货";
    }
}
