package com.furongsoft.base.rbac.models;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Data
public class RolePermission implements Serializable {

    private long roleId;

    private List<Long> auths;
}
