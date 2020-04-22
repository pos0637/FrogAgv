package com.furongsoft.agv.frog.services;

import com.furongsoft.agv.frog.entities.Bom;
import com.furongsoft.agv.frog.mappers.BomDao;
import com.furongsoft.agv.frog.mappers.BomDetailDao;
import com.furongsoft.agv.frog.models.BomDetailModel;
import com.furongsoft.agv.frog.models.BomModel;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * bom信息服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class BomService extends BaseService<BomDao, Bom> {

    private final BomDao bomDao;
    private final BomDetailDao bomDetailDao;


    @Autowired
    public BomService(BomDao bomDao, BomDetailDao bomDetailDao) {
        super(bomDao);
        this.bomDao = bomDao;
        this.bomDetailDao = bomDetailDao;
    }

    /**
     * 通过主键获取bom信息详情
     *
     * @param id bom信息ID
     * @return
     */
    public BomModel selectBomById(Long id) {
        return bomDao.selectBomById(id);
    }

    /**
     * 通过产品编号获取BOM清单
     *
     * @param materialCode 原料UUID
     * @return bom清单
     */
    public List<BomDetailModel> selectBomDetailsByMaterialUuid(String materialCode) {
        BomModel bomModel = bomDao.selectBomByMaterialUuid(materialCode);
        return bomDetailDao.selectBomDetailByBomId(bomModel.getId());
    }

    /**
     * 通过产品UUID查找BOM信息
     *
     * @param materialCode 产品UUID
     * @return bom信息
     */
    public BomModel selectBomByMaterialUuid(String materialCode) {
        return bomDao.selectBomByMaterialUuid(materialCode);
    }
}
