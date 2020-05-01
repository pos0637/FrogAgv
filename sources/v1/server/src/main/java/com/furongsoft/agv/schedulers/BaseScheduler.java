package com.furongsoft.agv.schedulers;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.models.SiteModel;
import com.furongsoft.agv.schedulers.SchedulerException.NoEmptySiteException;
import com.furongsoft.agv.schedulers.SchedulerException.NonMaterialCarException;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Material;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.entities.Task.Status;
import com.furongsoft.agv.services.SiteService;
import com.furongsoft.base.misc.StringUtils;
import com.furongsoft.base.misc.Tracker;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
public abstract class BaseScheduler implements IScheduler, InitializingBean, Runnable {
    @Autowired
    private SiteService siteService;

    @Autowired
    @Lazy
    private ISchedulerNotification schedulerNotification;

    /**
     * AGV调度管理器事件接口
     */
    protected Optional<ISchedulerNotification> notification;

    /**
     * 区域列表
     */
    protected List<Area> areas = new ArrayList<>();

    /**
     * 任务列表
     */
    protected List<Task> tasks = new LinkedList<>();

    /**
     * 待执行任务列表
     */
    protected List<Task> pendingTasks = new LinkedList<>();

    @Override
    public void afterPropertiesSet() throws Exception {
        // 设置调度管理器事件接口
        notification = Optional.ofNullable(schedulerNotification);

        // 获取区域列表
        List<AgvArea> agvAreas = siteService.selectAgvAreasByType(8);
        areas = new ArrayList<Area>();
        agvAreas.forEach(agvArea -> {
            List<SiteModel> sites = siteService.selectLocationsByAreaId(agvArea.getId());
            List<com.furongsoft.agv.schedulers.entities.Site> siteList = new ArrayList<com.furongsoft.agv.schedulers.entities.Site>();
            sites.forEach(siteModel -> {
                siteList.add(new com.furongsoft.agv.schedulers.entities.Site(siteModel.getCode(),
                        siteModel.getMaterialBoxCode()));
            });
            areas.add(new Area(agvArea.getCode(), siteList));
        });

        // 启动守护线程
        new Thread(this).start();
    }

    @Override
    public synchronized void removeAllContainers() {
        areas.forEach(area -> area.getSites().forEach(site -> removeContainer(null, site.getCode())));
    }

    @Override
    public synchronized List<Task> getTasks() {
        return new ArrayList<Task>(tasks);
    }

    @Override
    public synchronized Task addTask(Site source, AgvArea destination, List<Material> materials) throws Exception {
        return addTask(source.getCode(), null, destination.getCode(), materials);
    }

    @Override
    public synchronized Task addTask(Site source, Site destination, List<Material> materials) throws Exception {
        return addTask(source.getCode(), destination.getCode(), null, materials);
    }

    @Override
    public synchronized boolean cancel(Task task) {
        return onCancel(task);
    }

    @Override
    public synchronized boolean cancel(Site source) {
        tasks.stream().filter(t -> t.getSource().equals(source.getCode())).map(this::cancel);
        return true;
    }

    @Override
    public synchronized boolean addContainer(String containerId, String destination) throws Exception {
        // 不允许向已有容器或已有任务的站点内发送容器
        if (!isFreeSite(destination)) {
            Tracker.agv("不允许向已有容器或已有任务的站点内发送容器:" + containerId + ", " + destination);
            throw new NoEmptySiteException();
        }

        return onContainerArrived(containerId, destination);
    }

    @Override
    public synchronized boolean removeContainer(String containerId, String destination) {
        return onContainerLeft(containerId, destination);
    }

    @Override
    public synchronized boolean onCancel(Task task) {
        tasks.remove(task);
        return true;
    }

