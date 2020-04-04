package com.furongsoft.agv.models;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

/**
 * 叫料信息前端对象
 *
 * @author linyehai
 */
@Getter
@Setter
public class CallMaterialModel implements Serializable {
    /**
     * 主键
     */
    private Long id;

    /**
     * 物料ID(原料)
     */
    private long materialId;

    /**
     * 叫料数量
     */
    private int count;

    /**
     * 验收数量
     */
    private Integer acceptanceCount;

    /**
     * 状态【0：未配送；1：配送中；2：已完成】
     */
    private int state;

    /**
     * 叫料时间
     */
    private Date callTime;

    /**
     * 配送波次详情编号
     */
    private String waveDetailCode;

    /**
     * 类型【1：灌装区；2：包装区；3：消毒间；4：拆包间】
     */
    private int type;

    /**
     * 取消叫料原因
     */
    private String cancelReason;

    /**
     * 是否启用
     */
    private Integer enabled;

    /**
     * 产品名称
     */
    private String productName;

    /**
     * 产品编号
     */
    private String productCode;

    /**
     * 产品唯一标识
     */
    private String productUuid;

    /**
     * 产品规格
     */
    private String productSpecs;

    /**
     * 产品单位
     */
    private String productUnit;

    /**
     * 产品批次
     */
    private String productBatch;

    /**
     * 班组唯一标识（青蛙uuid）
     */
    private String teamId;

    /**
     * 区域ID（产线ID）
     */
    private Integer areaId;

}
