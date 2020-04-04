package com.furongsoft.configurations;

import com.furongsoft.base.rbac.filters.CorsFilter;
import com.furongsoft.base.rbac.filters.JwtFilter;
import com.furongsoft.base.rbac.filters.MemberFilter;
import com.furongsoft.base.rbac.security.MyRealm;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.servlet.Filter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Shiro配置文件
 *
 * @author Alex
 */
@Configuration
public class ShiroConfiguration {
    @Value("${resources.url}")
    private String resourcesUrl;

    @Value("${upload.url}")
    private String uploadUrl;

    @Bean
    public SecurityManager securityManager(MyRealm myRealm) {
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        securityManager.setRealm(myRealm);

        return securityManager;
    }

    /**
     * @param securityManager
     * @return
     */
    @Bean
    public ShiroFilterFactoryBean shirFilter(SecurityManager securityManager) {
        ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();
        shiroFilterFactoryBean.setSecurityManager(securityManager);

        // 设置过滤器
        Map<String, Filter> filters = new HashMap<>(2);
        filters.put("cors", new CorsFilter());
        filters.put("jwt", new JwtFilter());
        filters.put("member", new MemberFilter());
        shiroFilterFactoryBean.setFilters(filters);

        // 过滤器
        Map<String, String> filterChainDefinitionMap = new LinkedHashMap<>();

        // 静态资源
        filterChainDefinitionMap.put(resourcesUrl + "/**", "anon");
        // 附件资源
        filterChainDefinitionMap.put(uploadUrl + "/**", "cors,anon");
        // ajax登录
        filterChainDefinitionMap.put("/api/v1/system/login", "anon");
        filterChainDefinitionMap.put("/api/v1/*/app/*", "cors,anon");
        // TODO
        filterChainDefinitionMap.put("/system/**", "anon");
        filterChainDefinitionMap.put("/web/system/**", "anon");
        filterChainDefinitionMap.put("/wx/**", "anon");
        filterChainDefinitionMap.put("/share/**", "anon");
        filterChainDefinitionMap.put("/api/v1/content/**", "anon");
        filterChainDefinitionMap.put("/api/v1/bill/noauth/**", "anon");
        filterChainDefinitionMap.put("/api/v1/house/noauth/**", "anon");
        filterChainDefinitionMap.put("/api/v1/meters/noauth/**", "anon");
        filterChainDefinitionMap.put("/api/v1/test/**", "anon");
        filterChainDefinitionMap.put("/api/v1/tenant/house/**", "anon");
        filterChainDefinitionMap.put("/favicon.ico", "anon");
        filterChainDefinitionMap.put("/api/v1/jssdk/**", "anon");
        filterChainDefinitionMap.put("/.well-known/**", "anon");
        // 注册时需要部门信息，部门权限anon
        filterChainDefinitionMap.put("/api/v1/system/organizations/list", "cors,anon");
        // 注册
        filterChainDefinitionMap.put("/api/v1/system/register", "anon");

        // 上传本地照片
        filterChainDefinitionMap.put("/api/v1/robots/users/local", "cors,anon");
        // api登出
//        filterChainDefinitionMap.put("/api/v1/system/logout", "cors,anon");
        // 支付
        filterChainDefinitionMap.put("/api/v1/pay/notify/**", "anon");
        // 微信用户信息
        filterChainDefinitionMap.put("/api/v1/wx/user/**", "anon");
        // 后台登出
        filterChainDefinitionMap.put("/admin/logout", "logout");
        // 前台
        filterChainDefinitionMap.put("/ui/**", "anon");
        // 首页
        filterChainDefinitionMap.put("/", "anon");
        filterChainDefinitionMap.put("/resources/**", "anon");
        filterChainDefinitionMap.put("/api/v1/shop/**", "anon,cors");
        filterChainDefinitionMap.put("/api/v1/qrcode", "anon,cors");
        filterChainDefinitionMap.put("/api/v1/system/users/current", "cors,jwt");
        filterChainDefinitionMap.put("/api/v1/pay/vip/renew/**", "cors,jwt");
        filterChainDefinitionMap.put("/api/v1/pay/vip/upgrade/**", "cors,jwt");
        filterChainDefinitionMap.put("/api/v1/member/discount", "cors,jwt");
        filterChainDefinitionMap.put("/api/v1/pay/vip/discount/**", "cors,jwt");
        // api接口
        filterChainDefinitionMap.put("/api/**", "cors,jwt,member");

        // 默认
        filterChainDefinitionMap.put("/**", "cors,jwt,member");

        shiroFilterFactoryBean.setLoginUrl("/main");
        shiroFilterFactoryBean.setUnauthorizedUrl("/403.html");
        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);

        return shiroFilterFactoryBean;
    }

    @Bean
    public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
        AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
        authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
        return authorizationAttributeSourceAdvisor;
    }

    @Bean
    @ConditionalOnMissingBean
    public DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator() {
        DefaultAdvisorAutoProxyCreator defaultAAP = new DefaultAdvisorAutoProxyCreator();
        defaultAAP.setProxyTargetClass(true);
        return defaultAAP;
    }
}

