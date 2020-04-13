package com.furongsoft.agv.models;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 叫料按钮前端对象
 *
 * @author linyehai
 */
@Setter
@Getter
public class CallButtonModel implements Serializable {

    /**
     * 主键
     */
    private Long id;

    /**
     * 编号
     */
    private String code;

    /**
     * IP地址
     */
    private String ipAddress;

    /**
     * 名称
     */
    private String name;

    /**
     * 站点ID
     */
    private Long siteId;

    /**
     * 所属区域ID
     */
    private Long areaId;

    /**
     * 区域名称
     */
    private String areaName;

    /**
     * 区域类型
     */
    private Long areaType;
}
