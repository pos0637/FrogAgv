package com.furongsoft.communication.modbusTcp;

import com.furongsoft.base.misc.Tracker;
import com.serotonin.modbus4j.ModbusFactory;
import com.serotonin.modbus4j.ModbusMaster;
import com.serotonin.modbus4j.exception.ModbusInitException;
import com.serotonin.modbus4j.exception.ModbusTransportException;
import com.serotonin.modbus4j.ip.IpParameters;
import com.serotonin.modbus4j.msg.*;

import java.nio.ByteBuffer;

/**
 * ModbusTCP工具类
 *
 * @author alex
 */
public class ModbusTcp {
    public static void test() {
        ModbusMaster master = createMaster();
        // writeCoil(master, 254, 1, false);
        while (true) {
            short[] data = readInputRegisters(master, 254, 1000 + 4, 2);
            if (null == data) {
                continue;
            }
            ByteBuffer byteBuffer = ByteBuffer.allocate(data.length * Short.SIZE / Byte.SIZE);
            for (short s : data) {
                byteBuffer.putShort(s);
            }

            boolean[] result = convert(byteBuffer);
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < result.length; ++i) {
                sb.append(i + ": " + result[i] + ", ");
                if (result[i]) {
                    Tracker.error(i + ":" + result[i]);
                    writeCoil(master, 254, i, result[i]);
                }
            }
            Tracker.info(sb.toString());

            try {
                Thread.sleep(1000);
                writeCoil(master, 254, 0, false);
                writeCoil(master, 254, 1, false);
                writeCoil(master, 254, 2, false);
                writeCoil(master, 254, 3, false);
            } catch (InterruptedException e) {
            }
        }
    }

    /**
     * 创建主站
     *
     * @return 主站
     */
    public static ModbusMaster createMaster() {
        IpParameters params = new IpParameters();
        params.setHost("192.168.8.227");
        params.setPort(10000);
        params.setEncapsulated(true);

        try {
            ModbusMaster master = new ModbusFactory().createTcpMaster(params, true);
            master.setTimeout(1000);
            master.setRetries(3);
            master.init();
            return master;
        } catch (ModbusInitException e) {
            Tracker.error(e);
            return null;
        }
    }

    /**
     * 通过IP和端口创建master
     *
     * @return 创建的master
     */
    public static ModbusMaster createMaster(String ipAddress, int port) {
        IpParameters params = new IpParameters();
        params.setHost(ipAddress);
        params.setPort(port);
        params.setEncapsulated(true);
        try {
            ModbusMaster master = new ModbusFactory().createTcpMaster(params, true);
            master.setTimeout(1000);
            master.setRetries(3);
            master.init();
            return master;
        } catch (ModbusInitException e) {
            Tracker.error("连接失败的设备：" + ipAddress);
//            Tracker.error(e);
            return null;
        }
    }

    /**
     * 读取线圈
     *
     * @param master       主站
     * @param slaveId      从站索引
     * @param offset       偏移
     * @param numberOfBits 长度
     * @return 结果
     */
    public static boolean[] readCoils(ModbusMaster master, int slaveId, int offset, int numberOfBits) {
        try {
            ReadCoilsRequest request = new ReadCoilsRequest(slaveId, offset, numberOfBits);
            ReadCoilsResponse response = (ReadCoilsResponse) master.send(request);
            return response.getBooleanData();
        } catch (ModbusTransportException e) {
            Tracker.error(e);
            return null;
        }
    }

    /**
     * 读取输入寄存器
     *
     * @param master       主站
     * @param slaveId      从站索引
     * @param offset       偏移
     * @param numberOfBits 长度
     * @return 结果
     */
    public static short[] readInputRegisters(ModbusMaster master, int slaveId, int offset, int numberOfBits) {
        try {
            ReadInputRegistersRequest request = new ReadInputRegistersRequest(slaveId, offset, numberOfBits);
            ReadInputRegistersResponse response = (ReadInputRegistersResponse) master.send(request);
            return response.getShortData();
        } catch (ModbusTransportException e) {
            Tracker.error(e.getStackTrace().toString());
            Tracker.error(e.getCause());
            Tracker.error(e.getMessage());
            Tracker.error(e.getSlaveId());
            Tracker.error(e);
            return null;
        }
    }

    /**
     * 写入线圈
     *
     * @param master  主站
     * @param slaveId 从站索引
     * @param offset  偏移
     * @param value   值
     * @return 是否成功
     */
    public static boolean writeCoil(ModbusMaster master, int slaveId, int offset, boolean value) {
        try {
            WriteCoilRequest request = new WriteCoilRequest(slaveId, offset, value);
            WriteCoilResponse response = (WriteCoilResponse) master.send(request);
            return !response.isException();
        } catch (ModbusTransportException e) {
            Tracker.error(e);
            return false;
        }
    }

    /**
     * 将字节数组转换为位数组
     *
     * @param bb 字节数组
     * @return 位数组
     */
    public static boolean[] convert(ByteBuffer bb) {
        byte[] ba = bb.array();
        boolean[] result = new boolean[Byte.SIZE * ba.length];
        int offset = 0;

        for (byte b : ba) {
            for (int i = 0; i < Byte.SIZE; i++) {
                result[i + offset] = (b >> i & 0x1) != 0x0;
            }
            offset += Byte.SIZE;
        }

        return result;
    }
}