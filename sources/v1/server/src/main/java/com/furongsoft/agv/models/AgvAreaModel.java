package com.furongsoft.agv.models;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * 区域前端对象
 *
 * @author linyehai
 */
@Setter
@Getter
public class AgvAreaModel implements Serializable {

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

    /**
     * 子区域
     */
    private List<AgvAreaModel> children;
}
