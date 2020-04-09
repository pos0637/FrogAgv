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

    @Test
    void addContainer() {
        Site site = new Site();
        site.setCode("185");
        scheduler.onContainerArrived("A000011", site, null);

        site.setCode("412");
        scheduler.onContainerArrived("A000012", site, null);
    }

    @Test
    void removeContainer() {
        Site site = new Site();
        site.setCode("185");
        scheduler.onContainerLeft("A000011", site, null);

        site.setCode("412");
        scheduler.onContainerLeft("A000012", site, null);
    }
}
