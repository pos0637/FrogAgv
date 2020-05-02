package com.furongsoft.agv.schedulers.geekplus.controllers;

import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.geekplus.entities.MovingCallbackMsg;
import com.furongsoft.base.entities.RestResponse;
import com.furongsoft.base.misc.Tracker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * AGV调度管理器控制器
 */
@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/v1/agv")
public class SchedulerController {
    @Autowired
    private IScheduler scheduler;

    /**
     * AGV回调消息
     *
     * @param movingCallbackMsg 回调消息
     * @return 响应内容
     */
    @PostMapping("/callback")
    public RestResponse movingCallbackMsg(@RequestBody MovingCallbackMsg movingCallbackMsg) {
        Tracker.agv(movingCallbackMsg);
        MovingCallbackMsg.Body body = movingCallbackMsg.getBody();
        switch (body.getWorkflowPhase()) {
            case 20:
                if (body.getTaskPhase().equalsIgnoreCase("GO_FETCHING")) {
                    scheduler.onMovingStarted(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()));
                }
                break;
            case 25:
            scheduler.onMovingWaiting(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()));
                break;
            case 26:
            scheduler.onMovingPaused(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()));
                break;
            case 30:
            scheduler.onMovingArrived(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()));
                break;
            case 31:
            scheduler.onMovingFail(String.valueOf(body.getRobotId()), String.valueOf(body.getWorkflowWorkId()));
                break;
            default:
                break;
        }

        return new RestResponse(HttpStatus.OK);
    }
}