    @Override
    public synchronized void onMovingStarted(String agvId, String taskId) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setAgvId(agvId);
            task.setStatus(Status.Moving);
            task.setReplaceable(false);
            task.setCancelable(false);
            notification.ifPresent(n -> n.onMovingStarted(agvId, task));
            Tracker.agv(String.format("OnMovingStarted: task: %s, agv: %s", task.toString(), agvId));
        });
    }

    @Override
    public synchronized void onMovingArrived(String agvId, String taskId) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Arrived);
            tasks.remove(task);
            removeContainer(null, task.getDestination());
            notification.ifPresent(n -> n.onMovingArrived(agvId, task));
            Tracker.agv(String.format("OnMovingArrived: task: %s, agv: %s", task.toString(), agvId));
        });
    }

    @Override
    public synchronized void onMovingPaused(String agvId, String taskId) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Paused);
            notification.ifPresent(n -> n.onMovingPaused(agvId, task));
            Tracker.agv(String.format("OnMovingPaused: task: %s, agv: %s", task.toString(), agvId));
        });
    }

    @Override
    public synchronized void onMovingWaiting(String agvId, String taskId) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Paused);
            notification.ifPresent(n -> n.onMovingWaiting(agvId, task));
            Tracker.agv(String.format("OnMovingWaiting: task: %s, agv: %s", task.toString(), agvId));
        });
    }

    @Override
    public synchronized void onMovingCancelled(String agvId, String taskId) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Cancelled);
            tasks.remove(task);
            removeContainer(null, task.getSource());
            removeContainer(null, task.getDestination());
            notification.ifPresent(n -> n.onMovingCancelled(agvId, task));
            Tracker.agv(String.format("OnMovingCancelled: task: %s, agv: %s", task.toString(), agvId));
        });
    }

    @Override
    public synchronized void onMovingFail(String agvId, String taskId) {
        getTaskByWcsTaskId(taskId).ifPresent(task -> {
            task.setStatus(Status.Fail);
            tasks.remove(task);
            removeContainer(null, task.getSource());
            removeContainer(null, task.getDestination());
            notification.ifPresent(n -> n.onMovingFail(agvId, task));
            Tracker.agv(String.format("OnMovingFail: task: %s, agv: %s", task.toString(), agvId));
        });
    }

    @Override
    public synchronized boolean onContainerArrived(String containerId, String destination) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination);
        if (site == null) {
            return false;
        }

        if (!StringUtils.isNullOrEmpty(site.getContainerId())) {
            return false;
        }

        site.setContainerId(containerId);
        notification.ifPresent(n -> n.onContainerArrived(containerId, destination));
        Tracker.agv(String.format("OnContainerArrived: container: %s", containerId));

        return true;
    }

    @Override
    public synchronized boolean onContainerLeft(String containerId, String destination) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(destination);
        if (site == null) {
            return false;
        }

        if (StringUtils.isNullOrEmpty(site.getContainerId())) {
            return false;
        }

        site.setContainerId(null);
        notification.ifPresent(n -> n.onContainerLeft(containerId, destination));
        Tracker.agv(String.format("OnContainerLeft: container: %s", containerId));

        return true;
    }

    @Override
    public void run() {
        while (true) {
            synchronized (this) {
                // 尝试添加待执行任务
                new ArrayList<>(pendingTasks).forEach(t -> {
                    try {
                        Task task = addTask(t.getSource(), t.getDestination(), t.getDestinationArea(),
                                t.getMaterials());
                        if (task != null) {
                            pendingTasks.remove(t);
                        }
                    } catch (Exception e) {
                        Tracker.error(e);
                    }
                });
            }

            try {
                Thread.sleep(3000);
            } catch (Exception e) {
                Tracker.error(e);
            }
        }
    }

    /**
     * 添加任务
     * 
     * @param source          源站点编码
     * @param destination     目的站点编码
     * @param destinationArea 目的区域编码
     * @param materials       物料列表
     * @return 任务
     * @throws Exception 异常
     */
    protected synchronized Task addTask(String source, String destination, String destinationArea,
            List<Material> materials) throws Exception {
        if (!hasContainer(source)) {
            Tracker.agv("无料车无法发货:" + source);
            throw new NonMaterialCarException();
        }

        // 不允许在已有任务的源站点发送任务
        if (getTaskBySite(source).isPresent()) {
            Tracker.agv("不允许在已有任务的源站点发送任务:" + source);
            return addPendingTask(source, destination, destinationArea, materials);
        }

        if (StringUtils.isNullOrEmpty(destinationArea)) {
            // 不允许向已有容器或已有任务的站点内发送容器
            if (!isFreeSite(destination)) {
                Tracker.agv("不允许向已有容器或已有任务的站点内发送容器:" + source + ", " + destination);
                return addPendingTask(source, destination, destinationArea, materials);
            }

            return onAddTask(source, destination, materials);
        } else {
            Optional<com.furongsoft.agv.schedulers.entities.Site> site = getFreeSite(destinationArea);
            if (site.isEmpty()) {
                Tracker.agv("区域内没有空闲站点:" + source + ", " + destinationArea);
                return addPendingTask(source, destination, destinationArea, materials);
            }

            return onAddTask(source, site.get().getCode(), materials);
        }
    }

    /**
     * 添加执行任务
     * 
     * @param source      源站点编码
     * @param destination 目的站点编码
     * @param wcsTaskId   WCS任务索引
     * @param materials   物料列表
     * @return 任务
     */
    protected synchronized Task addRunningTask(String source, String destination, String wcsTaskId,
            List<Material> materials) {
        Task task = new Task(source, destination, null, wcsTaskId, null, true, true, Status.Initialized, materials);
        tasks.add(task);

        return task;
    }

    /**
     * 添加等待任务
     * 
     * @param source          源站点编码
     * @param destination     目的站点编码
     * @param destinationArea 目的区域编码
     * @param materials       物料列表
     * @return 任务
     */
    protected synchronized Task addPendingTask(String source, String destination, String destinationArea,
            List<Material> materials) {
        Task task = new Task(source, destination, destinationArea, null, null, true, true, Status.Initialized,
                materials);
        tasks.add(task);

        return task;
    }

    /**
     * 获取站点
     *
     * @param code 站点编码
     * @return 站点
     */
    protected synchronized com.furongsoft.agv.schedulers.entities.Site getSite(String code) {
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
    protected synchronized Optional<com.furongsoft.agv.schedulers.entities.Site> getFreeSite(String destinationArea) {
        return areas.stream().filter(a -> a.getCode().equals(destinationArea)).findFirst().flatMap(this::getFreeSite);
    }

    /**
     * 获取空闲站点
     *
     * @param area 区域
     * @return 空闲站点
     */
    protected synchronized Optional<com.furongsoft.agv.schedulers.entities.Site> getFreeSite(Area area) {
        return area.getSites().stream().filter(s -> isFreeSite(s)).findFirst();
    }

    /**
     * 获取默认站点
     *
     * @param destinationArea 目的区域编码
     * @return 站点
     */
    protected synchronized Optional<com.furongsoft.agv.schedulers.entities.Site> getDefaultSite(
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
    protected synchronized Optional<com.furongsoft.agv.schedulers.entities.Site> getDefaultSite(Area area) {
        return area.getSites().stream().findFirst();
    }

    /**
     * 是否为空闲站点
     * 
     * @param code 站点编码
     * @return 是否为空闲站点
     */
    protected synchronized boolean isFreeSite(String code) {
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
    protected synchronized boolean isFreeSite(com.furongsoft.agv.schedulers.entities.Site site) {
        return StringUtils.isNullOrEmpty(site.getContainerId()) && getTaskBySite(site.getCode()).isEmpty();
    }

    /**
     * 获取任务
     *
     * @param source 源站点编码
     * @return 任务
     */
    protected synchronized Optional<Task> getTaskBySource(String source) {
        return tasks.stream().filter(t -> t.getSource().equals(source)).findFirst();
    }

    /**
     * 获取任务
     *
     * @param destination 目的站点编码
     * @return 任务
     */
    protected synchronized Optional<Task> getTaskByDestination(String destination) {
        return tasks.stream().filter(t -> t.getDestination().equals(destination)).findFirst();
    }

    /**
     * 获取任务
     *
     * @param code 站点编码
     * @return 任务
     */
    protected synchronized Optional<Task> getTaskBySite(String code) {
        return tasks.stream().filter(t -> t.getSource().equals(code) || t.getDestination().equals(code)).findFirst();
    }

    /**
     * 获取任务
     *
     * @param wcsTaskId WCS任务索引
     * @return 任务
     */
    protected synchronized Optional<Task> getTaskByWcsTaskId(String wcsTaskId) {
        return tasks.stream().filter(t -> t.getWcsTaskId().equals(wcsTaskId)).findFirst();
    }

    /**
     * 站点内是否有容器
     *
     * @param code 站点编码
     * @return 是否有容器
     */
    protected synchronized boolean hasContainer(String code) {
        com.furongsoft.agv.schedulers.entities.Site site = getSite(code);
        if (site == null) {
            return false;
        }

        return !StringUtils.isNullOrEmpty(site.getContainerId());
    }
}
