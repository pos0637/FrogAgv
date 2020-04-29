package com.furongsoft.agv.schedulers;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.entities.Task.Status;
import com.furongsoft.base.misc.StringUtils;
import com.furongsoft.base.misc.Tracker;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/v1/agv")
public abstract class BaseScheduler implements IBaseScheduler {
    /**
     * AGV调度管理器事件接口
     */
    protected Optional<ISchedulerNotification> notification = Optional.empty();

    /**
     * 区域列表
     */
    protected List<Area> areas = new ArrayList<>();

    /**
     * 任务列表
     */
    protected List<Task> tasks = new LinkedList<>();

    @Override
    synchronized public void initialize() {
    }

    @Override
    synchronized public void initialize(List<Area> areas, ISchedulerNotification notification) {
        this.areas = areas;
        this.notification = Optional.ofNullable(notification);
    }

    @Override
    synchronized public void removeAllContainers() {
        areas.forEach(area -> area.getSites().forEach(site -> onContainerLeft(null, site.getCode(), null)));
    }

    @Override
    synchronized public List<Task> getTasks() {
        return new ArrayList<Task>(tasks);
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
            task.setAgvId(agvId);
            task.setStatus(Status.Moving);
            notification.ifPresent(n -> n.onMovingStarted(agvId, task));
            Tracker.agv(String.format("OnMovingStarted: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingArrived(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Arrived);
            notification.ifPresent(n -> n.onMovingArrived(agvId, task));
            tasks.remove(task);
            Tracker.agv(String.format("OnMovingArrived: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingPaused(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Paused);
            notification.ifPresent(n -> n.onMovingPaused(agvId, task));
            Tracker.agv(String.format("OnMovingPaused: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingWaiting(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Paused);
            notification.ifPresent(n -> n.onMovingWaiting(agvId, task));
            Tracker.agv(String.format("OnMovingWaiting: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingCancelled(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Cancelled);
            notification.ifPresent(n -> n.onMovingCancelled(agvId, task));
            tasks.remove(task);
            Tracker.agv(
                    String.format("OnMovingCancelled: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public void onMovingFail(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Fail);
            notification.ifPresent(n -> n.onMovingFail(agvId, task));
            tasks.remove(task);
            Tracker.agv(String.format("OnMovingFail: task: %s, agv: %s, event: %s", task.toString(), agvId, event));
        });
    }

    @Override
    synchronized public boolean onContainerArrived(String containerId, String destination, String event) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination);
        if (site == null) {
            return false;
        }

        if (!StringUtils.isNullOrEmpty(site.getContainerId())) {
            return false;
        }

        site.setContainerId(containerId);
        notification.ifPresent(n -> n.onContainerArrived(containerId, destination));
        Tracker.agv(String.format("OnContainerArrived: container: %s, event: %s", containerId, event));

        return true;
    }

    @Override
    synchronized public boolean onContainerLeft(String containerId, String destination, String event) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination);
        if (site == null) {
            return false;
        }

        if (StringUtils.isNullOrEmpty(site.getContainerId())) {
            return false;
        }

        site.setContainerId(null);
        notification.ifPresent(n -> n.onContainerLeft(containerId, destination));
        Tracker.agv(String.format("OnContainerLeft: container: %s, event: %s", containerId, event));

        return true;
    }

    /**
     * 添加任务
     * 
     * @param source      源站点编码
     * @param destination 目的站点编码
     * @param wcsTaskId   WCS任务索引
     * @return 任务
     */
    synchronized protected Task addTask(String source, String destination, String wcsTaskId) {
        Task task = new Task(source, destination, null, wcsTaskId, null, true, true, Status.Initialized);
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
        return area.getSites().stream().filter(s -> isFreeSite(s)).findFirst();
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
     * 是否为空闲站点
     * 
     * @param code 站点编码
     * @return 是否为空闲站点
     */
    synchronized protected boolean isFreeSite(String code) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(code);
        if (site == null) {
            return false;
        }

        return isFreeSite(site);
    }

    /**
     * 是否为空闲站点
     * 
     * @param site 站点
     * @return 是否为空闲站点
     */
    synchronized protected boolean isFreeSite(com.furongsoft.agv.schedulers.entities.Site site) {
        return StringUtils.isNullOrEmpty(site.getContainerId()) && getTaskBySite(site.getCode()).isEmpty();
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
     * @param code 站点编码
     * @return 任务
     */
    synchronized protected Optional<Task> getTaskBySite(String code) {
        return tasks.stream().filter(t -> t.getSource().equals(code) || t.getDestination().equals(code)).findFirst();
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
    synchronized protected boolean hasContainer(String code) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(code);
        if (site == null) {
            return false;
        }

        return !StringUtils.isNullOrEmpty(site.getContainerId());
    }
}
