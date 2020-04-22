package com.furongsoft.agv.models;

import lombok.*;

import java.io.Serializable;

/**
 * 班组
 *
 * @author linyehai
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Team implements Serializable {
    /**
     * 主键
     */
    private long id;

    /**
     * 名称
     */
    private String name;

    /**
     * 唯一标识
     */
    private String uuid;
}
