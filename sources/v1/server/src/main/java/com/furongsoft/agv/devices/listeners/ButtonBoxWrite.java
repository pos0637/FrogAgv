package com.furongsoft.agv.devices.listeners;

import com.furongsoft.agv.devices.DeviceManager;
import com.furongsoft.agv.devices.model.ButtonBoxModel;
import com.furongsoft.agv.devices.model.CallButtonModel;
import com.furongsoft.agv.devices.model.TaskModel;
import com.furongsoft.agv.services.CallMaterialService;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.communication.modbusTcp.ModbusTcp;
import com.serotonin.modbus4j.ModbusMaster;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 按钮盒子写入监听
 *
 * @author linyehai
 */
public class ButtonBoxWrite implements Runnable {
    private final CallMaterialService callMaterialService;

    public ButtonBoxWrite(CallMaterialService callMaterialService) {
        this.callMaterialService = callMaterialService;
    }

    @Override
    public void run() {
        boolean runState = true;
        while (runState) {
            List<ButtonBoxModel> buttonBoxes = DeviceManager.getInstance().getButtonBoxModels(); // 获取所有按钮盒子
            try {
                buttonBoxes.forEach(buttonBoxModel -> {
                    // 未连接则创建连接,已连接则执行写入
                    ModbusMaster currentMaster = buttonBoxModel.getModbusMaster();
                    // CopyOnWriteArrayList<Boolean> callState = buttonBoxModel.getCallState();
                    // if (null != currentMaster && !CollectionUtils.isEmpty(callState)) {
                    // for (int i = 0; i < callState.size(); ++i) {
                    // if (callState.get(i)) {
                    // // 执行成功后亮灯、
                    // Tracker.warn("执行" +
                    // buttonBoxModel.getCallButtonModelByButtonCode(i).getName() + "的逻辑,并将编号" +
                    // buttonBoxModel.getCallButtonModelByButtonCode(i).getButtonCode() +
                    // "设置为false。第" + i);
                    // if (ModbusTcp.writeCoil(currentMaster, 254, i, true)) {
                    // callState.set(Integer.valueOf(buttonBoxModel.getCallButtonModelByButtonCode(i).getButtonCode()),
                    // false);
                    // }
                    // }
                    // }
                    // }
                    synchronized (buttonBoxModel.getCallTaskModels()) {
                        List<TaskModel> taskModels = buttonBoxModel.getCallTaskModels();
                        if (null != currentMaster && !CollectionUtils.isEmpty(taskModels)) {
                            taskModels.forEach(taskModel -> {
                                CallButtonModel callButtonModel = buttonBoxModel
                                        .getCallButtonModelByButtonCode(taskModel.getButtonNo());
                                boolean executeSuccess = false;
                                if (callButtonModel.getCode().indexOf("CALL") > 0) {
                                    // 执行叫料 TODO Could not open JPA EntityManager for transaction; nested exception
                                    // is java.lang.IllegalStateException: EntityManagerFactory is closed
                                    executeSuccess = callMaterialService.callMaterial(callButtonModel);
                                    Tracker.warn("执行" + callButtonModel.getName() + "的逻辑,并将编号"
                                            + callButtonModel.getButtonCode() + "设置为false。");
                                } else if (callButtonModel.getCode().indexOf("BACK") > 0) {
                                    try {
                                        // 执行退货
                                        executeSuccess = callMaterialService.backMaterialBox(callButtonModel);
                                        Tracker.warn("执行退货");
                                    } catch (Exception e) {
                                        Tracker.error(e);
                                    }
                                }
                                if (executeSuccess) {
                                    // 执行成功则亮灯、添加灭灯任务
                                    // ModbusTcp.writeCoil(currentMaster, 254,
                                    // Integer.valueOf(callButtonModel.getButtonCode()), true);
                                    addLightOffTask(buttonBoxModel, taskModel);
                                    taskModels.remove(taskModel);
                                } else {
                                    try {
                                        ModbusTcp.writeCoil(currentMaster, 254,
                                                Integer.valueOf(callButtonModel.getButtonCode()), true);
                                        Thread.sleep(5);
                                        ModbusTcp.writeCoil(currentMaster, 254,
                                                Integer.valueOf(callButtonModel.getButtonCode()), false);
                                        Thread.sleep(5);
                                        ModbusTcp.writeCoil(currentMaster, 254,
                                                Integer.valueOf(callButtonModel.getButtonCode()), true);
                                        Thread.sleep(5);
                                        ModbusTcp.writeCoil(currentMaster, 254,
                                                Integer.valueOf(callButtonModel.getButtonCode()), false);
                                        Thread.sleep(5);
                                        ModbusTcp.writeCoil(currentMaster, 254,
                                                Integer.valueOf(callButtonModel.getButtonCode()), true);
                                        Thread.sleep(5);
                                        ModbusTcp.writeCoil(currentMaster, 254,
                                                Integer.valueOf(callButtonModel.getButtonCode()), false);
                                    } catch (InterruptedException e) {
                                        e.printStackTrace();
                                    }
                                    taskModels.remove(taskModel);
                                }
                            });
                        }
                    }

                });
            } catch (Exception e) {
                Tracker.error(e.getCause());
                Tracker.error("========ButtonBoxWrite==========");
                e.printStackTrace();
            }
        }
    }

    /**
     * 添加灭灯任务
     *
     * @param buttonBoxModel 按钮盒子对象
     * @param taskModel      呼叫任务对象
     */
    public void addLightOffTask(ButtonBoxModel buttonBoxModel, TaskModel taskModel) {
        TaskModel lightOff = new TaskModel(taskModel.getButtonNo(), taskModel.getIpAddress(),
                System.currentTimeMillis());
        synchronized (buttonBoxModel.getLightOffTaskModels()) {
            if (buttonBoxModel.getLightOffTaskModels().contains(lightOff)) {
                Tracker.error("不添加灭灯任务");
                return;
            } else {
                buttonBoxModel.getLightOffTaskModels().add(lightOff);
                Tracker.info("添加一个灭灯任务");
            }
        }
    }
}
