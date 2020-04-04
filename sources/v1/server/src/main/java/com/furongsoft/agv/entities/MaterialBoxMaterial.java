package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.NotBlank;

/**
 * 料框-物料信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_material_box_material")
@Getter
@Setter
public class MaterialBoxMaterial extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 料框ID
     */
    private long materialBoxId;

    /**
     * 物料ID(原料)
     */
    private long materialId;

    /**
     * 数量
     */
    private int count;

    /**
     * 状态【0：未验收；1：已验收】
     */
    private int state;

    /**
     * 是否启用
     */
    private Integer enabled;

}
