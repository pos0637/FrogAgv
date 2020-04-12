package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.furongsoft.agv.models.WaveModel;
import com.furongsoft.base.entities.BaseEntity;
import lombok.*;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.Date;

/**
 * BOM信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_bom")
@Data
public class Bom extends BaseEntity {
    @Id
    @GeneratedValue
    private long id;

    /**
     * 物料编码
     */
    private String materialCode;

    /**
     * 满料车数量
     */
    private int fullCount;

    /**
     * 版本号
     */
    private String version;

    /**
     * 是否启用
     */
    private Integer enabled;
}
