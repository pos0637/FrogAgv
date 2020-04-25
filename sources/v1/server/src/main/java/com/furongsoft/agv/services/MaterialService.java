package com.furongsoft.agv.services;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.mappers.MaterialDao;
import com.furongsoft.agv.models.MaterialModel;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 存货服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class MaterialService extends BaseService<MaterialDao, Material> {

    private final MaterialDao materialDao;


    @Autowired
    public MaterialService(MaterialDao materialDao) {
        super(materialDao);
        this.materialDao = materialDao;
    }

    /**
     * 通过主键获取存货详情
     *
     * @param id 存货ID
     * @return
     */
    public MaterialModel selectMaterialById(Long id) {
        return materialDao.selectMaterialById(id);
    }

    /**
     * 通过uuid查找原料/产品信息
     *
     * @param uuid 唯一标识
     * @return 原料信息
     */
    public MaterialModel selectMaterialByUuid(String uuid) {
        return materialDao.selectMaterialByUuid(uuid);
    }

    /**
     * 查找未被删除的产品列表
     *
     * @return 产品列表
     */
    public List<Material> selectMaterials() {
        EntityWrapper<Material> materialEntityWrapper = new EntityWrapper<>();
        materialEntityWrapper.eq("enabled", 1);
        return materialDao.selectList(materialEntityWrapper);
    }
}
