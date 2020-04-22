package com.furongsoft.agv.schedulers.entities;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

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
    private String code;

    /**
     * 站点列表
     */
    private List<Site> sites;
}
