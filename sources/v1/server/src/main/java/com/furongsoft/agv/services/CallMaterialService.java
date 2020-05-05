package com.furongsoft.agv.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.furongsoft.agv.devices.mappers.CallButtonDao;
import com.furongsoft.agv.devices.model.CallButtonModel;
import com.furongsoft.agv.entities.CallMaterial;
import com.furongsoft.agv.mappers.AgvAreaDao;
import com.furongsoft.agv.mappers.CallMaterialDao;
import com.furongsoft.agv.mappers.WaveDao;
import com.furongsoft.agv.mappers.WaveDetailDao;
import com.furongsoft.agv.models.AgvAreaModel;
import com.furongsoft.agv.models.CallMaterialModel;
import com.furongsoft.agv.models.DeliveryTaskModel;
import com.furongsoft.agv.models.DistributionTaskModel;
import com.furongsoft.agv.models.WaveDetailModel;
import com.furongsoft.agv.models.WaveModel;
import com.furongsoft.base.exceptions.BaseException;
import com.furongsoft.base.services.BaseService;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestParam;

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
    private final DeliveryTaskService deliveryTaskService;

    @Autowired
    public CallMaterialService(CallMaterialDao callMaterialDao, CallButtonDao callButtonDao, AgvAreaDao agvAreaDao,
            WaveDao waveDao, WaveDetailDao waveDetailDao, DeliveryTaskService deliveryTaskService) {
        super(callMaterialDao);
        this.callMaterialDao = callMaterialDao;
        this.callButtonDao = callButtonDao;
        this.agvAreaDao = agvAreaDao;
        this.waveDao = waveDao;
        this.waveDetailDao = waveDetailDao;
        this.deliveryTaskService = deliveryTaskService;
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
     * @param state  状态[1：未配送；2：配送中；3：已完成；4：已取消]
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 叫料列表
     */
    public List<CallMaterialModel> selectCallMaterialsByConditions(int type, Integer state, String teamId,
            Long areaId) {
        return callMaterialDao.selectCallMaterialsByConditions(type, state, teamId, areaId);
    }

    /**
     * 按条件查询配货任务
     *
     * @param type   叫料类型[1：灌装区；2：包装区；3：消毒间；4：拆包间]
     * @param state  状态[1：未配送；2：配送中；3：已完成；4：已取消]
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 配货任务列表
     */
    public List<DistributionTaskModel> selectDistributionTaskByConditions(int type, Integer state, String teamId,
            Long areaId) {
        List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(type, state,
                teamId, areaId);
        Map<String, DistributionTaskModel> distributionTaskModelMap = new HashMap<>();
        if (!CollectionUtils.isEmpty(callMaterialModels)) {
            callMaterialModels.forEach(callMaterialModel -> {
                DistributionTaskModel distributionTaskModel = distributionTaskModelMap
                        .get(callMaterialModel.getWaveCode());
                if (ObjectUtils.isEmpty(distributionTaskModel)) {
                    DistributionTaskModel newDistributionTask = new DistributionTaskModel(
                            callMaterialModel.getWaveCode(), callMaterialModel.getProductId(),
                            callMaterialModel.getProductName(), callMaterialModel.getProductUuid(),
                            callMaterialModel.getProductLineCode(), callMaterialModel.getCallTime(), new ArrayList<>());
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
                CallMaterialModel callMaterialModel = callMaterialDao.selectCallMaterialByWaveDetailCodeAndAreaType(
                        waveDetailModel.getCode(), waveDetailModel.getAreaType());
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
     * 通过叫料ID取消叫料。 先判断这个叫料的状态是否处于未配送状态，不是未配送不可取消
     *
     * @param id 叫料ID
     */
    public void cancelCallMaterial(long id) {
        CallMaterialModel callMaterialModel = callMaterialDao.selectUnDeliveryCallMaterialById(id);
        if (ObjectUtils.isEmpty(callMaterialModel)) {
            throw new BaseException("当前叫料不可取消");
        } else {
            callMaterialDao.deleteCallMaterial(id);
        }
    }

    /**
     * 通过波次取消叫料
     *
     * @param waveCode 波次编号
     */
    public void cancelWaveCallMaterials(String waveCode) {
        List<WaveDetailModel> waveDetailModels = waveDetailDao.selectWaveDetails(waveCode);
        if (!CollectionUtils.isEmpty(waveDetailModels)) {
            waveDetailModels.forEach(waveDetailModel -> {
                callMaterialDao.deleteCallMaterialByCode(waveDetailModel.getCode());
            });
        }
    }

    /**
     * 更新叫料状态
     *
     * @param id    叫料ID
     * @param state 状态
     * @return 是否成功
     */
    public boolean updateCallMaterialState(long id, int state) {
        return callMaterialDao.updateCallMaterialState(id, state);
    }

    /**
     * 按钮叫料 TODO 项目启动时，把按钮信息加载到内存中
     *
     * @param ipAddress
     * @throws Exception
     */
    public void buttonCallMaterial(String ipAddress, String buttonCode) throws Exception {
        CallButtonModel callButtonModel = callButtonDao.selectCallButtonAreaByIpAddress(ipAddress, buttonCode);
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
    public boolean callMaterial(CallButtonModel callButtonModel) {
        // 获取叫料产线
        AgvAreaModel callLine = agvAreaDao.selectParentAreaById(callButtonModel.getAreaId());
        // 获取叫料区域
        AgvAreaModel callArea = agvAreaDao.selectParentAreaById(callLine.getId());
        // 获取指定区域下的所有波次
        List<WaveModel> waveModels = waveDao.selectWaveModelsByAreaId(callLine.getId());
        if (!CollectionUtils.isEmpty(waveModels)) {
            List<WaveModel> unCallWaves = new ArrayList<>();
            // 找出所有未叫料的波次
            waveModels.forEach(waveModel -> {
                // 所有波次详情
                List<WaveDetailModel> waveDetailModels = waveDetailDao.selectWaveDetails(waveModel.getCode());
                // 指定区域已叫料的波次详情
                List<WaveDetailModel> callWaveDetailModels = waveDetailDao
                        .selectWaveDetailsByWaveCodeAndAreaId(waveModel.getCode(), callLine.getId());
                if (!CollectionUtils.isEmpty(callWaveDetailModels)) {
                    Map<String, WaveDetailModel> waveDetailModelMap = new HashMap<>();
                    // 将已叫料的波次详情放入Map种
                    callWaveDetailModels.forEach(callWaveDetailModel -> {
                        waveDetailModelMap.put(callWaveDetailModel.getCode(), callWaveDetailModel);
                    });
                    List<WaveDetailModel> unCallWaveDetails = new ArrayList<>();
                    // 找出未叫料的波次详情加入到列表中
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
                    // 如果存在未叫料的波次详情，则添加未叫料波次
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
                    callMaterial.setAreaId(callLine.getId());
                    callMaterial.setCallTime(newDate);
                    insertDetails.add(callMaterial);
                });
                insertBatch(insertDetails);
                return true;
            }
        }
        return false;
    }

    /**
     * 按钮退货
     *
     * @param callButtonModel 按钮对象
     * @throws Exception
     */
    public boolean backMaterialBox(CallButtonModel callButtonModel) throws Exception {
        // 获取叫料产线
        AgvAreaModel callLine = agvAreaDao.selectParentAreaById(callButtonModel.getAreaId());
        // 获取叫料区域
        AgvAreaModel callArea = agvAreaDao.selectParentAreaById(callLine.getId());
        DeliveryTaskModel deliveryTaskModel = new DeliveryTaskModel();
        deliveryTaskModel.setStartSiteId(callButtonModel.getSiteId());
        if (callArea.getCode().equals("PRODUCT_FILLING")) {
            // 灌装区退回
            deliveryTaskModel.setType(2);
            return deliveryTaskService.addDeliveryTask(deliveryTaskModel);
        } else if (callArea.getCode().equals("PRODUCT_PACKAGING")) {
            // 包装区退回
            deliveryTaskModel.setType(6);
            return deliveryTaskService.addDeliveryTask(deliveryTaskModel);
        }
        return false;
    }

    /**
     * 通过波次编码以及区域类型获取叫料列表
     *
     * @param waveCode 波次编码
     * @param areaType 区域类型
     * @return 叫料列表
     */
    public List<CallMaterialModel> selectCallMaterialByWaveCodeAndAreaType(String waveCode, int areaType, Integer state) {
        return callMaterialDao.selectCallMaterialByWaveCodeAndAreaType(waveCode, areaType, state);
    }
}
