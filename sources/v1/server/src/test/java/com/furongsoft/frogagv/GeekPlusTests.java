package com.furongsoft.frogagv;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.IScheduler;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class GeekPlusTests {
    @Autowired
    private IScheduler scheduler;

    @Test
    void addContainers() {
        Site site = new Site();
        site.setCode("185");
        scheduler.onContainerArrived("A000011", site, null);

        site.setCode("412");
        scheduler.onContainerArrived("A000012", site, null);
    }

    @Test
    void removeContainers() {
        Site site = new Site();
        site.setCode("185");
        scheduler.onContainerLeft(null, site, null);

        site.setCode("412");
        scheduler.onContainerLeft(null, site, null);
    }

    @Test
    void add_GZ1_To_GZ2_Task() {
        removeContainers();

        Site site = new Site();
        site.setCode("185");
        scheduler.onContainerArrived("A000011", site, null);

        Site src = new Site();
        src.setCode("GZ-1");

        Site dst = new Site();
        dst.setCode("GZ-2");

        scheduler.addTask(src, dst);
    }
}
