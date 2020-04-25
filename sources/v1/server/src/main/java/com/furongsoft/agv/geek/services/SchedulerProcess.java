package com.furongsoft.agv.geek.services;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.models.DeliveryTaskModel;
import com.furongsoft.agv.schedulers.ISchedulerNotification;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.geekplus.Scheduler;
import com.furongsoft.agv.services.DeliveryTaskService;
import com.furongsoft.agv.services.SiteService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 调度器处理事件
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class SchedulerProcess implements ISchedulerNotification {
    private final DeliveryTaskService deliveryTaskService;
    private final SiteService siteService;
    private final Scheduler scheduler;

    public SchedulerProcess(DeliveryTaskService deliveryTaskService, SiteService siteService, Scheduler scheduler) {
        this.deliveryTaskService = deliveryTaskService;
        this.siteService = siteService;
        this.scheduler = scheduler;
    }

    /**
     * 搬运开始事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    @Override
    public void onMovingStarted(String agvId, Task task) {

    }

    /**
     * 搬运完成事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    @Override
    public void onMovingArrived(String agvId, Task task) {
        DeliveryTaskModel deliveryTaskModel = deliveryTaskService.selectDeliveryTaskModelByWorkflowWorkId(task.getWcsTaskId());
        deliveryTaskService.updateStateById(deliveryTaskModel.getId(), 3); // 任务改成已完成
        siteService.addMaterialBox(deliveryTaskModel.getEndSiteId(), deliveryTaskModel.getMaterialBoxId()); // 在目标点添加料框，并设为有货
        // 容器离场 TODO
        scheduler.onContainerLeft(null, siteService.get(deliveryTaskModel.getEndSiteId()), null);
    }

    /**
     * 搬运暂停事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    @Override
    public void onMovingPaused(String agvId, Task task) {

    }

    /**
     * 搬运等待事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    @Override
    public void onMovingWaiting(String agvId, Task task) {

    }

    /**
     * 搬运取消事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    @Override
    public void onMovingCancelled(String agvId, Task task) {

    }

    /**
     * 搬运失败事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    @Override
    public void onMovingFail(String agvId, Task task) {

    }

    /**
     * 容器进场事件
     *
     * @param containerId 容器索引
     * @param target      目的站点
     */
    @Override
    public void onContainerArrived(String containerId, Site target) {

    }

    /**
     * 容器离场事件
     *
     * @param containerId 容器索引
     * @param target      目的站点
     */
    @Override
    public void onContainerLeft(String containerId, Site target) {

    }

    /**
     * 小车接单回调
     *
     * @param workflowWorkId 搬运系统任务ID
     * @param robotId        小车唯一标识
     */
    @Override
    public void onAcceptTask(String workflowWorkId, String robotId) {
        DeliveryTaskModel deliveryTaskModel = deliveryTaskService.selectDeliveryTaskModelByWorkflowWorkId(workflowWorkId);
        deliveryTaskService.updateRobotByWorkflowWorkId(workflowWorkId, robotId);
        deliveryTaskService.updateStateById(deliveryTaskModel.getId(), 1); // 将配送任务修改为取货中
    }

    /**
     * 取走容器回调
     *
     * @param workflowWorkId 搬运系统任务ID
     * @param robotId        小车唯一标识
     */
    @Override
    public void onTakeAway(String workflowWorkId, String robotId) {
        DeliveryTaskModel deliveryTaskModel = deliveryTaskService.selectDeliveryTaskModelByWorkflowWorkId(workflowWorkId);
        deliveryTaskService.updateStateById(deliveryTaskModel.getId(), 2); // 将配送任务修改为配送中
        siteService.addMaterialBox(deliveryTaskModel.getStartSiteId(), deliveryTaskModel.getMaterialBoxId()); // 在起始点删除料框，并设为空闲
    }
}
