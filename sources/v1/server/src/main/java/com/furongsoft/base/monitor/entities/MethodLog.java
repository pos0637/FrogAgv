package com.furongsoft.base.monitor.entities;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;

import com.baomidou.mybatisplus.annotations.TableName;

import lombok.Data;

/**
 * 方法调用日志
 */
@Entity
@TableName("t_agv_method_log")
@Data
public class MethodLog implements Serializable {
    private static final long serialVersionUID = -6173800286585256727L;

    /**
     * 包名称
     */
    private String packageName;

    /**
     * 类名称
     */
    private String className;

    /**
     * 方法名称
     */
    private String methodName;

    /**
     * 调用开始时间
     */
    private Date startTime;

    /**
     * 调用结束时间
     */
    private Date endTime;

    /**
     * 执行时长
     */
    private long elapsed;

    public MethodLog(String packageName, String className, String methodName, Date startTime) {
        this.packageName = packageName;
        this.className = className;
        this.methodName = methodName;
        this.startTime = startTime;
    }
}
