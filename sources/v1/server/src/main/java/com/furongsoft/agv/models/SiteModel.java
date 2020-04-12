package com.furongsoft.agv.models;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 站点信息
 *
 * @author linyehai
 */
@Getter
@Setter
public class SiteModel implements Serializable {
    private long id;

    /**
     * 二维码
     */
    private String qrCode;

    /**
     * X轴坐标
     */
    private Double locationX;

    /**
     * Y轴坐标
     */
    private Double locationY;

    /**
     * Z轴坐标
     */
    private Double locationZ;

    /**
     * 类型[1：备货位；2：出货位；3：空车位；]
     */
    private int type;

    /**
     * 名称
     */
    private String name;

    /**
     * 编号
     */
    private String code;

    /**
     * 是否启用
     */
    private Integer enabled;

    /**
     * 区域名称
     */
    private String areaName;

    /**
     * 区域编号
     */
    private String areaCode;

    /**
     * 区域ID
     */
    private Long areaId;

    /**
     * 父级区域
     */
    private Long parentArea;

    /**
     * 备货ID
     */
    private Long stockUpRecordId;

    /**
     * 站点详情状态[0：空闲；1：锁定；2：有货]
     */
    private Integer siteDetailState;

    /**
     * 配送任务ID
     */
    private Long deliveryTaskId;

    /**
     * 备货信息
     */
    private StockUpRecordModel stockUpRecordModel;

    /**
     * 配送任务信息
     */
    private DeliveryTaskModel deliveryTaskModel;
}
