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
 * 波次详情信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_wave_detail")
@Getter
@Setter
public class WaveDetail extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 编码
     */
    private String code;

    /**
     * 波次编码
     */
    private String waveCode;

    /**
     * 物料ID(原料)
     */
    private long materialId;

    /**
     * 数量
     */
    private int count;

    /**
     * 状态【0：未配送；1：配送中；2：已完成】
     */
    private int state;

    /**
     * 是否启用
     */
    private Integer enabled;

}
