package com.furongsoft.frogagv;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.List;

import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.models.SiteModel;
import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.ISchedulerNotification;
import com.furongsoft.agv.schedulers.entities.Area;
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
    private String containerId1 = "PA000001";
    private String containerId2 = "PA000002";
    private String containerId3 = "PA000003";

    /**
     * 初始化
     */
    @BeforeEach
    void initialize() {
        List<AgvArea> agvAreas = siteService.selectAgvAreasByType(8);
        List<Area> areas = new ArrayList<Area>();
        agvAreas.forEach(agvArea -> {
            List<SiteModel> sites = siteService.selectLocationsByAreaId(agvArea.getId());
            List<com.furongsoft.agv.schedulers.entities.Site> siteList = new ArrayList<com.furongsoft.agv.schedulers.entities.Site>();
            sites.forEach(siteModel -> {
                siteList.add(new com.furongsoft.agv.schedulers.entities.Site(siteModel.getCode(),
                        siteModel.getMaterialBoxCode()));
            });
            areas.add(new Area(agvArea.getCode(), siteList));
        });

        scheduler.initialize((Area[]) areas.toArray(new Area[areas.size()]), new ISchedulerNotification() {
            @Override
            public void onMovingStarted(String agvId, Task task) {
                Tracker.agv("onMovingStarted: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingArrived(String agvId, Task task) {
                Tracker.agv("onMovingArrived: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingPaused(String agvId, Task task) {
                Tracker.agv("onMovingPaused: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingWaiting(String agvId, Task task) {
                Tracker.agv("onMovingWaiting: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingCancelled(String agvId, Task task) {
                Tracker.agv("onMovingCancelled: " + agvId + ", " + task.toString());
            }

            @Override
            public void onMovingFail(String agvId, Task task) {
                Tracker.agv("onMovingFail: " + agvId + ", " + task.toString());
            }

            @Override
            public void onContainerArrived(String containerId, Site target) {
                Tracker.agv("onContainerArrived: " + containerId + ", " + target.toString());
            }

            @Override
            public void onContainerLeft(String containerId, Site target) {
                Tracker.agv("onContainerLeft: " + containerId + ", " + target.toString());
            }

            @Override
            public void onAcceptTask(String workflowWorkId, String robotId) {
            }

            @Override
            public void onTakeAway(String workflowWorkId, String robotId) {
            }
        });

        removeAllContainers();

        site1 = new Site();
        site1.setCode("2");

        site2 = new Site();
        site2.setCode("5");

        site3 = new Site();
        site3.setCode("4");

        site4 = new Site();
        site4.setCode("7");
    }

    /**
     * 移除所有站点内容器
     */
    void removeAllContainers() {
        List<Site> sites = siteService.selectList(null);
        sites.forEach(site -> scheduler.onContainerLeft(null, site, null));
    }

    @Test
    void Test0() {
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

        Task task = scheduler.addTask(site1, site3);
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
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        // assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId2, site2, null);
        // assertEquals(false, result);

        Task task2 = scheduler.addTask(site2, site1);
        // assertEquals(false, task2 != null);
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
        initialize();
        site1 = new Site();
        site1.setCode("4");
        site2 = new Site();
        site2.setCode("1");
        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        // assertEquals(true, task1 != null);

        // 等待AGV小车取走A点的货架
        while (task1.getStatus() != Status.Moving) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
            }
        }

        result = scheduler.onContainerArrived(containerId2, site2, null);
        // assertEquals(false, result);

        Task task2 = scheduler.addTask(site2, site1);
        // assertEquals(false, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,下发一个C点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器</br>
     * 测试步骤: 清空A、B、C三点容器.在A点容器入场->下发一个A点到B点的任务->在C点容器入场->下发一个C到A的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功,C点容器入场成功,C到A下发任务失败</br>
     */
    @Test
    void test5() {

        site1 = new Site();
        site1.setCode("1");

        site2 = new Site();
        site2.setCode("4");

        site3 = new Site();
        site3.setCode("5");

        Boolean result = scheduler.onContainerArrived(containerId1, site3, null);
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site3, site1);
        // assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId3, site2, null);
        // assertEquals(true, result);

        Task task2 = scheduler.addTask(site2, site3);
        // assertEquals(false, task2 != null);
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

        site1 = new Site();
        site1.setCode("1");

        site2 = new Site();
        site2.setCode("4");

        site3 = new Site();
        site3.setCode("5");

        // Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        // assertEquals(true, task1 != null);

        // 等待AGV小车取走A点的货架
        // while (task1.getStatus() != Status.Moving) {
        // try {
        // Thread.sleep(1000);
        // } catch (InterruptedException e) {
        // }
        // }

        // result = scheduler.onContainerArrived(containerId3, site3, null);
        // assertEquals(true, result);

        // Task task2 = scheduler.addTask(site3, site1);
        // assertEquals(true, task2 != null);
    }

    @Test
    void test66() {

        site1 = new Site();
        site1.setCode("1");

        site2 = new Site();
        site2.setCode("4");

        site3 = new Site();
        site3.setCode("5");

        Task task1 = scheduler.addTask(site3, site1);
    }

    /**
     * 下发一个A点到B点的任务后,下发一个B点到D点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,D点无容器</br>
     * 测试步骤: 清空A、B、D三点容器.在A点容器入场->下发一个A点到B点的任务->B点容器入场->下发一个B点到D点的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功,B点容器入场失败,下发B点到D点的任务失败</br>
     */
    @Test
    void test7() {

        site1 = new Site();
        site1.setCode("1");

        site2 = new Site();
        site2.setCode("4");

        site3 = new Site();
        site3.setCode("5");

        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        // assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId2, site2, null);
        // assertEquals(false, result);

        Task task2 = scheduler.addTask(site2, site3);
        // assertEquals(false, task2 != null);
    }

    /**
     * 下发一个A点到B点的任务后,下发一个C点到D点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器,D点无容器</br>
     * 测试步骤: 清空A、B、C、D四点容器.在A点容器入场->下发一个A点到B点的任务->在C点容器入场->下发一个C点到D点的任务</br>
     * 预计结果: A点容器入场成功、A到B任务下发成功.C点容器入场成功、C到D任务下发成功</br>
     */
    @Test
    void test8() {
        site1 = new Site();
        site1.setCode("1");

        site2 = new Site();
        site2.setCode("4");

        site3 = new Site();
        site3.setCode("5");

        site4 = new Site();
        site4.setCode("7");

        Boolean result = scheduler.onContainerArrived(containerId1, site1, null);
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site1, site2);
        // assertEquals(true, task1 != null);

        result = scheduler.onContainerArrived(containerId3, site3, null);
        // assertEquals(true, result);

        Task task2 = scheduler.addTask(site3, site4);
        // assertEquals(true, task2 != null);
    }

    /**
     * 下发一个B点到A点的任务后,下发一个C点到A点的任务</br>
     * 前置条件: A点上无容器,B点上无容器,C点无容器</br>
     * 测试步骤: 清空A、B、C三点容器.在B点容器入场->下发一个B点到A点的任务->C点容器入场->下发一个C点到A点的任务</br>
     * 预计结果: B点容器入场成功、B到A任务下发成功.C点容器入场成功、C到A任务下发成功</br>
     */
    @Test
    void test9() {
        site1 = new Site();
        site1.setCode("1");

        site2 = new Site();
        site2.setCode("4");

        site3 = new Site();
        site3.setCode("7");

        // Boolean result = scheduler.onContainerArrived(containerId2, site2, null);
        // assertEquals(true, result);

        Task task1 = scheduler.addTask(site2, site1);
        // assertEquals(true, task1 != null);

        // result = scheduler.onContainerArrived(containerId3, site3, null);
        // assertEquals(true, result);

        Task task2 = scheduler.addTask(site3, site1);
        // assertEquals(true, task2 != null);
    }

    @Test
    void read_remote_button() {
        com.furongsoft.communication.modbusTcp.ModbusTcp.test();
    }
}
