package com.furongsoft.agv.schedulers.geekplus;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.BaseScheduler;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.geekplus.entities.*;
import com.furongsoft.base.misc.HttpUtils;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.base.misc.UUIDUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * AGV调度管理器
 *
 * @author Alex
 */
@Component
@Configuration
public class Scheduler extends BaseScheduler {
    @Value("${geekplus.url}")
    private String url;

    @Value("${geekplus.clientCode}")
    private String clientCode;

    @Value("${geekplus.channelId}")
    private String channelId;

    @Value("${geekplus.warehouseCode}")
    private String warehouseCode;

    @Value("${geekplus.userId}")
    private String userId;

    @Value("${geekplus.userKey}")
    private String userKey;

    @Value("${geekplus.language}")
    private String language;

    @Value("${geekplus.version}")
    private String version;

    @Override
    public Task addTask(Site source, AgvArea destination) {
        MovingRequestMsg request = new MovingRequestMsg(
                new MovingRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey, language, version),
                new MovingRequestMsg.Body("MovingRequestMsg", "11", null, "GZ-1", 2, null, null, 1, 1, 1, new MovingRequestMsg.Dest[]{new MovingRequestMsg.Dest(1, "GZ-2", 2, 1)}));
        MovingResponseMsg response = HttpUtils.postJson(url, null, request, MovingResponseMsg.class);
        if (response == null) {
            return null;
        }

        return super.addTask(source, destination, response.getData()[0].getWorkflowWorkId());
    }

    @Override
    public Task addTask(Site source, Site destination) {
        MovingRequestMsg request = new MovingRequestMsg(
                new MovingRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey, language, version),
                new MovingRequestMsg.Body("MovingRequestMsg", source.getOrderNo(), "", source.getCode(), 2, null, null, 1, 1, 1, new MovingRequestMsg.Dest[]{new MovingRequestMsg.Dest(1, destination.getCode(), 2, 1)}));
        MovingResponseMsg response = HttpUtils.postJson(url, null, request, MovingResponseMsg.class);
        if (response == null) {
            return null;
        }
        if (response.getData() == null) {
            return null;
        }
        return super.addTask(source, destination, response.getData()[0].getWorkflowWorkId());
    }

    @Override
    public boolean cancel(Task task) {
        MovingCancelRequestMsg request = new MovingCancelRequestMsg(
                new MovingCancelRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey, language, version),
                new MovingCancelRequestMsg.Body("MovingCancelMsg", task.getWcsTaskId())
        );
        MovingCancelResponseMsg response = HttpUtils.postJson(url, null, request, MovingCancelResponseMsg.class);
        return response != null;
    }

    @Override
    public boolean cancel(Site source) {
        Optional<Task> task = getTaskBySource(source.getCode());
        return task.isPresent() && cancel(task.get());
    }

    @Override
    public void onMovingStarted(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(value -> value.setStatus(Task.Status.Moving));
    }

    @Override
    public void onMovingArrived(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(value -> value.setStatus(Task.Status.Arrived));
    }

    @Override
    public void onMovingPaused(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(value -> value.setStatus(Task.Status.Paused));
    }

    @Override
    public void onMovingWaiting(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(value -> value.setStatus(Task.Status.Paused));
    }

    @Override
    public void onMovingCancelled(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(value -> value.setStatus(Task.Status.Cancelled));
    }

    @Override
    public void onMovingFail(String agvId, String taskId, String event) {
        getTaskByWcsTaskId(taskId).ifPresent(value -> value.setStatus(Task.Status.Fail));
    }

    @Override
    public boolean onContainerArrived(String containerId, Site target, String event) {
        WarehouseControlRequestMsg request = new WarehouseControlRequestMsg(
                new WarehouseControlRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey, language, version),
                new WarehouseControlRequestMsg.Body("WarehouseControlRequestMsg", "ADD_CONTAINER", "2", containerId, 2, target.getCode())
        );
        WarehouseControlResponseMsg response = HttpUtils.postJson(url, null, request, WarehouseControlResponseMsg.class);
        Tracker.debug(response);
        return response.getCode().equals("0");
    }

    @Override
    public boolean onContainerLeft(String containerId, Site target, String event) {
        WarehouseControlRequestMsg request = new WarehouseControlRequestMsg(
                new WarehouseControlRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey, language, version),
                new WarehouseControlRequestMsg.Body("WarehouseControlRequestMsg", "REMOVE_CONTAINER", "2", containerId, 3, target.getCode())
        );
        WarehouseControlResponseMsg response = HttpUtils.postJson(url, null, request, WarehouseControlResponseMsg.class);
        Tracker.debug(response);
        return response.getCode().equals("0");
    }
}
