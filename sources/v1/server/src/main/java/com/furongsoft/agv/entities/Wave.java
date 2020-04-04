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
 * 波次信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_wave")
@Getter
@Setter
public class Wave extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 编码
     */
    private String code;

    /**
     * 班组唯一标识（青蛙工厂的uuid）
     */
    private String teamId;

    /**
     * 班组名称
     */
    private String teamName;

    /**
     * 区域ID
     */
    private long areaId;

    /**
     * 物料ID(产品)
     */
    private long materialId;

    /**
     * 执行时间
     */
    private Date executionTime;

    /**
     * 完成时间
     */
    private Date finishTime;

    /**
     * 状态【0：未配送；1：配送中；2：已完成】
     */
    private int state;

    /**
     * 类型【1：灌装区；2：包装区】
     */
    private int type;

    /**
     * 是否启用
     */
    private Integer enabled;

}
