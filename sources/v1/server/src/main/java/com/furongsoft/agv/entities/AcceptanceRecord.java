package com.furongsoft.agv.entities;

import com.baomidou.mybatisplus.annotations.TableName;
import com.furongsoft.base.entities.BaseEntity;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.NotBlank;
import java.util.Date;

/**
 * 验收记录信息
 *
 * @author linyehai
 */
@Entity
@TableName("t_agv_acceptance_record")
@Getter
@Setter
public class AcceptanceRecord extends BaseEntity {

    @Id
    @GeneratedValue
    private long id;

    /**
     * 操作时间
     */
    private Date operationTime;

    /**
     * 班组唯一标识（青蛙工厂的uuid）
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
     * 操作类型【1：新增；2：修改；3：删除】
     */
    private int type;

    /**
     * 区域ID(产线ID)
     */
    private Long areaId;

    /**
     * 是否启用
     */
    private Integer enabled;

}
