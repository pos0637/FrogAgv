package com.furongsoft.agv.devices.listeners;

import com.furongsoft.agv.devices.model.ButtonBoxModel;
import com.furongsoft.agv.devices.model.TaskModel;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.communication.modbusTcp.ModbusTcp;
import com.serotonin.modbus4j.ModbusMaster;

import java.nio.ByteBuffer;

/**
 * 按钮盒子读取监听
 *
 * @author linyehai
 */
public class ButtonBoxRead implements Runnable {
    private final ButtonBoxModel buttonBoxModel;

    public ButtonBoxRead(ButtonBoxModel buttonBoxModel) {
        this.buttonBoxModel = buttonBoxModel;
    }

    @Override
    public void run() {
        boolean runState = true;
        while (runState) {
            try {
                Thread.sleep(500);
                // 未连接则创建连接,已连接则执行读取
                ModbusMaster currentMaster = buttonBoxModel.getModbusMaster();
                // TODO 需要进行修改
                if (null != currentMaster) {
                    // 执行读取
                    short[] data = ModbusTcp.readInputRegisters(currentMaster, 254, 1000 + 4, 1);
                    if (null == data) {
                        return;
                    }
                    ByteBuffer byteBuffer = ByteBuffer.allocate(data.length * Short.SIZE / Byte.SIZE);
                    for (short s : data) {
                        byteBuffer.putShort(s);
                    }
                    boolean[] result = ModbusTcp.convert(byteBuffer);
                    for (int i = 0; i < buttonBoxModel.getCallButtonModels().size(); ++i) {
                        if (result[i]) {
                            addTask(i);
                            Tracker.error(buttonBoxModel.getCallButtonModelByButtonCode(i).getName());
                            ModbusTcp.writeCoil(currentMaster, 254, i, true);
                            // 将叫料状态激活
//                            buttonBoxModel.getCallState().set(i, true);
                        }
                    }
                } else {
                    ModbusMaster modbusMaster = ModbusTcp.createMaster(buttonBoxModel.getIpAddress(), buttonBoxModel.getPort());
                    if (null != modbusMaster) {
                        buttonBoxModel.setModbusMaster(modbusMaster);
                    }
                }
            } catch (Exception e) {
                Tracker.error("====================================");
                Tracker.error(e.getCause());
                Tracker.error("===========********==============");
            }
        }
    }

    /**
     * 添加任务
     *
     * @param codeNo 按钮编号
     */
    public void addTask(int codeNo) {
        TaskModel taskModel = new TaskModel(codeNo, buttonBoxModel.getIpAddress(), null);
        synchronized (buttonBoxModel.getCallTaskModels()) {
            if (buttonBoxModel.getCallTaskModels().contains(taskModel)) {
                Tracker.error("不添加呼叫任务");
                return;
            } else {
                buttonBoxModel.getCallTaskModels().add(taskModel);
                Tracker.info("添加一个呼叫任务");
            }
        }
    }
}