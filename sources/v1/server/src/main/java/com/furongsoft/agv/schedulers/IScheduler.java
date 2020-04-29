package com.furongsoft.agv.schedulers;

import java.util.List;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Task;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
public interface IScheduler {
    /**
     * 初始化
     */
    void initialize();

    /**
     * 初始化
     *
     * @param areas        区域列表
     * @param notification AGV调度管理器事件接口
     */
    void initialize(List<Area> areas, ISchedulerNotification notification);

    /**
     * 移除所有站点内容器
     */
    void removeAllContainers();

    /**
     * 获取任务列表
     * 
     * @return 任务列表
     */
    List<Task> getTasks();

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的区域
     * @return 任务
     */
    Task addTask(Site source, AgvArea destination);

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的站点
     * @return 任务
     */
    Task addTask(Site source, Site destination);

    /**
     * 取消任务
     *
     * @param task 任务
     * @return 是否成功
     */
    boolean cancel(Task task);

    /**
     * 取消指定源站点所有任务
     *
     * @param source 源站点
     * @return 是否成功
     */
    boolean cancel(Site source);

    /**
     * 搬运开始事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void onMovingStarted(String agvId, String taskId, String event);

    /**
     * 搬运完成事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void onMovingArrived(String agvId, String taskId, String event);

    /**
     * 搬运暂停事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void onMovingPaused(String agvId, String taskId, String event);

    /**
     * 搬运等待事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void onMovingWaiting(String agvId, String taskId, String event);

    /**
     * 搬运取消事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void onMovingCancelled(String agvId, String taskId, String event);

    /**
     * 搬运失败事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     * @param event  事件消息
     */
    void onMovingFail(String agvId, String taskId, String event);

    /**
     * 容器进场事件
     *
     * @param containerId 容器索引
     * @param destination 目的站点编码
     * @param event       事件消息
     * @return 是否成功
     */
    boolean onContainerArrived(String containerId, String destination, String event);

    /**
     * 容器离场事件
     *
     * @param containerId 容器索引
     * @param destination 目的站点编码
     * @param event       事件消息
     * @return 是否成功
     */
    boolean onContainerLeft(String containerId, String destination, String event);
}
