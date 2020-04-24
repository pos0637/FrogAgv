package com.furongsoft.frogagv;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.ISchedulerNotification;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.schedulers.entities.Task.Status;
import com.furongsoft.agv.services.SiteService;
import com.furongsoft.base.misc.Tracker;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class GeekPlusTests {
    @Autowired
    private IScheduler scheduler;

    @Autowired
    private SiteService siteService;

    private Site site1;
    private Site site2;
    private Site site3;
    private Site site4;
    private String containerId1 = "A000011";
    private String containerId2 = "A000012";
    private String containerId3 = "A000013";

    /**
     * 初始化
     */
    @BeforeEach
    void initialize() {
        scheduler.initialize(null, new ISchedulerNotification() {
            @Override
            public void onMovingStarted(String agvId, Task task) {
                Tracker.info("onMovingStarted: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingArrived(String agvId, Task task) {
                Tracker.info("onMovingArrived: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingPaused(String agvId, Task task) {
                Tracker.info("onMovingPaused: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingWaiting(String agvId, Task task) {
                Tracker.info("onMovingWaiting: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingCancelled(String agvId, Task task) {
                Tracker.info("onMovingCancelled: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingFail(String agvId, Task task) {
                Tracker.info("onMovingFail: " + agvId + ", " + task.toString());
            }

            @Override
            public void onContainerArrived(String containerId, Site target) {
                Tracker.info("onContainerArrived: " + containerId + ", " + target.toString());
            }

            @Override
            public void onContainerLeft(String containerId, Site target) {
                Tracker.info("onContainerLeft: " + containerId + ", " + target.toString());
            }
        });

        removeAllContainers();

        site1 = new Site();
        site1.setCode("GZ-1");

        site2 = new Site();
        site2.setCode("GZ-2");

        site3 = new Site();
        site3.setCode("GZ-3");

        site4 = new Site();
        site4.setCode("GZ-4");
    }

    /**
     * 移除所有站点内容器
     */
    void removeAllContainers() {
        List<Site> sites = siteService.selectList(null);
        sites.forEach(site -> scheduler.onContainerLeft(null, site, null));
    }

    /**
     * 下发一个A点到B点的任务</br>
     * 前置条件: A点上无容器,B点上无容器</br>
     * 测试步骤: 在A点执行容器入场->下发一个A点到B点的任务</br>
     * 预计结果: A点容器入场成功,下发任务成功</br>
     */
    @Test
    void test1() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task = scheduler.addTask(site1, site2);
        assertEquals(true, task != null);
    }

    /**
     * 下发一个A点到B点的任务</br>
     * 前置条件: A点上无容器,B点上有容器</br>
     * 测试步骤: 清空A、B两点容器,在B上入场一个容器,在A点执行容器入场->下发一个A点到B点的任务</br>
     * 预计结果: B点容器入场成功,A点容器入场成功,下发任务失败</br>
     */
    @Test
    void test2() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        result = scheduler.onContainerArrived(containerId2, site2, null);
        assertEquals(true, result);

        Task task = scheduler.addTask(site1, site2);
        assertEquals(false, task != null);
    }

    /**
     * 下发一个A点到B点的任务后,再下发B点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器</br>
     * 测试步骤: 清空A、B两点容器.在A点容器入场->下发一个A点到B点的任务->B点容器入场->下发一个B点到A点的任务</br>
     * 预计结果: A点容器入场成功,B点容器入场失败,A到B任务下发成功,B到A任务下发失败</br>
     */
    @Test
    void test3() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId2, site2, null);
        assertEquals(false, result);

        Task task2 = scheduler.addTask(site2, site1);
        assertEquals(false, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,AGV小车把货架取走后,下发一个B点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器</br>
     * 测试步骤:
     * 清空A、B两点容器.在A点容器入场->下发一个A点到B点的任务->AGV小车取走A点的货架->在B点容器入场->下发一个B点到A点的任务</br>
     * 预计结果: A点容器入场成功,A到B任务下发成功,B点容器入场失败,B到A任务下发失败</br>
     */
    @Test
    void test4() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        assertEquals(true, task1 != null);

        // 等待AGV小车取走A点的货架
        while (task1.getStatus() != Status.Moving) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
            }
        }

        result = scheduler.onContainerArrived(containerId2, site2, null);
        assertEquals(false, result);

        Task task2 = scheduler.addTask(site2, site1);
        assertEquals(false, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,下发一个C点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器</br>
     * 测试步骤: 清空A、B、C三点容器.在A点容器入场->下发一个A点到B点的任务->在C点容器入场->下发一个C到A的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功,C点容器入场成功,C到A下发任务失败</br>
     */
    @Test
    void test5() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId3, site3, null);
        assertEquals(true, result);

        Task task2 = scheduler.addTask(site3, site1);
        assertEquals(false, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,AGV小车把货架取走后,下发一个C点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器</br>
     * 测试步骤:
     * 清空A、B、C三点容器.在A点容器入场->下发一个A点到B点的任务->AGV小车取走A点的货架->C点容器入场->下发一个C到A的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功,C点容器入场成功,C到A下发任务成功</br>
     */
    @Test
    void test6() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        assertEquals(true, task1 != null);

        // 等待AGV小车取走A点的货架
        while (task1.getStatus() != Status.Moving) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
            }
        }

        result = scheduler.onContainerArrived(containerId3, site3, null);
        assertEquals(true, result);

        Task task2 = scheduler.addTask(site3, site1);
        assertEquals(true, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,下发一个B点到D点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,D点无容器</br>
     * 测试步骤: 清空A、B、D三点容器.在A点容器入场->下发一个A点到B点的任务->B点容器入场->下发一个B点到D点的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功,B点容器入场失败,下发B点到D点的任务失败</br>
     */
    @Test
    void test7() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId2, site2, null);
        assertEquals(false, result);

        Task task2 = scheduler.addTask(site2, site4);
        assertEquals(false, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,下发一个C点到D点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器,D点无容器</br>
     * 测试步骤: 清空A、B、C、D四点容器.在A点容器入场->下发一个A点到B点的任务->在C点容器入场->下发一个C点到D点的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功.C点容器入场成功、C到D任务下发成功</br>
     */
    @Test
    void test8() {
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId3, site3, null);
        assertEquals(true, result);

        Task task2 = scheduler.addTask(site3, site4);
        assertEquals(true, task2 != null);
    }

    /**
     * 下发一个B点到A点的任务后,下发一个C点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器</br>
     * 测试步骤: 清空A、B、C三点容器.在B点容器入场->下发一个B点到A点的任务->C点容器入场->下发一个C点到A点的任务</br>
     * 预计结果: B点容器入场成功、B到A任务下发成功.C点容器入场成功、C到A任务下发成功</br>
     */
    @Test
    void test9() {
        Boolean result = scheduler.onContainerArrived(containerId2, site2, null);
        assertEquals(true, result);

        Task task1 = scheduler.addTask(site2, site1);
        assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId3, site3, null);
        assertEquals(true, result);

        Task task2 = scheduler.addTask(site3, site1);
        assertEquals(true, task2 != null);
    }

    @Test
    void read_remote_button() {
        com.furongsoft.communication.modbusTcp.ModbusTcp.test();
    }
}
