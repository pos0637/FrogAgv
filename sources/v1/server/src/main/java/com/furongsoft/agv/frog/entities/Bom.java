package com.furongsoft.agv.frog.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

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
