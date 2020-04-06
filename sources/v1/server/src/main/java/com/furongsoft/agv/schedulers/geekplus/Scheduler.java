package com.furongsoft.agv.schedulers.geekplus;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.BaseScheduler;
import com.furongsoft.agv.schedulers.entities.Task;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
public class Scheduler extends BaseScheduler {
    @Override
    public Task AddTask(Site source, AgvArea destination) {
        return null;
    }

    @Override
    public Task AddTask(Site source, Site destination) {
        return null;
    }

    @Override
    public boolean Cancel(Task task) {
        return false;
    }

    @Override
    public boolean Cancel(Site source) {
        return false;
    }

    @Override
    public void OnMovingStarted(String agvId, String taskId, String event) {

    }

    @Override
    public void OnMovingArrived(String agvId, String taskId, String event) {

    }

    @Override
    public void OnMovingPaused(String agvId, String taskId, String event) {

    }

    @Override
    public void OnMovingWaiting(String agvId, String taskId, String event) {

    }

    @Override
    public void OnMovingCancelled(String agvId, String taskId, String event) {

    }

    @Override
    public void OnMovingFail(String agvId, String taskId, String event) {

    }

    @Override
    public void OnContainerArrived(String containerId, Site target, String event) {

    }

    @Override
    public void OnContainerLeft(String containerId, Site target, String event) {

    }
}
