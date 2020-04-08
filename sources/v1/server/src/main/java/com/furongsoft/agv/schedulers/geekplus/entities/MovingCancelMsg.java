package com.furongsoft.agv.schedulers.geekplus.entities;

import lombok.Data;

/**
 * 搬运取消
 *
 * @author Alex
 */
@Data
public class MovingCancelMsg {
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
         * 搬运系统任务id
         */
        private String workflowWorkId;
    }

    @Data
    public static class Response {
        /**
         * 当前回调应答消息的唯一标识
         */
        private String responseId;

        /**
         * 返回消息说明，默认填写“Success”
         */
        private String msg;

        /**
         * 与回调的消息类型一一对应
         */
        private String msgType;

        /**
         * 回调应答代码，成功：0，失败：非0
         */
        private String code;
    }
}
