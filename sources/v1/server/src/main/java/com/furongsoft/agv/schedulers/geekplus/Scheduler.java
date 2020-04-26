package com.furongsoft.agv.schedulers.geekplus;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.BaseScheduler;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.geekplus.entities.MovingCallbackMsg;
import com.furongsoft.agv.schedulers.geekplus.entities.MovingCancelRequestMsg;
import com.furongsoft.agv.schedulers.geekplus.entities.MovingCancelResponseMsg;
import com.furongsoft.agv.schedulers.geekplus.entities.MovingRequestMsg;
import com.furongsoft.agv.schedulers.geekplus.entities.MovingResponseMsg;
import com.furongsoft.agv.schedulers.geekplus.entities.WarehouseControlRequestMsg;
import com.furongsoft.agv.schedulers.geekplus.entities.WarehouseControlResponseMsg;
import com.furongsoft.base.entities.RestResponse;
import com.furongsoft.base.misc.HttpUtils;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.base.misc.UUIDUtils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
                new MovingRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey,
                        language, version),
                new MovingRequestMsg.Body("MovingRequestMsg", "11", null, "GZ-1", 2, null, null, 1, 1, 1,
                        new MovingRequestMsg.Dest[] { new MovingRequestMsg.Dest(1, "GZ-2", 2, 1) }));
        MovingResponseMsg response = HttpUtils.postJson(url, null, request, MovingResponseMsg.class);
        if ((response == null) || (response.getData() == null)) {
            return null;
        }

        return super.addTask(source, destination, response.getData()[0].getWorkflowWorkId());
    }

    @Override
    public Task addTask(Site source, Site destination) {
        // 不允许向已有容器的站点内发送容器
        if (hasContainer(destination.getCode())) {
            return null;
        }

        MovingRequestMsg request = new MovingRequestMsg(
                new MovingRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId, userKey,
                        language, version),
                new MovingRequestMsg.Body("MovingRequestMsg", source.getOrderNo(), "", source.getCode(), 2, null, null,
                        1, 1, 1,
                        new MovingRequestMsg.Dest[] { new MovingRequestMsg.Dest(1, destination.getCode(), 2, 1) }));
        MovingResponseMsg response = HttpUtils.postJson(url, null, request, MovingResponseMsg.class);
        if ((response == null) || (response.getData() == null)) {
            return null;
        }

        return super.addTask(source, destination, response.getData()[0].getWorkflowWorkId());
    }

    @Override
    public boolean cancel(Task task) {
        MovingCancelRequestMsg request = new MovingCancelRequestMsg(
                new MovingCancelRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId,
                        userKey, language, version),
                new MovingCancelRequestMsg.Body("MovingCancelMsg", task.getWcsTaskId()));
        MovingCancelResponseMsg response = HttpUtils.postJson(url, null, request, MovingCancelResponseMsg.class);
        if ((response == null) || (!response.getCode().equals("0"))) {
            return false;
        }

        return super.cancel(task);
    }

    @Override
    public boolean onContainerArrived(String containerId, Site destination, String event) {
        // 不允许在已有容器的站点内添加容器
        if (hasContainer(destination.getCode())) {
            return false;
        }

        WarehouseControlRequestMsg request = new WarehouseControlRequestMsg(
                new WarehouseControlRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId,
                        userKey, language, version),
                new WarehouseControlRequestMsg.Body("WarehouseControlRequestMsg", "ADD_CONTAINER", "2", containerId, 2,
                        destination.getCode()));
        WarehouseControlResponseMsg response = HttpUtils.postJson(url, null, request,
                WarehouseControlResponseMsg.class);
        if ((response == null) || (!response.getCode().equals("0"))) {
            return false;
        }

        return super.onContainerArrived(containerId, destination, event);
    }

    @Override
    public boolean onContainerLeft(String containerId, Site destination, String event) {
        WarehouseControlRequestMsg request = new WarehouseControlRequestMsg(
                new WarehouseControlRequestMsg.Header(UUIDUtils.getUUID(), channelId, clientCode, warehouseCode, userId,
                        userKey, language, version),
                new WarehouseControlRequestMsg.Body("WarehouseControlRequestMsg", "REMOVE_CONTAINER", "2", containerId,
                        2, destination.getCode()));
        WarehouseControlResponseMsg response = HttpUtils.postJson(url, null, request,
                WarehouseControlResponseMsg.class);
        if ((response == null) || (!response.getCode().equals("0"))) {
            return false;
        }

        return super.onContainerLeft(containerId, destination, event);
    }

    /**
     * AGV回调消息
     *
     * @param movingCallbackMsg 回调消息
     * @return 响应内容
     */
    @PostMapping("/callback")
    public RestResponse movingCallbackMsg(@RequestBody MovingCallbackMsg movingCallbackMsg) {
        Tracker.info(movingCallbackMsg);
        MovingCallbackMsg.Body body = movingCallbackMsg.getBody();
        switch (body.getWorkflowPhase()) {
            case 20:
                onMovingStarted(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()), null);
                break;
            case 25:
                onMovingWaiting(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()), null);
                break;
            case 26:
                onMovingPaused(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()), null);
                break;
            case 30:
                onMovingArrived(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()), null);
                break;
            case 31:
                onMovingFail(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()), null);
                break;
            default:
                break;
        }

        return new RestResponse(HttpStatus.OK);
    }
}
