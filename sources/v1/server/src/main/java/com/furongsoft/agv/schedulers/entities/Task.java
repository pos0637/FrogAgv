package com.furongsoft.agv.schedulers.entities;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;

import com.baomidou.mybatisplus.annotations.TableName;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.furongsoft.base.entities.BaseEntity;

import org.springframework.data.annotation.Id;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

/**
 * AGV任务
 *
 * @author Alex
 */
@Entity
@TableName("t_agv_scheduler_task")
@Getter
@Setter
@AllArgsConstructor
public class Task extends BaseEntity {
    private static final long serialVersionUID = -4789637947241961018L;

    @Id
    @GeneratedValue
    private long id;

    /**
     * 源站点编码
     */
    private String source;

    /**
     * 目的站点编码
     */
    private String destination;

    /**
     * 目的区域编码
     */
    private String destinationArea;

    /**
     * WCS任务索引
     */
    private String wcsTaskId;

    /**
     * AGV索引
     */
    private String agvId;

    /**
     * 可替换目的站点
     */
    private boolean replaceable;

    /**
     * 可取消
     */
    private boolean cancelable;

    /**
     * 状态
     */
    private Status status;

    /**
     * 是否启用
     */
    private boolean enabled;

    /**
     * 物料列表
     */
    private List<Material> materials;

    public Task(String source, String destination, String destinationArea, String wcsTaskId, List<Material> materials) {
        this.source = source;
        this.destination = destination;
        this.destinationArea = destinationArea;
        this.wcsTaskId = wcsTaskId;
        this.materials = new ArrayList<>(materials);
        this.replaceable = true;
        this.cancelable = true;
        this.enabled = true;
        this.status = Status.Initialized;
    }

    public String toString() {
        try {
            return new ObjectMapper().writeValueAsString(this);
        } catch (JsonProcessingException e) {
            return null;
        }
    }

    /**
     * 状态
     */
    public enum Status {
        Initialized, // 初始化
        Moving, // 搬运中
        Paused, // 暂停中
        Arrived, // 到达
        Cancelled, // 取消
        Fail // 失败
    }
}
