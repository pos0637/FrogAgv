package com.furongsoft.agv.models;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 员工信息
 *
 * @author linyehai
 */
@Data
public class EmployeeInfo implements Serializable {
    /**
     * 主键
     */
    private String id;

    /**
     * 名称
     */
    private String name;
}
