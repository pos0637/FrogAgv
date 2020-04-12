package com.furongsoft.agv.schedulers.geekplus.entities;

import lombok.Data;

/**
 * 执行搬运
 *
 * @author Alex
 */
@Data
public class MovingRequestMsg {
    /**
     * 消息头参数列表
     */
    private Header header;

    /**
     * 消息体参数列表
     */
    private Body body;

    @Data
    public static class Header {
        /**
         * 防止任务重复提交，唯一码
         */
        private String requestId;

        /**
         * 链路通道唯一编码
         */
        private String channelId;

        /**
         * 客户端码
         */
        private String clientCode;

        /**
         * 对接仓库唯一编码
         */
        private String warehouseCode;

        private String userId;

        private String userKey;

        private String language;

        /**
         * 版本
         */
        private String version;
    }

    @Data
    public static class Body {
        /**
         * 消息类型：此业务功能必须传：MovingRequestMsg
         */
        private String msgType;

        /**
         * 上游任务单据号
         */
        private String orderNo;

        /**
         * 搬运系统任务id
         */
        private String workflowWorkId;

        /**
         * 起始点位编码
         */
        private String startCode;

        /**
         * 节点类型（1.停靠点；2.工作站；3.货架点；4.区域；）
         */
        private int startType;

        /**
         * 容器二级分类编码
         */
        private String containerCategory;

        /**
         * 容器编码
         */
        private String containerCode;

        /**
         * 流转策略： 1 固定顺序(根据Code升序) 2根据行号排序
         */
        private int flowStrategy;

        /**
         * 流程模式： 1 容器模式(默认) 2 空跑模式
         */
        private int workflowMode;

        /**
         * 优先级，默认 1
         */
        private int priority;
    }

    @Data
    public static class Response {
        /**
         * 当前回调应答消息的唯一标识
         */
        private String responseId;

        /**
         * 回调应答代码，成功：0，失败：非0
         */
        private String code;

        /**
         * 返回消息说明，默认填写“Success”
         */
        private String msg;

        /**
         * 与回调的消息类型一一对应
         */
        private String msgType;

        /**
         * 返回失败和成功
         */
        private String data;
    }
}
