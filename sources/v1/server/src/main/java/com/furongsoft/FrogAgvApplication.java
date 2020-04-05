package com.furongsoft;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 应用
 *
 * @author Alex
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableScheduling
public class FrogAgvApplication {
    public static void main(String[] args) {
        SpringApplication.run(FrogAgvApplication.class, args);
    }
}
