package com.furongsoft.agv.frog.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * BOM清单信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_bom_detail")
@Data
public class BomDetail extends BaseEntity {
    @Id
    @GeneratedValue
    private long id;

    /**
     * BOM主键
     */
    private long bomId;

    /**
     * 物料编码
     */
    private String materialCode;

    /**
     * 满料车数量
     */
    private int count;

    /**
     * 类型[1：内包材；2：外包材；3：其它]
     */
    private int type;

    /**
     * 是否启用
     */
    private Integer enabled;
}
