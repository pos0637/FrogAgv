package com.furongsoft.agv.models;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 存货model类
 *
 * @author linyehai
 */
@Setter
@Getter
public class MaterialModel implements Serializable {

    /**
     * 主键
     */
    private Long id;

    /**
     * 编号
     */
    private String code;

    /**
     * 名称
     */
    private String name;

    /**
     * 青蛙工厂唯一标识
     */
    private String uuid;
}
