package com.furongsoft.agv.models;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 站点详情信息[站点瞬时备货状态]
 *
 * @author linyehai
 */
@Data
public class SiteDetailModel implements Serializable {
    private long id;

    /**
     * 站点ID
     */
    private long siteId;

    /**
     * 料框ID
     */
    private Long materialBoxId;

    /**
     * 状态[0：空闲；1：锁定；2：有货]
     */
    private int state;

    /**
     * 配送任务
     */
    private Long deliveryTaskId;

    /**
     * 是否启用
     */
    private Integer enabled;

    /**
     * 区域ID
     */
    private Long areaId;

    /**
     * 父级区域ID
     */
    private Long parentAreaId;

    /**
     * 区域类型
     */
    private Integer areaType;

    /**
     * 区域编号
     */
    private String areaCode;

    /**
     * 区域名称
     */
    private String areaName;
}
