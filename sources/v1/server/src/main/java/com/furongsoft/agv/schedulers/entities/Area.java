package com.furongsoft.agv.schedulers.entities;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 区域
 *
 * @author Alex
 */
@Data
@AllArgsConstructor
public class Area {
    /**
     * 编码
     */
    public String code;

    /**
     * 站点列表
     */
    public List<Site> sites;
}
