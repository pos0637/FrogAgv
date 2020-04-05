package com.furongsoft.agv.schedulers.entities;

import lombok.Data;

/**
 * AGV任务
 *
 * @author Alex
 */
@Data
public class Task {
    /**
     * 源站点编码
     */
    public String source;

    /**
     * 目的站点编码
     */
    public String target;

    /**
     * 目的区域编码
     */
    public String targetArea;

    /**
     * WCS任务索引
     */
    public String wcsId;

    /**
     * 可替换目的站点
     */
    public boolean replaceable;

    /**
     * 可取消
     */
    public boolean cancelable;
}
