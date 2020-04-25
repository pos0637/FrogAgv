package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.DeliveryTask;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.mappers.CallMaterialDao;
import com.furongsoft.agv.mappers.DeliveryTaskDao;
import com.furongsoft.agv.mappers.MaterialBoxDao;
import com.furongsoft.agv.mappers.MaterialBoxMaterialDao;
import com.furongsoft.agv.models.*;
import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.base.exceptions.BaseException;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * 配送管理服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class DeliveryTaskService extends BaseService<DeliveryTaskDao, DeliveryTask> {

    private final SiteService siteService;
    private final CallMaterialDao callMaterialDao;
    private final DeliveryTaskDao deliveryTaskDao;
    private final MaterialBoxDao materialBoxDao;
    private final MaterialBoxMaterialDao materialBoxMaterialDao;
    private final IScheduler scheduler;

    @Autowired
    public DeliveryTaskService(SiteService siteService, CallMaterialDao callMaterialDao, DeliveryTaskDao deliveryTaskDao, MaterialBoxDao materialBoxDao, MaterialBoxMaterialDao materialBoxMaterialDao, IScheduler scheduler) {
        super(deliveryTaskDao);
        this.siteService = siteService;
        this.callMaterialDao = callMaterialDao;
        this.deliveryTaskDao = deliveryTaskDao;
        this.materialBoxDao = materialBoxDao;
        this.materialBoxMaterialDao = materialBoxMaterialDao;
        this.scheduler = scheduler;
    }

    /**
     * 通过主键获取配送管理详情
     *
     * @param id 配送管理ID
     * @return
     */
    public DeliveryTaskModel selectDeliveryTaskById(Long id) {
        return deliveryTaskDao.selectDeliveryTaskById(id);
    }

    /**
     * 添加配送任务
     *
     * @param deliveryTaskModel
     * @return
     */
    public boolean addDeliveryTask(DeliveryTaskModel deliveryTaskModel) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String currentTime = sdf.format(new Date());
        String taskNo = "";
        // 获取料框中的原料
        List<MaterialBoxMaterialModel> materialBoxMaterialModels = materialBoxMaterialDao.selectMaterialBoxMaterialByMaterialBoxId(deliveryTaskModel.getMaterialBoxId());
        switch (deliveryTaskModel.getType()) {
            case 1: { // 消毒-灌装；  TODO
                taskNo = "PS" + currentTime;
                // TODO 是否需要这个功能
                if (CollectionUtils.isEmpty(materialBoxMaterialModels)) {
                    Tracker.error("空料车，无法发货");
                    throw new BaseException("空料车，无法发货。");
                }
                // 获取灌装区指定生产线的库位列表
                AgvAreaModel location = siteService.selectProductLocationByAreaCodeAndLineCode("PRODUCT_FILLING", deliveryTaskModel.getProductLine());
                List<SiteModel> siteModels = siteService.selectLocationsByAreaId(location.getId());
                // 判断站点是否有叫料，有则下发任务。任务成功则结束循环，任务失败则进入下一个循环
                for (SiteModel siteModel : siteModels) {
                    // 站点未配送的叫料集合
                    List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(1, 1, null, siteModel.getId());
                    if (CollectionUtils.isEmpty(callMaterialModels)) {
                        continue;
                    }
                    MaterialBoxModel materialBoxModel = siteService.selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                    DeliveryTask deliveryTask = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, siteModel.getId(), materialBoxModel.getId(), "消毒-灌装下发配送任务失败。", false);
                    if (ObjectUtils.isEmpty(deliveryTask)) {
                        continue;
                    }
                    // 更新叫料状态为配送中
                    updateCallMaterialState(materialBoxMaterialModels, callMaterialModels, 2);
                    boolean addTaskFlag = insert(deliveryTask);

                    if (addTaskFlag) {
                        siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                    }
                    return addTaskFlag;
                }
                return false;
            }
            case 2: { // 灌装-消毒； TODO
                taskNo = "TH" + currentTime;
                // 查找消毒间空闲库位
                List<SiteDetailModel> idleSites = siteService.selectIdleSiteDetailsByAreaCode("XD_LOCATION");
                if (CollectionUtils.isEmpty(idleSites)) {
                    Tracker.error("消毒间无空库位。退货失败。");
                    return false;
                }
                MaterialBoxModel materialBoxModel = siteService.selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                DeliveryTask deliveryTask = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, idleSites.get(0).getId(), materialBoxModel.getId(), "灌装-消毒下发退货任务失败。", true);
                if (ObjectUtils.isEmpty(deliveryTask)) {
                    return false;
                }
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 3: { // 包材-拆包；
                taskNo = "PS" + currentTime;
                // 查找拆包间空闲库位
                List<SiteDetailModel> idleSites = siteService.selectIdleSiteDetailsByAreaCode("CB_LOCATION");
                if (CollectionUtils.isEmpty(idleSites)) {
                    Tracker.error("拆包无空库位。配送失败。");
                    throw new BaseException("当前拆包间无可用库位，发货失败！");
                }
                // 获取拆包间叫料信息
                List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(4, 1, null, null);
                if (CollectionUtils.isEmpty(callMaterialModels)) {
                    Tracker.error("包材-拆包配送失败。拆包间无叫料");
                    throw new BaseException("拆包间无未配送的叫料请求,无法发货");
                }
                // TODO 是否需要这个功能
                if (CollectionUtils.isEmpty(materialBoxMaterialModels)) {
                    Tracker.error("空料车，无法发货");
                    throw new BaseException("空料车，无法发货。");
                }
                MaterialBoxModel materialBoxModel = siteService.selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                DeliveryTask deliveryTask = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, idleSites.get(0).getId(), materialBoxModel.getId(), "包材-拆包下发送货任务失败。", false);
                if (ObjectUtils.isEmpty(deliveryTask)) {
                    return false;
                }
                // 更新叫料状态为配送中
                updateCallMaterialState(materialBoxMaterialModels, callMaterialModels, 2);
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 4: { // 拆包-包材；
                taskNo = "TH" + currentTime;
                // 查找包材仓-拆包空闲库位 TODO 包材-拆包与包材-包装库位是否合并公用
                List<SiteDetailModel> idleSites = siteService.selectIdleSiteDetailsByAreaCode("BC_CB_LOCATION");
                if (CollectionUtils.isEmpty(idleSites)) {
                    Tracker.error("包材仓无空库位。退货失败。");
                    throw new BaseException("当前包材仓无可用库位，退货架失败！");
                }
                MaterialBoxModel materialBoxModel = siteService.selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                DeliveryTask deliveryTask = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, idleSites.get(0).getId(), materialBoxModel.getId(), "拆包-包材下发退货任务失败。", true);
                if (ObjectUtils.isEmpty(deliveryTask)) {
                    return false;
                }
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 5: { // 包材-包装；TODO
                taskNo = "PS" + currentTime;
                AgvAreaModel location = siteService.selectProductLocationByAreaCodeAndLineCode("PRODUCT_PACKAGING", deliveryTaskModel.getProductLine());
                List<SiteModel> siteModels = siteService.selectLocationsByAreaId(location.getId());
                // 判断站点是否有叫料，有则下发任务。任务成功则结束循环，任务失败则进入下一个循环
                for (SiteModel siteModel : siteModels) {
                    // 站点未配送的叫料集合
                    List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(2, 1, null, siteModel.getId());
                    if (CollectionUtils.isEmpty(callMaterialModels)) {
                        continue;
                    }
                    MaterialBoxModel materialBoxModel = siteService.selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                    DeliveryTask deliveryTask = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, siteModel.getId(), materialBoxModel.getId(), "包材-包装下发配送任务失败。", false);
                    if (ObjectUtils.isEmpty(deliveryTask)) {
                        continue;
                    }
                    // 更新叫料状态为配送中
                    updateCallMaterialState(materialBoxMaterialModels, callMaterialModels, 2);
                    boolean addTaskFlag = insert(deliveryTask);
                    if (addTaskFlag) {
                        siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                    }
                    return addTaskFlag;
                }
                return false;
            }
            case 6: { // 包装-包材 TODO
                taskNo = "TH" + currentTime;
                //  查找包材-包装空闲库位 TODO 包材-拆包与包材-包装库位是否合并公用
                List<SiteDetailModel> idleSites = siteService.selectIdleSiteDetailsByAreaCode("BC_BZ_LOCATION");
                if (CollectionUtils.isEmpty(idleSites)) {
                    Tracker.error("包材仓无空库位。退货失败。");
                    throw new BaseException("当前包材仓无可用库位，退料车失败！");
                }
                MaterialBoxModel materialBoxModel = siteService.selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                DeliveryTask deliveryTask = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, idleSites.get(0).getId(), materialBoxModel.getId(), "包装-包材下发退货任务失败。", true);
                if (ObjectUtils.isEmpty(deliveryTask)) {
                    return false;
                }
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 7: { // 拆包-消毒
                // 获取拆包间叫料信息
                List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(3, 1, null, null);
                if (CollectionUtils.isEmpty(callMaterialModels)) {
                    Tracker.error("拆包-消毒配送失败。消毒间无叫料");
                    throw new BaseException("消毒间无未配送的叫料请求,无法发货");
                }
                // TODO 是否需要这个功能
                if (CollectionUtils.isEmpty(materialBoxMaterialModels)) {
                    Tracker.error("空料车，无法发货");
                    throw new BaseException("空料车，无法发货。");
                }
                // 更新叫料状态为已完成
                updateCallMaterialState(materialBoxMaterialModels, callMaterialModels, 3);
                // 将料车置空并设状态为空车
                materialBoxMaterialDao.deleteMaterialBoxMaterialByMaterialId(deliveryTaskModel.getMaterialBoxId());
                return materialBoxDao.updateMaterialBoxState(deliveryTaskModel.getMaterialBoxId(), 0);
            }
        }
        return false;
    }

    /**
     * 查找原料和数量与料框中相同的叫料信息
     *
     * @param callMaterialModels       叫料集合
     * @param materialBoxMaterialModel 料框中的原料信息
     * @return
     */
    private CallMaterialModel findFirstCallMaterialModel(List<CallMaterialModel> callMaterialModels, MaterialBoxMaterialModel materialBoxMaterialModel) {
        Optional<CallMaterialModel> callMaterialModelOptional = callMaterialModels.stream().filter(ca -> (ca.getMaterialId() == materialBoxMaterialModel.getMaterialId() && ca.getCount() == materialBoxMaterialModel.getCount())).findFirst();
        // 如果不存在就返回空
        if (!callMaterialModelOptional.isPresent()) {
            return null;
        }
        return callMaterialModelOptional.get();
    }

    /**
     * 执行调度-添加任务
     *
     * @param startSiteId   起始点ID
     * @param taskNo        任务单号
     * @param destinationId 目标点ID
     * @return 添加结果
     */
    private DeliveryTask executeSchedulerAddTask(long startSiteId, String taskNo, long destinationId, long materialBoxId, String errorMessage, boolean containerArrivedFlag) {
        Site source = siteService.get(startSiteId);
        source.setOrderNo(taskNo); // 设置任务单号
        Site destination = siteService.get(destinationId);
        MaterialBoxModel materialBox = materialBoxDao.selectMaterialBoxById(materialBoxId);
        // 如果需要则执行容器入场
        if (containerArrivedFlag) {
            // 目标点容器入场失败则无法执行下发任务
            if (!scheduler.onContainerArrived(materialBox.getCode(), source, null)) {
                Tracker.error("容器入场失败");
                Tracker.error(errorMessage);
                return null;
            }
        }
        Task task = scheduler.addTask(source, destination);
        if (ObjectUtils.isEmpty(task)) {
            if (containerArrivedFlag) {
                // 入场成功后出现错误，执行容器离场
                scheduler.onContainerLeft(materialBox.getCode(), source, null);
            }
            Tracker.error(errorMessage);
            return null;
        }
        return new DeliveryTask(taskNo, task.getWcsTaskId(), source.getId(), destination.getId(), materialBoxId, null, 0);
    }

    /**
     * 通过料框中的原料列表，更新叫料列表中的状态
     *
     * @param materialBoxMaterialModels 料框原料列表
     * @param callMaterialModels        叫料列表
     */
    public void updateCallMaterialState(List<MaterialBoxMaterialModel> materialBoxMaterialModels, List<CallMaterialModel> callMaterialModels, int state) {
        // 将与料框上原料对应的叫料置为配送中
        materialBoxMaterialModels.forEach(sendMaterial -> {
            CallMaterialModel callMaterialModel = findFirstCallMaterialModel(callMaterialModels, sendMaterial);
            if (ObjectUtils.isEmpty(callMaterialModel)) {
                return;
            }
            // 改为配送中
            callMaterialDao.updateCallMaterialState(callMaterialModel.getId(), state);
        });
    }

    /**
     * 通过WCS的任务ID查找配送任务
     *
     * @param workflowWorkId wcs任务ID
     * @return 配送任务
     */
    public DeliveryTaskModel selectDeliveryTaskModelByWorkflowWorkId(String workflowWorkId) {
        return deliveryTaskDao.selectDeliveryTaskModelByWorkflowWorkId(workflowWorkId);
    }

    /**
     * 通过ID对任务状态进行修改
     *
     * @param id    任务ID
     * @param state 任务状态
     * @return 是否成功
     */
    public void updateStateById(long id, int state) {
        deliveryTaskDao.updateStateById(id, state);
    }

    /**
     * 通过WCS任务ID修改机器人
     *
     * @param workflowWorkId WCS任务ID
     * @param robotId        机器人
     */
    public void updateRobotByWorkflowWorkId(String workflowWorkId, String robotId) {
        deliveryTaskDao.updateRobotByWorkflowWorkId(workflowWorkId, robotId);
    }
}
