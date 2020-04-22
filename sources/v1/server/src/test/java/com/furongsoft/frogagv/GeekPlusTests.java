package com.furongsoft.frogagv;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Task;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;

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
        scheduler.initialize(new Area[]{new Area("1", new ArrayList<>() {
            {
                add(new com.furongsoft.agv.schedulers.entities.Site("GZ-1", null));
                add(new com.furongsoft.agv.schedulers.entities.Site("GZ-2", null));
            }
        })});

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

    @Test
    void cancel_GZ1_To_GZ2_Task() {
        removeContainers();

        Site site = new Site();
        site.setCode("185");
        scheduler.onContainerArrived("A000011", site, null);

        Site src = new Site();
        src.setCode("GZ-1");

        Site dst = new Site();
        dst.setCode("GZ-2");

        Task task = scheduler.addTask(src, dst);
        if (task != null) {
            scheduler.cancel(task);
        }
    }

    @Test
    void read_remote_button() {
//        IllegalFunctionException
//        SocketTimeoutException
//        NullPointerException
        com.furongsoft.communication.modbusTcp.ModbusTcp.test();
    }
}
