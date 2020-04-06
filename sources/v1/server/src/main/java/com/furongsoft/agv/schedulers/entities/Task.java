package com.furongsoft.agv.schedulers.entities;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * AGV任务
 *
 * @author Alex
 */
@Data
@AllArgsConstructor
public class Task {
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

    /**
     * 源站点编码
     */
    public String source;

    /**
     * 目的站点编码
     */
    public String destination;

    /**
     * 目的区域编码
     */
    public String destinationArea;

    /**
     * WCS任务索引
     */
    public String wcsTaskId;

    /**
     * 可替换目的站点
     */
    public boolean replaceable;

    /**
     * 可取消
     */
    public boolean cancelable;

    /**
     * 状态
     */
    public Status status;

    public String toString() {
        try {
            return new ObjectMapper().writeValueAsString(this);
        } catch (JsonProcessingException e) {
            return null;
        }
    }
}
