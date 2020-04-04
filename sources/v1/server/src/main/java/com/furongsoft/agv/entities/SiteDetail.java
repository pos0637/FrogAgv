package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 站点详情信息【站点瞬时备货状态】
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_site_detail")
@Getter
@Setter
public class SiteDetail extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 站点ID
     */
    private long siteId;

    /**
     * 备货ID
     */
    private Long stockUpRecordId;

    /**
     * 状态【0：空闲；1：待出库；2：出库中；3：已出库；4：待入库；5：入库中；6：已入库】
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

}
