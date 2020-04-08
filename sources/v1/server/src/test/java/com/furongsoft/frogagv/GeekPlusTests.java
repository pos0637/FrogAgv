package com.furongsoft.frogagv;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.IScheduler;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class GeekPlusTests {
    @Autowired
    private IScheduler scheduler;

    @Test
    void contextLoads() {
    }

    @Test
    void addTask() {
        scheduler.addTask(new Site(), new Site());
    }
}
