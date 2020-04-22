package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.furongsoft.agv.models.WaveModel;
import com.furongsoft.base.entities.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

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
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Wave extends BaseEntity {
    @Id
    @GeneratedValue
    private long id;

    /**
     * 编码
     */
    private String code;

    /**
     * 班组唯一标识（uuid）
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
     * 产品物料ID
     */
    private long materialId;

    /**
     * 计划执行时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date executionTime;

    /**
     * 实际完成时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date finishTime;

    /**
     * 状态[0：未配送；1：配送中；2：已完成]
     */
    private int state;

    /**
     * 类型[1：灌装区；2：包装区]
     */
    private int type;

    /**
     * 是否启用
     */
    private Integer enabled;

    public Wave(WaveModel waveModel) {
        this.code = waveModel.getCode();
        this.teamId = waveModel.getTeamId();
        this.teamName = waveModel.getTeamName();
        this.areaId = waveModel.getAreaId();
        this.materialId = waveModel.getMaterialId();
        this.executionTime = waveModel.getExecutionTime();
        this.finishTime = waveModel.getFinishTime();
        this.state = waveModel.getState();
        this.type = waveModel.getType();
        this.enabled = waveModel.getEnabled();
    }
}
