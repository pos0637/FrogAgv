package com.furongsoft.base.rbac.models;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Data
public class UserAuth implements Serializable {

    private long userId;

    private List<Long> roles;

    private List<Long> users;
}
