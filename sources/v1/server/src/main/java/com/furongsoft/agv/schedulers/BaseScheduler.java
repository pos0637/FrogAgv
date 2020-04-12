package com.furongsoft.agv.schedulers;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.entities.Task.Status;
import com.furongsoft.base.misc.Tracker;

/**
 * AGV调度管理器
 * 
 * @author Alex
 */
public abstract class BaseScheduler implements IScheduler {
    /**
     * 区域列表
     */
    protected List<Area> areas;

    /**
     * 任务列表
     */
    protected List<Task> tasks;

    @Override
    synchronized public void Initialize(Area[] areas) {
        this.areas = Arrays.asList(areas);
    }

    @Override
    synchronized public boolean Cancel(Task task) {
        tasks.remove(task);
        return true;
    }

    @Override
    synchronized public boolean Cancel(Site source) {
        getTaskBySource(source.getCode()).ifPresent(t -> tasks.remove(t));
        return true;
    }

    @Override
    synchronized public void OnMovingStarted(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(t -> {
            t.setStatus(Status.Moving);
            log(String.format("OnMovingStarted: task: %s, agv: %s, event: %s", t.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void OnMovingArrived(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(t -> {
            t.setStatus(Status.Arrived);
            log(String.format("OnMovingArrived: task: %s, agv: %s, event: %s", t.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void OnMovingPaused(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(t -> {
            t.setStatus(Status.Paused);
            log(String.format("OnMovingPaused: task: %s, agv: %s, event: %s", t.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void OnMovingWaiting(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(t -> {
            t.setStatus(Status.Paused);
            log(String.format("OnMovingWaiting: task: %s, agv: %s, event: %s", t.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void OnMovingCancelled(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(t -> {
            t.setStatus(Status.Cancelled);
            log(String.format("OnMovingCancelled: task: %s, agv: %s, event: %s", t.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void OnMovingFail(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(t -> {
            t.setStatus(Status.Fail);
            log(String.format("OnMovingFail: task: %s, agv: %s, event: %s", t.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void OnContainerArrived(String containerId, Site destination, String event) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination.getCode());
        if (site != null) {
            site.setContainerId(containerId);
            log(String.format("OnContainerArrived: container: %s, event: %s", containerId, event));
        }
    }

    @Override
    synchronized public void OnContainerLeft(String containerId, Site destination, String event) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination.getCode());
        if (site != null) {
            site.setContainerId(null);
            log(String.format("OnContainerLeft: container: %s, event: %s", containerId, event));
        }
    }

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的区域
     * @param wcsTaskId   WCS任务索引
     * @return 任务
     */
    synchronized protected Task AddTask(Site source, AgvArea destination, String wcsTaskId) {
        Optional<com.furongsoft.agv.schedulers.entities.Site> site = getFreeSite(destination.getCode());
        if (site.isEmpty()) {
            log(String.format("AddTask destinationArea is full: %s, %s", destination.getName(), destination.getCode()));
            site = getDefaultSite(destination.getCode());
        }

        if (site.isEmpty()) {
            return null;
        }

        Task task = new Task(source.getCode(), site.get().getCode(), null, wcsTaskId, true, true, Status.Initialized);
        tasks.add(task);

        return task;
    }

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的站点
     * @param wcsTaskId   WCS任务索引
     * @return 任务
     */
    synchronized protected Task AddTask(Site source, Site destination, String wcsTaskId) {
        if ((getSite(source.getCode()) == null) || (getSite(destination.getCode()) == null)) {
            return null;
        }

        Task task = new Task(source.getCode(), destination.getCode(), null, wcsTaskId, false, true, Status.Initialized);
        tasks.add(task);

        return task;
    }

    /**
     * 获取站点
     * 
     * @param code 站点编码
     * @return 站点
     */
    synchronized protected com.furongsoft.agv.schedulers.entities.Site getSite(String code) {
        for (Area area : areas) {
            for (com.furongsoft.agv.schedulers.entities.Site s : area.getSites()) {
                if (s.getCode().equals(code)) {
                    return s;
                }
            }
        }

        return null;
    }

    /**
     * 获取空闲站点
     * 
     * @param destinationArea 目的区域编码
     * @return 空闲站点
     */
    synchronized protected Optional<com.furongsoft.agv.schedulers.entities.Site> getFreeSite(String destinationArea) {
        return areas.stream().filter(a -> a.getCode().equals(destinationArea)).findFirst().map(a -> getFreeSite(a))
                .orElse(Optional.empty());
    }

    /**
     * 获取空闲站点
     * 
     * @param area 区域
     * @return 空闲站点
     */
    synchronized protected Optional<com.furongsoft.agv.schedulers.entities.Site> getFreeSite(Area area) {
        return area.getSites().stream()
                .filter(s -> (s.getContainerId() == null) && getTaskByDestination(s.getCode()).isEmpty()).findFirst();
    }

    /**
     * 获取默认站点
     * 
     * @param area 目的区域编码
     * @return 站点
     */
    synchronized protected Optional<com.furongsoft.agv.schedulers.entities.Site> getDefaultSite(
            String destinationArea) {
        return areas.stream().filter(a -> a.getCode().equals(destinationArea)).findFirst().map(a -> getDefaultSite(a))
                .orElse(Optional.empty());
    }

    /**
     * 获取默认站点
     * 
     * @param area 区域
     * @return 站点
     */
    synchronized protected Optional<com.furongsoft.agv.schedulers.entities.Site> getDefaultSite(Area area) {
        return area.getSites().stream().findFirst();
    }

    /**
     * 获取任务
     * 
     * @param source 源站点编码
     * @return 任务
     */
    synchronized protected Optional<Task> getTaskBySource(String source) {
        return tasks.stream().filter(t -> t.getSource().equals(source)).findFirst();
    }

    /**
     * 获取任务
     * 
     * @param destination 目的站点编码
     * @return 任务
     */
    synchronized protected Optional<Task> getTaskByDestination(String destination) {
        return tasks.stream().filter(t -> t.getDestination().equals(destination)).findFirst();
    }

    /**
     * 获取任务
     * 
     * @param destination WCS任务索引
     * @return 任务
     */
    synchronized protected Optional<Task> getTaskByWcsTaskId(String wcsTaskId) {
        return tasks.stream().filter(t -> t.getWcsTaskId().equals(wcsTaskId)).findFirst();
    }

    /**
     * 日志
     * 
     * @param content 内容
     */
    protected void log(String content) {
        Tracker.info("[AGV]" + content);
    }
}
