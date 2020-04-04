package com.furongsoft;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletContextInitializer;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;

/**
 * 应用
 *
 * @author Alex
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableScheduling
public class RobotApplication implements ServletContextInitializer {
    public static void main(String[] args) {
        SpringApplication.run(RobotApplication.class, args);
    }

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        servletContext.getSessionCookieConfig().setName("robotWebTest");
    }
}
