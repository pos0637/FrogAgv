package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.CallMaterial;
import com.furongsoft.agv.mappers.*;
import com.furongsoft.agv.models.*;
import com.furongsoft.base.exceptions.BaseException;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;

import java.util.*;

/**
 * 叫料服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CallMaterialService extends BaseService<CallMaterialDao, CallMaterial> {

    private final CallMaterialDao callMaterialDao;
    private final CallButtonDao callButtonDao;
    private final AgvAreaDao agvAreaDao;
    private final WaveDao waveDao;
    private final WaveDetailDao waveDetailDao;

    @Autowired
    public CallMaterialService(CallMaterialDao callMaterialDao, CallButtonDao callButtonDao, AgvAreaDao agvAreaDao, WaveDao waveDao, WaveDetailDao waveDetailDao) {
        super(callMaterialDao);
        this.callMaterialDao = callMaterialDao;
        this.callButtonDao = callButtonDao;
        this.agvAreaDao = agvAreaDao;
        this.waveDao = waveDao;
        this.waveDetailDao = waveDetailDao;
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
     * 根据条件获取叫料列表（默认获取未完成的）
     *
     * @param type   叫料类型[1：灌装区；2：包装区；3：消毒间；4：拆包间]
     * @param state  状态[0：未配送；1：配送中；2：已完成]
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 叫料列表
     */
    public List<CallMaterialModel> selectCallMaterialsByConditions(int type, Integer state, String teamId, Long areaId) {
        return callMaterialDao.selectCallMaterialsByConditions(type, state, teamId, areaId);
    }

    /**
     * 按条件查询配货任务
     *
     * @param type   叫料类型[1：灌装区；2：包装区；3：消毒间；4：拆包间]
     * @param state  状态[0：未配送；1：配送中；2：已完成]
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 配货任务列表
     */
    public List<DistributionTaskModel> selectDistributionTaskByConditions(int type, Integer state, String teamId, Long areaId) {
        List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(type, state, teamId, areaId);
        Map<String, DistributionTaskModel> distributionTaskModelMap = new HashMap<>();
        if (!CollectionUtils.isEmpty(callMaterialModels)) {
            callMaterialModels.forEach(callMaterialModel -> {
                DistributionTaskModel distributionTaskModel = distributionTaskModelMap.get(callMaterialModel.getWaveCode());
                if (ObjectUtils.isEmpty(distributionTaskModel)) {
                    DistributionTaskModel newDistributionTask = new DistributionTaskModel(callMaterialModel.getWaveCode(), callMaterialModel.getProductId(), callMaterialModel.getProductName(), callMaterialModel.getProductUuid(), callMaterialModel.getProductLineCode(), callMaterialModel.getCallTime(), new ArrayList<>());
                    newDistributionTask.getCallMaterialModels().add(callMaterialModel);
                    distributionTaskModelMap.put(callMaterialModel.getWaveCode(), newDistributionTask);
                } else {
                    distributionTaskModel.getCallMaterialModels().add(callMaterialModel);
                }
            });
        }
        List<DistributionTaskModel> distributionTaskModels = new ArrayList<>();
        distributionTaskModelMap.forEach((key, value) -> {
            distributionTaskModels.add(value);
        });
        return distributionTaskModels;
    }

    /**
     * 添加叫料
     *
     * @param callMaterialModel 叫料信息
     */
    public void addCallMaterial(CallMaterialModel callMaterialModel) {
        CallMaterial callMaterial = new CallMaterial();
        BeanUtils.copyProperties(callMaterialModel, callMaterial);
        callMaterialDao.insert(callMaterial);
    }

    /**
     * 通过ID进行删除叫料信息（伪删），已经配送的无法删除
     *
     * @param id 叫料ID
     */
    public String deleteCallMaterial(long id) {
        CallMaterialModel callMaterialModel = callMaterialDao.selectCallMaterialById(id);
        if (callMaterialModel.getState() == 0) {
            if (callMaterialDao.deleteCallMaterial(id)) {
                return "删除成功";
            } else {
                return "删除失败，请重试";
            }
        } else {
            return "已经配送，无法取消";
        }
    }

    /**
     * 新增波次叫料
     *
     * @param waveDetailModels 波次详情
     */
    public void addWaveDetailCallMaterials(List<WaveDetailModel> waveDetailModels) {
        if (!CollectionUtils.isEmpty(waveDetailModels)) {
            List<CallMaterial> insertCalls = new ArrayList<>();
            waveDetailModels.forEach(waveDetailModel -> {
                CallMaterial callMaterial = new CallMaterial(waveDetailModel);
                Date newDate = new Date();
                callMaterial.setCallTime(newDate);
                CallMaterialModel callMaterialModel = callMaterialDao.selectCallMaterialByWaveDetailCodeAndAreaType(waveDetailModel.getCode(), waveDetailModel.getAreaType());
                if (ObjectUtils.isEmpty(callMaterialModel)) {
                    insertCalls.add(callMaterial);
                }
            });
            if (!CollectionUtils.isEmpty(insertCalls)) {
                insertBatch(insertCalls);
                return;
            }
        }
        throw new BaseException("叫料失败，请重试");
    }

    /**
     * 按钮叫料
     *
     * @param ipAddress
     */
    public void buttonCallMaterial(String ipAddress) {
        CallButtonModel callButtonModel = callButtonDao.selectCallButtonAreaByIpAddress(ipAddress);
        if (callButtonModel.getCode().indexOf("CALL") > 0) {
            callMaterial(callButtonModel);
        }
        if (callButtonModel.getCode().indexOf("BACK") > 0) {
            backMaterialBox(callButtonModel);
        }
    }

    /**
     * 按钮叫料
     *
     * @param callButtonModel 按钮对象
     */
    private void callMaterial(CallButtonModel callButtonModel) {
        // 获取叫料产线
        AgvAreaModel callLine = agvAreaDao.selectParentAreaById(callButtonModel.getAreaId());
        // 获取叫料区域
        AgvAreaModel callArea = agvAreaDao.selectParentAreaById(callLine.getId());
        // 获取指定区域下的所有波次
        List<WaveModel> waveModels = waveDao.selectWaveModelsByAreaId(callLine.getId());
        if (!CollectionUtils.isEmpty(waveModels)) {
            List<WaveModel> unCallWaves = new ArrayList<>();
            waveModels.forEach(waveModel -> {
                // 所有波次详情
                List<WaveDetailModel> waveDetailModels = waveDetailDao.selectWaveDetails(waveModel.getCode());
                // 指定区域已叫料的波次详情
                List<WaveDetailModel> callWaveDetailModels = waveDetailDao.selectWaveDetailsByWaveCodeAndAreaId(waveModel.getCode(), callLine.getId());
                if (!CollectionUtils.isEmpty(callWaveDetailModels)) {
                    Map<String, WaveDetailModel> waveDetailModelMap = new HashMap<>();
                    // 将已叫料的波次详情放入Map种
                    callWaveDetailModels.forEach(callWaveDetailModel -> {
                        waveDetailModelMap.put(callWaveDetailModel.getCode(), callWaveDetailModel);
                    });
                    List<WaveDetailModel> unCallWaveDetails = new ArrayList<>();
                    waveDetailModels.forEach(waveDetailModel -> {
                        WaveDetailModel calledModel = waveDetailModelMap.get(waveDetailModel.getCode());
                        // 如果还未叫料，则加入未叫料波次详情列表中
                        if (ObjectUtils.isEmpty(calledModel)) {
                            if (callArea.getCode().equals("PRODUCT_FILLING")) {
                                // 灌装区
                                waveDetailModel.setAreaType(1);
                            } else if (callArea.getCode().equals("PRODUCT_PACKAGING")) {
                                // 包装区
                                waveDetailModel.setAreaType(2);
                            }
                            unCallWaveDetails.add(waveDetailModel);
                        }
                    });
                    if (!CollectionUtils.isEmpty(unCallWaveDetails)) {
                        waveModel.setWaveDetailModels(unCallWaveDetails);
                        unCallWaves.add(waveModel);
                    }
                } else {
                    // 如果没有已叫料的。
                    waveDetailModels.forEach(waveDetailModel -> {
                        if (callArea.getCode().equals("PRODUCT_FILLING")) {
                            // 灌装区
                            waveDetailModel.setAreaType(1);
                        } else if (callArea.getCode().equals("PRODUCT_PACKAGING")) {
                            // 包装区
                            waveDetailModel.setAreaType(2);
                        }
                    });
                    waveModel.setWaveDetailModels(waveDetailModels);
                    unCallWaves.add(waveModel);
                }
            });
            // 新增叫料
            if (!CollectionUtils.isEmpty(unCallWaves)) {
                List<WaveDetailModel> callDetails = unCallWaves.get(0).getWaveDetailModels();
                List<CallMaterial> insertDetails = new ArrayList<>();
                Date newDate = new Date();
                callDetails.forEach(waveDetailModel -> {
                    CallMaterial callMaterial = new CallMaterial(waveDetailModel);
                    callMaterial.setCallTime(newDate);
                    insertDetails.add(callMaterial);
                });
                insertBatch(insertDetails);
                return;
            }
        }
        throw new BaseException("叫料失败，请重试");
    }

    /**
     * 按钮退货
     *
     * @param callButtonModel 按钮对象
     */
    private void backMaterialBox(CallButtonModel callButtonModel) {
        // 获取叫料产线
        AgvAreaModel callLine = agvAreaDao.selectParentAreaById(callButtonModel.getAreaId());
        // 获取叫料区域
        AgvAreaModel callArea = agvAreaDao.selectParentAreaById(callLine.getId());
        if (callArea.getCode().equals("PRODUCT_FILLING")) {
            // 灌装区：查找消毒间空库位
            List<SiteDetailModel> siteDetailModels = agvAreaDao.selectSiteDetailsByAreaCode("XD_LOCATION", 0);
            if (!CollectionUtils.isEmpty(siteDetailModels)) {
                // TODO 发起点到点的配送任务
            }
        } else if (callArea.getCode().equals("PRODUCT_PACKAGING")) {
            // 包装区：查找包材仓空库位
            List<SiteDetailModel> siteDetailModels = agvAreaDao.selectSiteDetailsByAreaCode("BC_BZ_LOCATION", 0);
            if (!CollectionUtils.isEmpty(siteDetailModels)) {
                // TODO 发起点到点的配送任务
            }
        }
    }
}
