package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.CallMaterial;
import com.furongsoft.agv.mappers.CallMaterialDao;
import com.furongsoft.agv.models.CallMaterialModel;
import com.furongsoft.base.services.BaseService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 叫料服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CallMaterialService extends BaseService<CallMaterialDao, CallMaterial> {

    private final CallMaterialDao callMaterialDao;

    public CallMaterialService(CallMaterialDao callMaterialDao) {
        super(callMaterialDao);
        this.callMaterialDao = callMaterialDao;
    }

    /**
     * 通过主键获取叫料详情
     *
     * @param id 叫料ID
     * @return 叫料信息
     */
    public CallMaterialModel selectCallMaterialById(Long id) {
        return callMaterialDao.selectCallMaterialById(id);
    }

    /**
     * 根据条件货期叫料列表
     *
     * @param type   叫料类型【1：灌装区；2：包装区；3：消毒间；4：拆包间】
     * @param state  状态
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 叫料列表
     */
    public List<CallMaterialModel> selectCallMaterialsByConditions(int type, Integer state, String teamId, Long areaId) {
        return callMaterialDao.selectCallMaterialsByConditions(type, state, teamId, areaId);
    }

    public void addCallMaterial(CallMaterialModel callMaterialModel) {
        
    }

}
