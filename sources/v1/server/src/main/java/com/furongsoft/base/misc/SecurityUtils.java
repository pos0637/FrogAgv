package com.furongsoft.base.misc;

import com.furongsoft.base.rbac.entities.User;
import org.apache.shiro.authc.UsernamePasswordToken;

/**
 * 安全工具
 *
 * @author chenfuqian
 */
public class SecurityUtils {
    /**
     * 获取当前用户
     *
     * @return 当前用户信息
     */
    public static User getCurrentUser() {
        return (User) org.apache.shiro.SecurityUtils.getSubject().getPrincipal();
    }

    /**
     * 登录
     *
     * @param username 用户名
     * @param password 密码
     */
    public static void login(String username, String password) {
        org.apache.shiro.SecurityUtils.getSubject().login(new UsernamePasswordToken(username, password));
    }

    /**
     * 注销
     */
    public static void logout() {
        org.apache.shiro.SecurityUtils.getSubject().logout();
    }
}
