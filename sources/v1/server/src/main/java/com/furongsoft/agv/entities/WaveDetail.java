package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.agv.models.WaveDetailModel;
import com.furongsoft.base.entities.BaseEntity;
import lombok.*;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 波次详情信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_wave_detail")
@Data
@NoArgsConstructor
@AllArgsConstructor
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
     * 原料物料ID
     */
    private long materialId;

    /**
     * 数量
     */
    private int count;

    /**
     * 是否启用
     */
    private Integer enabled;

    public WaveDetail(WaveDetailModel waveDetailModel) {
        this.code = waveDetailModel.getCode();
        this.waveCode = waveDetailModel.getWaveCode();
        this.materialId = waveDetailModel.getMaterialId();
        this.count = waveDetailModel.getCount();
        this.enabled = waveDetailModel.getEnabled();
    }
}
