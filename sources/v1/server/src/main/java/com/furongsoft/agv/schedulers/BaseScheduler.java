package com.furongsoft.agv.schedulers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.entities.Task.Status;
import com.furongsoft.base.misc.StringUtils;
import com.furongsoft.base.misc.Tracker;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
public abstract class BaseScheduler implements IScheduler {
    /**
     * AGV调度管理器事件接口
     */
    protected ISchedulerNotification notification;

    /**
     * 区域列表
     */
    protected List<Area> areas = new ArrayList<>();

    /**
     * 任务列表
     */
    protected List<Task> tasks = new LinkedList<>();

    @Override
    synchronized public void initialize(Area[] areas, ISchedulerNotification notification) {
        if (null == areas) {
            this.areas = new ArrayList<>();
        } else {
            this.areas = Arrays.asList(areas);
        }
        this.notification = notification;
    }

    @Override
    synchronized public boolean cancel(Task task) {
        tasks.remove(task);
        return true;
    }

    @Override
    synchronized public boolean cancel(Site source) {
        Optional<Task> task = getTaskBySource(source.getCode());
        return task.isPresent() && cancel(task.get());
    }

    @Override
    synchronized public void onMovingStarted(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Moving);
            notification.onMovingStarted(agvId, task);
            Tracker.agv(String.format("OnMovingStarted: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingArrived(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Arrived);
            notification.onMovingArrived(agvId, task);
            Tracker.agv(String.format("OnMovingArrived: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingPaused(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Paused);
            notification.onMovingPaused(agvId, task);
            Tracker.agv(String.format("OnMovingPaused: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingWaiting(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Paused);
            notification.onMovingWaiting(agvId, task);
            Tracker.agv(String.format("OnMovingWaiting: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingCancelled(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Cancelled);
            notification.onMovingCancelled(agvId, task);
            Tracker.agv(
                    String.format("OnMovingCancelled: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingFail(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Fail);
            notification.onMovingFail(agvId, task);
            Tracker.agv(String.format("OnMovingFail: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public boolean onContainerArrived(String containerId, Site destination, String event) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination.getCode());
        if (site == null) {
            return false;
        }

        if (!StringUtils.isNullOrEmpty(site.getContainerId())) {
            return false;
        }

        site.setContainerId(containerId);
        notification.onContainerArrived(containerId, destination);
        Tracker.agv(String.format("OnContainerArrived: container: %s, event: %s", containerId, event));

        return true;
    }

    @Override
    synchronized public boolean onContainerLeft(String containerId, Site destination, String event) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination.getCode());
        if (site == null) {
            return false;
        }

        if (StringUtils.isNullOrEmpty(site.getContainerId())) {
            return false;
        }

        site.setContainerId(null);
        notification.onContainerLeft(containerId, destination);
        Tracker.agv(String.format("OnContainerLeft: container: %s, event: %s", containerId, event));

        return true;
    }

    /**
     * 添加任务
     *
     * @param source      源站点
     * @param destination 目的区域
     * @param wcsTaskId   WCS任务索引
     * @return 任务
     */
    synchronized protected Task addTask(Site source, AgvArea destination, String wcsTaskId) {
        Optional<com.furongsoft.agv.schedulers.entities.Site> site = getFreeSite(destination.getCode());
        if (site.isEmpty()) {
            Tracker.agv(String.format("AddTask destinationArea is full: %s, %s", destination.getName(),
                    destination.getCode()));
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
    synchronized protected Task addTask(Site source, Site destination, String wcsTaskId) {
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
        return areas.stream().filter(a -> a.getCode().equals(destinationArea)).findFirst().flatMap(this::getFreeSite);
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
     * @param destinationArea 目的区域编码
     * @return 站点
     */
    synchronized protected Optional<com.furongsoft.agv.schedulers.entities.Site> getDefaultSite(
            String destinationArea) {
        return areas.stream().filter(a -> a.getCode().equals(destinationArea)).findFirst()
                .flatMap(this::getDefaultSite);
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
     * @param wcsTaskId WCS任务索引
     * @return 任务
     */
    synchronized protected Optional<Task> getTaskByWcsTaskId(String wcsTaskId) {
        return tasks.stream().filter(t -> t.getWcsTaskId().equals(wcsTaskId)).findFirst();
    }

    /**
     * 站点内是否有容器
     *
     * @param code 站点编码
     * @return 是否有容器
     */
    synchronized protected Boolean hasContainer(String code) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(code);
        if (site == null) {
            return false;
        }

        return !StringUtils.isNullOrEmpty(site.getContainerId());
    }
}
