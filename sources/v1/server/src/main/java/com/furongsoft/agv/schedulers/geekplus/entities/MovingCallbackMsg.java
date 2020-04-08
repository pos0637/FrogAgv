package com.furongsoft.agv.schedulers.geekplus.entities;

import lombok.Data;

/**
 * 搬运回调
 *
 * @author Alex
 */
@Data
public class MovingCallbackMsg {
    @Data
    public static class Header {
        /**
         * 客户端原始指令下发的唯一标识
         */
        private String requestId;

        /**
         * 防止任务重复提交，唯一码
         */
        private String responseId;

        /**
         * 客户端码
         */
        private String clientCode;

        /**
         * 对接仓库唯一编码
         */
        private String warehouseCode;

        /**
         * 版本
         */
        private String version;
    }

    @Data
    public static class Body {
        /**
         * 上游任务单据号
         */
        private String orderNo;

        /**
         * 搬运系统任务id
         */
        private String workflowWorkId;

        /**
         * 搬运任务状态
         */
        private int workflowPhase;

        /**
         * 机器人移动状态
         */
        private String taskPhase;

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
         * 流程模式： 1 容器模式(默认) 2 空跑模式
         */
        private int workflowMode;

        /**
         * 目标节点类型（1.停靠点；2.工作站；3.货架点；4.区域；不传默认按停靠点处理）
         */
        private int destType;

        /**
         * 目标节点编码
         */
        private String destCode;
    }
}
