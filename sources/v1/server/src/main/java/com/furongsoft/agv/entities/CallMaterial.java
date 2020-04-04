package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.Date;

/**
 * 叫料信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_call_material")
@Getter
@Setter
public class CallMaterial extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

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
     * 班组唯一标识（青蛙uuid）
     */
    private String teamId;

    /**
     * 区域ID（产线ID）
     */
    private Integer areaId;

}
