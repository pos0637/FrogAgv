package com.furongsoft.agv.services;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.DeliveryTask;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.mappers.CallMaterialDao;
import com.furongsoft.agv.mappers.DeliveryTaskDao;
import com.furongsoft.agv.mappers.MaterialBoxDao;
import com.furongsoft.agv.mappers.MaterialBoxMaterialDao;
import com.furongsoft.agv.models.AgvAreaModel;
import com.furongsoft.agv.models.CallMaterialModel;
import com.furongsoft.agv.models.DeliveryTaskModel;
import com.furongsoft.agv.models.MaterialBoxMaterialModel;
import com.furongsoft.agv.models.MaterialBoxModel;
import com.furongsoft.agv.models.SiteModel;
import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.entities.Material;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.base.exceptions.BaseException;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.base.services.BaseService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;

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
    public DeliveryTaskService(SiteService siteService, CallMaterialDao callMaterialDao,
                               DeliveryTaskDao deliveryTaskDao, MaterialBoxDao materialBoxDao,
                               MaterialBoxMaterialDao materialBoxMaterialDao, IScheduler scheduler) {
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
     * @return 配送管理详情
     */
    public DeliveryTaskModel selectDeliveryTaskById(Long id) {
        return deliveryTaskDao.selectDeliveryTaskById(id);
    }

    /**
     * 添加配送任务
     *
     * @param deliveryTaskModel 添加配送任务的参数
     * @return 是否添加成功
     * @throws Exception
     */
    public boolean addDeliveryTask(DeliveryTaskModel deliveryTaskModel) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String currentTime = sdf.format(new Date());
        String taskNo;
        // 获取料框中的原料
        List<MaterialBoxMaterialModel> materialBoxMaterialModels = materialBoxMaterialDao
                .selectMaterialBoxMaterialByMaterialBoxId(deliveryTaskModel.getMaterialBoxId());
        switch (deliveryTaskModel.getType()) {
            case 1: { // 消毒-灌装;
                taskNo = "PS" + currentTime;
                // 获取灌装区指定生产线的库位列表
                AgvAreaModel location = siteService.selectProductLocationByAreaCodeAndLineCode("PRODUCT_FILLING",
                        deliveryTaskModel.getProductLine());
                // TODO 同样无法获取到站点信息
                List<SiteModel> siteModels = siteService.selectLocationsByAreaIdWithMaterialBox(location.getId());
                // 判断站点是否有叫料，有则下发任务。任务成功则结束循环，任务失败则进入下一个循环
                for (SiteModel siteModel : siteModels) {
                    // 站点未配送的叫料集合
                    List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(1, 1,
                            null, siteModel.getId());
                    if (CollectionUtils.isEmpty(callMaterialModels)) {
                        continue;
                    }
                    MaterialBoxModel materialBoxModel = siteService
                            .selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                    Task task = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo,
                            siteModel.getId(), materialBoxModel.getId(), "消毒-灌装下发配送任务失败。", true, materialBoxMaterialModels);
                    if (ObjectUtils.isEmpty(task)) {
                        continue;
                    }
                    // TODO 持有task
                    DeliveryTask deliveryTask = new DeliveryTask(taskNo, task.getWcsTaskId(), deliveryTaskModel.getStartSiteId(), siteModel.getId(), materialBoxModel.getId(), null,
                            0);
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
            case 2: { // 灌装-消毒;
                taskNo = "TH" + currentTime;
                AgvArea agvArea = siteService.selectAgvAreaByCode("XD_LOCATION");
                Task task = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, agvArea, 0, "灌装-消毒下发退货任务失败。", true, null);
                if (ObjectUtils.isEmpty(task)) {
                    return false;
                }
                // TODO 持有task
                DeliveryTask deliveryTask = new DeliveryTask(taskNo, task.getWcsTaskId(), deliveryTaskModel.getStartSiteId(), Long.parseLong(task.getDestination()), 0, null, 0);
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 3: { // 包材-拆包;
                taskNo = "PS" + currentTime;
                AgvArea agvArea = siteService.selectAgvAreaByCode("CB_LOCATION");
                // 获取拆包间叫料信息
                List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(4, 1, null,
                        null);
                if (CollectionUtils.isEmpty(callMaterialModels)) {
                    Tracker.error("包材-拆包配送失败。拆包间无叫料");
                    throw new BaseException("拆包间无未配送的叫料请求,无法发货");
                }
                MaterialBoxModel materialBoxModel = siteService
                        .selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                Task task = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, agvArea, materialBoxModel.getId(), "包材-拆包下发送货任务失败。", true, materialBoxMaterialModels);
                if (ObjectUtils.isEmpty(task)) {
                    return false;
                }
                // TODO 持有task
                DeliveryTask deliveryTask = new DeliveryTask(taskNo, task.getWcsTaskId(), deliveryTaskModel.getStartSiteId(), Long.parseLong(task.getDestination()), materialBoxModel.getId(), null, 0);
                // 更新叫料状态为配送中
                updateCallMaterialState(materialBoxMaterialModels, callMaterialModels, 2);
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 4: { // 拆包-包材;
                taskNo = "TH" + currentTime;
                AgvArea agvArea = siteService.selectAgvAreaByCode("BC_CB_LOCATION");
                Task task = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, agvArea, 0, "拆包-包材下发退货任务失败。", true, null);
                if (ObjectUtils.isEmpty(task)) {
                    return false;
                }
                // TODO 持有task
                DeliveryTask deliveryTask = new DeliveryTask(taskNo, task.getWcsTaskId(), deliveryTaskModel.getStartSiteId(), Long.parseLong(task.getDestination()), 0, null, 0);
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 5: { // 包材-包装;
                taskNo = "PS" + currentTime;
                AgvAreaModel location = siteService.selectProductLocationByAreaCodeAndLineCode("PRODUCT_PACKAGING",
                        deliveryTaskModel.getProductLine());
                List<AgvAreaModel> agvAreaModels = siteService.selectAreasByParentId(location.getId(), 8);
                // 如果找不到产线的库位区域则返回失败
                if (CollectionUtils.isEmpty(agvAreaModels)) {
                    return false;
                }

                // TODO 通过生产线区域找到对应的生产线库位区域
                // TODO 没有获取到站点集合
                List<SiteModel> siteModels = siteService.selectLocationsByAreaIdWithMaterialBox(agvAreaModels.get(0).getId());
                // 判断站点是否有叫料，有则下发任务。任务成功则结束循环，任务失败则进入下一个循环
                for (SiteModel siteModel : siteModels) {
                    // 站点未配送的叫料集合
                    List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialsByConditions(2, 1,
                            null, siteModel.getId());
                    if (CollectionUtils.isEmpty(callMaterialModels)) {
                        continue;
                    }
                    MaterialBoxModel materialBoxModel = siteService
                            .selectMaterialBoxBySiteId(deliveryTaskModel.getStartSiteId());
                    Task task = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo,
                            siteModel.getId(), materialBoxModel.getId(), "包材-包装下发配送任务失败。", true, materialBoxMaterialModels);
                    if (ObjectUtils.isEmpty(task)) {
                        continue;
                    }
                    // TODO 持有task
                    DeliveryTask deliveryTask = new DeliveryTask(taskNo, task.getWcsTaskId(), deliveryTaskModel.getStartSiteId(), siteModel.getId(), materialBoxModel.getId(), null,
                            0);
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
            case 6: { // 包装-包材;
                taskNo = "TH" + currentTime;
                // 查找包材-包装空闲库位
                AgvArea agvArea = siteService.selectAgvAreaByCode("BC_BZ_LOCATION");
                Task task = executeSchedulerAddTask(deliveryTaskModel.getStartSiteId(), taskNo, agvArea, 0, "包装-包材下发退货任务失败。", true, null);
                if (ObjectUtils.isEmpty(task)) {
                    return false;
                }
                // TODO 持有task
                DeliveryTask deliveryTask = new DeliveryTask(taskNo, task.getWcsTaskId(), deliveryTaskModel.getStartSiteId(), Long.parseLong(task.getDestination()), 0, null,
                        0);
                if (ObjectUtils.isEmpty(deliveryTask)) {
                    return false;
                }
                boolean addTaskFlag = insert(deliveryTask);
                if (addTaskFlag) {
                    siteService.addDeliveryTask(deliveryTaskModel.getStartSiteId(), deliveryTask.getId());
                }
                return addTaskFlag;
            }
            case 7: { // 拆包-消毒 改成直接通过波次配送
                // 获取波次以及叫料区域类型，找出消毒间未配送的叫料
                List<CallMaterialModel> callMaterialModels = callMaterialDao.selectCallMaterialByWaveCodeAndAreaType(deliveryTaskModel.getWaveCode(), 3, 1);
                if (CollectionUtils.isEmpty(callMaterialModels)) {
                    Tracker.error("拆包-消毒配送失败。消毒间无叫料");
                    throw new BaseException("该波次已配送,无法发货");
                }
                // 更新叫料状态为已完成
                updateCallMaterialState(callMaterialModels, 3);
                return true;
            }
        }
        return false;
    }

    /**
     * 查找原料和数量与料框中相同的叫料信息
     *
     * @param callMaterialModels       叫料集合
     * @param materialBoxMaterialModel 料框中的原料信息
     * @return 叫料信息
     */
    private CallMaterialModel findFirstCallMaterialModel(List<CallMaterialModel> callMaterialModels,
                                                         MaterialBoxMaterialModel materialBoxMaterialModel) {
        Optional<CallMaterialModel> callMaterialModelOptional = callMaterialModels.stream()
                .filter(ca -> (ca.getMaterialId() == materialBoxMaterialModel.getMaterialId()
                        && ca.getCount() == materialBoxMaterialModel.getCount()))
                .findFirst();
        // 如果不存在就返回空
        return callMaterialModelOptional.orElse(null);
    }

    /**
     * 执行调度-添加任务
     *
     * @param startSiteId   起始点ID
     * @param taskNo        任务单号
     * @param destinationId 目标点ID
     * @return 添加结果
     * @throws Exception
     */
    private Task executeSchedulerAddTask(long startSiteId, String taskNo, long destinationId,
                                         long materialBoxId, String errorMessage, boolean containerArrivedFlag, List<MaterialBoxMaterialModel> materialBoxMaterialModels) throws Exception {
        Site source = siteService.get(startSiteId);
        source.setOrderNo(taskNo); // 设置任务单号
        Site destination = siteService.get(destinationId);
        MaterialBoxModel materialBox = materialBoxDao.selectMaterialBoxById(materialBoxId);
        // 如果需要则执行容器入场
        if (containerArrivedFlag) {
            // 目标点容器入场失败则无法执行下发任务
            if (!scheduler.addContainer(materialBox.getCode(), source.getCode())) {
                Tracker.error("容器入场失败");
                Tracker.error(errorMessage);
                return null;
            }
        }
        List<Material> materials = new ArrayList<>();
        if (!CollectionUtils.isEmpty(materialBoxMaterialModels)) {
            materialBoxMaterialModels.forEach(materialBoxMaterialModel -> {
                materials.add(new Material(materialBoxMaterialModel.getMaterialUUID(), materialBoxMaterialModel.getCount()));
            });
        }
        Task task = scheduler.addTask(source, destination, materials);
        if (ObjectUtils.isEmpty(task)) {
            if (containerArrivedFlag) {
                // 入场成功后出现错误，执行容器离场
                scheduler.removeContainer(materialBox.getCode(), source.getCode());
            }
            Tracker.error(errorMessage);
            return null;
        }
        return task;
    }

    /**
     * 执行调度器的添加任务
     *
     * @param startSiteId               起始站点ID
     * @param taskNo                    任务单号
     * @param destination               终点区域
     * @param materialBoxId             料框ID
     * @param errorMessage              错误提示信息
     * @param containerArrivedFlag      是否需要执行容器入场
     * @param materialBoxMaterialModels 料车上的原料列表
     * @return 调度器任务对象
     * @throws Exception
     */
    private Task executeSchedulerAddTask(long startSiteId, String taskNo, AgvArea destination,
                                         long materialBoxId, String errorMessage, boolean containerArrivedFlag, List<MaterialBoxMaterialModel> materialBoxMaterialModels) throws Exception {
        Site source = siteService.get(startSiteId);
        source.setOrderNo(taskNo); // 设置任务单号
        MaterialBoxModel materialBox = materialBoxDao.selectMaterialBoxById(materialBoxId);
        String materialBoxCode = null;
        if (!ObjectUtils.isEmpty(materialBox)) {
            materialBoxCode = materialBox.getCode();
        }
        // 如果需要则执行容器入场
        if (containerArrivedFlag) {
            // 目标点容器入场失败则无法执行下发任务
            if (!scheduler.addContainer(materialBoxCode, source.getCode())) {
                Tracker.error("容器入场失败");
                Tracker.error(errorMessage);
                return null;
            }
        }
        List<Material> materials = new ArrayList<>();
        if (!CollectionUtils.isEmpty(materialBoxMaterialModels)) {
            materialBoxMaterialModels.forEach(materialBoxMaterialModel -> {
                materials.add(new Material(materialBoxMaterialModel.getMaterialUUID(), materialBoxMaterialModel.getCount()));
            });
        }
        // 点到区域
        Task task = scheduler.addTask(source, destination, materials);
        if (ObjectUtils.isEmpty(task)) {
            if (containerArrivedFlag) {
                // 入场成功后出现错误，执行容器离场
                scheduler.removeContainer(materialBox.getCode(), source.getCode());
            }
            Tracker.error(errorMessage);
            return null;
        }
        return task;
    }

    /**
     * 通过料框中的原料列表，更新叫料列表中的状态
     *
     * @param materialBoxMaterialModels 料框原料列表
     * @param callMaterialModels        叫料列表
     */
    public void updateCallMaterialState(List<MaterialBoxMaterialModel> materialBoxMaterialModels,
                                        List<CallMaterialModel> callMaterialModels, int state) {
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
     * 更新叫料状态
     *
     * @param callMaterialModels 叫料列表
     * @param state              叫料状态
     */
    public void updateCallMaterialState(List<CallMaterialModel> callMaterialModels, int state) {
        callMaterialModels.forEach(callMaterialModel -> {
            // 修改配送状态
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
