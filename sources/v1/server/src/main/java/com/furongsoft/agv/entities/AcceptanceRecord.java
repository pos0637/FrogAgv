package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.Date;

/**
 * 验收记录信息
 *
 * @author linyehai
 */
@EqualsAndHashCode(callSuper = true)
@Entity
@TableName("t_agv_acceptance_record")
@Data
public class AcceptanceRecord extends BaseEntity {
    @Id
    @GeneratedValue
    private long id;

    /**
     * 操作时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date operationTime;

    /**
     * 班组唯一标识（uuid）
     */
    private String teamId;

    /**
     * 班组名称
     */
    private String teamName;

    /**
     * 源数据
     */
    private String source;

    /**
     * 结果数据
     */
    private String results;

    /**
     * 操作类型[1：新增；2：修改；3：删除]
     */
    private int type;

    /**
     * 产线ID
     */
    private Long areaId;

    /**
     * 是否启用
     */
    private Integer enabled;

}
