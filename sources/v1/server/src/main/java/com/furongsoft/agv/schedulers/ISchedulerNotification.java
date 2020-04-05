package com.furongsoft.agv.schedulers;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.entities.Task;

/**
 * AGV调度管理器事件接口
 */
public interface ISchedulerNotification {
    /**
     * 搬运开始事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    void OnMovingStarted(String agvId, Task task);

    /**
     * 搬运完成事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    void OnMovingArrived(String agvId, Task task);

    /**
     * 搬运暂停事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    void OnMovingPaused(String agvId, Task task);

    /**
     * 搬运等待事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    void OnMovingWaiting(String agvId, Task task);

    /**
     * 搬运取消事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    void OnMovingCancelled(String agvId, Task task);

    /**
     * 搬运失败事件
     *
     * @param agvId AGV索引
     * @param task  任务
     */
    void OnMovingFail(String agvId, Task task);

    /**
     * 容器进场事件
     *
     * @param containerId 容器索引
     * @param target      目的站点
     */
    void OnContainerArrived(String containerId, Site target);

    /**
     * 容器离场事件
     *
     * @param containerId 容器索引
     * @param target      目的站点
     */
    void OnContainerLeft(String containerId, Site target);
}
