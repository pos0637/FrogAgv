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

    @Autowired
    public SiteService(SiteDao siteDao, StockUpRecordDao stockUpRecordDao, MaterialBoxDao materialBoxDao, MaterialBoxMaterialDao materialBoxMaterialDao, DeliveryTaskDao deliveryTaskDao, AgvAreaDao agvAreaDao) {
        super(siteDao);
        this.siteDao = siteDao;
        this.stockUpRecordDao = stockUpRecordDao;
        this.materialBoxDao = materialBoxDao;
        this.materialBoxMaterialDao = materialBoxMaterialDao;
        this.deliveryTaskDao = deliveryTaskDao;
        this.agvAreaDao = agvAreaDao;
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
     * 查找灌装区生产线
     *
     * @return 区域信息集合
     */
    public List<AgvAreaModel> selectProductLinesByCode(String code) {
        AgvAreaModel product = agvAreaDao.selectAgvAreaByCodeAndParent("PRODUCT", 0);
        AgvAreaModel filling = agvAreaDao.selectAgvAreaByCodeAndParent(code, product.getId());
        return agvAreaDao.selectAreaByParentId(filling.getId(), null);
    }
}
