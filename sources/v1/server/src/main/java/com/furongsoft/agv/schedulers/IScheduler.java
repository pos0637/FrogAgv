package com.furongsoft.agv.schedulers;

import java.util.List;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.entities.Task;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
public interface IScheduler {
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
     * @throws Exception 异常
     */
    Task addTask(Site source, AgvArea destination) throws Exception;

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的站点
     * @return 任务
     * @throws Exception 异常
     */
    Task addTask(Site source, Site destination) throws Exception;

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
     * 容器进场
     *
     * @param containerId 容器索引
     * @param destination 目的站点编码
     * @return 是否成功
     * @throws Exception 异常
     */
    boolean addContainer(String containerId, String destination) throws Exception;

    /**
     * 容器离场
     *
     * @param containerId 容器索引
     * @param destination 目的站点编码
     * @return 是否成功
     */
    boolean removeContainer(String containerId, String destination);

    /**
     * 添加任务事件
     *
     * @param source      源站点编码
     * @param destination 目的站点编码
     * @return 任务
     */
    Task onAddTask(String source, String destination);

    /**
     * 取消任务事件
     *
     * @param task 任务
     * @return 是否成功
     */
    boolean onCancel(Task task);

    /**
     * 搬运开始事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     */
    void onMovingStarted(String agvId, String taskId);

    /**
     * 搬运完成事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     */
    void onMovingArrived(String agvId, String taskId);

    /**
     * 搬运暂停事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     */
    void onMovingPaused(String agvId, String taskId);

    /**
     * 搬运等待事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     */
    void onMovingWaiting(String agvId, String taskId);

    /**
     * 搬运取消事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     */
    void onMovingCancelled(String agvId, String taskId);

    /**
     * 搬运失败事件
     *
     * @param agvId  AGV索引
     * @param taskId 任务索引
     */
    void onMovingFail(String agvId, String taskId);

    /**
     * 容器进场事件
     *
     * @param containerId 容器索引
     * @param destination 目的站点编码
     * @return 是否成功
     */
    boolean onContainerArrived(String containerId, String destination);

    /**
     * 容器离场事件
     *
     * @param containerId 容器索引
     * @param destination 目的站点编码
     * @return 是否成功
     */
    boolean onContainerLeft(String containerId, String destination);
}
