package com.furongsoft.agv.schedulers;

import com.furongsoft.agv.entities.Area;
import com.furongsoft.agv.entities.Site;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
public interface IScheduler {
    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的区域
     * @return 任务
     */
    Task AddTask(Site source, Area destination);

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的站点
     * @return 任务
     */
    Task AddTask(Site source, Site destination);

    /**
     * 取消任务
     *
     * @param task 任务
     * @return 是否成功
     */
    boolean Cancel(Task task);

    /**
     * 取消指定源站点所有任务
     *
     * @param source 源站点
     * @return 是否成功
     */
    boolean Cancel(Site source);

    /**
     * 搬运开始事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void OnMovingStarted(String agvId, String taskId, String event);

    /**
     * 搬运完成事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void OnMovingArrived(String agvId, String taskId, String event);

    /**
     * 搬运暂停事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void OnMovingPaused(String agvId, String taskId, String event);

    /**
     * 搬运等待事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void OnMovingWaiting(String agvId, String taskId, String event);

    /**
     * 搬运取消事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void OnMovingCancelled(String agvId, String taskId, String event);

    /**
     * 搬运失败事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void OnMovingFail(String agvId, String taskId, String event);

    /**
     * 容器进场事件
     *
     * @param containerId 容器索引
     * @param target      目的站点
     * @param event       事件消息
     */
    void OnContainerArrived(String containerId, Site target, String event);

    /**
     * 容器离场事件
     *
     * @param containerId 容器索引
     * @param target      目的站点
     * @param event       事件消息
     */
    void OnContainerLeft(String containerId, Site target, String event);
}
