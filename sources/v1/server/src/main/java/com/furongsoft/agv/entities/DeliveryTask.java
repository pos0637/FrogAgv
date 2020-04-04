package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.Date;

/**
 * 配送任务信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_delivery_task")
@Getter
@Setter
public class DeliveryTask extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 配送任务单号(全系统唯一,自动生成)
     */
    private String taskNo;

    /**
     * 起始站点ID
     */
    private long startSiteId;

    /**
     * 终点站点ID
     */
    private long endSiteId;

    /**
     * 料框ID
     */
    private long materialBoxId;

    /**
     * AGV小车唯一标识
     */
    private String agvUuid;

    /**
     * 状态【0：待接单；1：取货中；2：配送中；3：已完成】
     */
    private int state;

    /**
     * 类型【1：消毒-灌装；2：灌装-消毒；3：包材-拆包；4：拆包-包材；5：包材-包装；6：包装-包材】
     */
    private int type;

    /**
     * 是否启用
     */
    private Integer enabled;

}
