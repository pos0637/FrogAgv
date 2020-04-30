package com.furongsoft.agv.schedulers.entities;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 物料
 * 
 * @author Alex
 */
@Data
@AllArgsConstructor
public class Material {
    /**
     * 物料编码
     */
    private String code;

    /**
     * 数量
     */
    private Integer count;
}
