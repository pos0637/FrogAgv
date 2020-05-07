package com.furongsoft.agv.geek.services;

import com.furongsoft.agv.models.DeliveryTaskModel;
import com.furongsoft.agv.schedulers.ISchedulerNotification;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.geekplus.Scheduler;
import com.furongsoft.agv.services.DeliveryTaskService;
import com.furongsoft.agv.services.SiteService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

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

    @Override
    public void onMovingStarted(String agvId, Task task) {
        DeliveryTaskModel deliveryTaskModel = deliveryTaskService
                .selectDeliveryTaskModelByWorkflowWorkId(task.getWcsTaskId());
        if (!ObjectUtils.isEmpty(deliveryTaskModel)) {
            deliveryTaskService.updateRobotByWorkflowWorkId(task.getWcsTaskId(), agvId);
            deliveryTaskService.updateStateById(deliveryTaskModel.getId(), 1); // 将配送任务修改为取货中
        }
    }

    @Override
    public void onMovingArrived(String agvId, Task task) {
        DeliveryTaskModel deliveryTaskModel = deliveryTaskService
                .selectDeliveryTaskModelByWorkflowWorkId(task.getWcsTaskId());
        if (!ObjectUtils.isEmpty(deliveryTaskModel)) {
            deliveryTaskService.updateStateById(deliveryTaskModel.getId(), 3); // 任务改成已完成
            siteService.addMaterialBox(deliveryTaskModel.getEndSiteId(), deliveryTaskModel.getMaterialBoxId()); // 在目标点添加料框，并设为有货
            siteService.removeMaterialBox(deliveryTaskModel.getStartSiteId()); // 在起始点删除料框，并设为空闲

            // TODO 叫料如果存在，改为已完成
        }
    }

    @Override
    public void onMovingPaused(String agvId, Task task) {

    }

    @Override
    public void onMovingWaiting(String agvId, Task task) {

    }

    @Override
    public void onMovingCancelled(String agvId, Task task) {

    }

    @Override
    public void onMovingFail(String agvId, Task task) {

    }

    @Override
    public void onContainerArrived(String containerId, String destination) {

    }

    @Override
    public void onContainerLeft(String containerId, String destination) {

    }

    /**
     * 取走容器回调
     *
     * @param agvId 搬运系统任务ID
     * @param task        小车唯一标识
     */
    @Override
    public void onTakeAway(String agvId, Task task) {
        DeliveryTaskModel deliveryTaskModel = deliveryTaskService
                .selectDeliveryTaskModelByWorkflowWorkId(task.getWcsTaskId());
        if (!ObjectUtils.isEmpty(deliveryTaskModel)) {
            deliveryTaskService.updateStateById(deliveryTaskModel.getId(), 2); // 将配送任务修改为配送中
            siteService.removeMaterialBox(deliveryTaskModel.getStartSiteId()); // 在起始点删除料框，并设为空闲
        }
    }
}
