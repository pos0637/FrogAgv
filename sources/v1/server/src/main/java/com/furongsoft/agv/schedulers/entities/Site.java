package com.furongsoft.agv.schedulers.entities;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 站点
 *
 * @author Alex
 */
@Data
@AllArgsConstructor
public class Site {
    /**
     * 编号
     */
    public String code;

    /**
     * 容器编码
     */
    public String containerId;
}
