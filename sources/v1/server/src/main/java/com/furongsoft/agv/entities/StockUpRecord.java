package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 备货记录信息[站点历史备货数据]
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_stock_up_record")
@Data
public class StockUpRecord extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 站点ID
     */
    private long siteId;

    /**
     * 料框ID
     */
    private long materialBoxId;

    /**
     * 状态[0：未出库；1：已出库]
     */
    private int state;

    /**
     * 类型[1：消毒间备货；2：拆包间备货；3：包材仓备货]
     */
    private int type;

    /**
     * 配送任务
     */
    private Long deliveryTaskId;

    /**
     * 是否启用
     */
    private Integer enabled;

}
