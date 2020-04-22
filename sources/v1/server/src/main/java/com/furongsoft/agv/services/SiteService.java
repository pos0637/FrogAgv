package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.mappers.*;
import com.furongsoft.agv.models.*;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 站点服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class SiteService extends BaseService<SiteDao, Site> {

    private final SiteDao siteDao;
    private final StockUpRecordDao stockUpRecordDao;
    private final MaterialBoxDao materialBoxDao;
    private final MaterialBoxMaterialDao materialBoxMaterialDao;
    private final DeliveryTaskDao deliveryTaskDao;
    private final AgvAreaDao agvAreaDao;
    private final SiteDetailDao siteDetailDao;

    @Autowired
    public SiteService(SiteDao siteDao, StockUpRecordDao stockUpRecordDao, MaterialBoxDao materialBoxDao, MaterialBoxMaterialDao materialBoxMaterialDao, DeliveryTaskDao deliveryTaskDao, AgvAreaDao agvAreaDao, SiteDetailDao siteDetailDao) {
        super(siteDao);
        this.siteDao = siteDao;
        this.stockUpRecordDao = stockUpRecordDao;
        this.materialBoxDao = materialBoxDao;
        this.materialBoxMaterialDao = materialBoxMaterialDao;
        this.deliveryTaskDao = deliveryTaskDao;
        this.agvAreaDao = agvAreaDao;
        this.siteDetailDao = siteDetailDao;
    }

    /**
     * 通过主键获取站点信息
     *
     * @param id 站点ID
     * @return 站点信息
     */
    public SiteModel selectSiteById(Long id) {
        SiteModel siteModel = siteDao.selectSiteById(id);
        if (null != siteModel.getDeliveryTaskId()) {
            siteModel.setDeliveryTaskModel(deliveryTaskDao.selectDeliveryTaskById(siteModel.getDeliveryTaskId()));
        }
        if (null != siteModel.getMaterialBoxId()) {
            MaterialBoxModel materialBoxModel = materialBoxDao.selectMaterialBoxById(siteModel.getMaterialBoxId());
            List<MaterialBoxMaterialModel> materialBoxMaterialModels = materialBoxMaterialDao.selectMaterialBoxMaterialByMaterialBoxId(siteModel.getMaterialBoxId());
            materialBoxModel.setMaterialBoxMaterialModels(materialBoxMaterialModels);
            siteModel.setMaterialBoxModel(materialBoxModel);
        }
        return siteModel;
    }

    /**
     * 通过区域类型获取站点详细信息
     *
     * @param type 区域类型[1：生产区；2：灌装区；3：包装区；4：消毒间；5：拆包间；6：包材仓；7：生产线；8：库位区]
     * @return 站点详细信息
     */
    public List<SiteModel> selectLocationByAreaType(int type) {
        List<SiteModel> siteModels = siteDao.selectLocationByAreaType(type);
        if (!CollectionUtils.isEmpty(siteModels)) {
            siteModels.forEach(siteModel -> {
                if (null != siteModel.getMaterialBoxId()) {
                    // 获取备货信息
                    MaterialBoxModel materialBoxModel = materialBoxDao.selectMaterialBoxById(siteModel.getMaterialBoxId());
                    List<MaterialBoxMaterialModel> materialBoxMaterialModels = materialBoxMaterialDao.selectMaterialBoxMaterialByMaterialBoxId(siteModel.getMaterialBoxId());
                    materialBoxModel.setMaterialBoxMaterialModels(materialBoxMaterialModels);
                    siteModel.setMaterialBoxModel(materialBoxModel);
                }
                if (null != siteModel.getDeliveryTaskId()) {
                    // 获取配送任务信息
                    DeliveryTaskModel deliveryTaskModel = deliveryTaskDao.selectDeliveryTaskById(siteModel.getDeliveryTaskId());
                    siteModel.setDeliveryTaskModel(deliveryTaskModel);
                }
            });
        }
        return siteModels;
    }

    /**
     * 通过父级ID查找区域信息
     *
     * @param parentId 父级ID
     * @param type     区域类型
     * @return 区域信息集合
     */
    public List<AgvAreaModel> selectAreasByParentId(int parentId, Integer type) {
        return agvAreaDao.selectAreaByParentId(parentId, type);
    }

    /**
     * 查找生产区的生产线集合
     *
     * @return 区域信息集合
     */
    public List<AgvAreaModel> selectProductLinesByCode(String code) {
        AgvAreaModel product = agvAreaDao.selectAgvAreaByCodeAndParent("PRODUCT", 0);
        AgvAreaModel productArea = agvAreaDao.selectAgvAreaByCodeAndParent(code, product.getId());
        return agvAreaDao.selectAreaByParentId(productArea.getId(), null);
    }

    /**
     * 通过区域编号以及产线编号查找生产区库位
     *
     * @param areaCode 区域编号  "PRODUCT_FILLING"：灌装区；"PRODUCT_PACKAGING"：包装区
     * @param lineCode 产线编号
     * @return 指定的库位
     */
    public AgvAreaModel selectProductLocationByAreaCodeAndLineCode(String areaCode, String lineCode) {
        AgvAreaModel product = agvAreaDao.selectAgvAreaByCodeAndParent("PRODUCT", 0);
        AgvAreaModel productArea = agvAreaDao.selectAgvAreaByCodeAndParent(areaCode, product.getId());
        return agvAreaDao.selectAgvAreaByCodeAndParent(lineCode, productArea.getId());
    }

    /**
     * 通过区域编号查找空闲站点集合
     *
     * @param areaCode 区域编号
     * @return 站点集合
     */
    public List<SiteDetailModel> selectIdleSiteDetailsByAreaCode(String areaCode) {
        return siteDetailDao.selectIdleSiteByAreaCode(areaCode);
    }

    /**
     * 通过区域ID查找库位
     *
     * @param areaId 区域ID
     * @return 库位集合
     */
    public List<SiteModel> selectLocationsByAreaId(long areaId) {
        return siteDao.selectLocationsByAreaId(areaId);
    }

    /**
     * 通过站点ID和配送任务ID，绑定站点的当前配送任务
     *
     * @param siteId         站点ID
     * @param deliveryTaskId 配送任务ID
     */
    public void addDeliveryTask(long siteId, long deliveryTaskId) {
        siteDetailDao.addDeliveryTask(siteId, deliveryTaskId);
    }

    /**
     * 通过站点ID移除配送任务
     *
     * @param siteId 站点ID
     */
    public void removeDeliveryTask(long siteId) {
        siteDetailDao.removeDeliveryTask(siteId);
    }

    /**
     * 通过站点ID查找料框
     *
     * @param siteId 站点ID
     * @return 料框
     */
    public MaterialBoxModel selectMaterialBoxBySiteId(long siteId) {
        return siteDetailDao.selectMaterialBoxBySiteId(siteId);
    }
}
