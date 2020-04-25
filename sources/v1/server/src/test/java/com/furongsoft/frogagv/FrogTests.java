package com.furongsoft.frogagv;

import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.frog.entities.GetBillFullInfoResponseMsg;
import com.furongsoft.agv.frog.entities.GetBomInfoResponseMsg;
import com.furongsoft.agv.frog.entities.GetMoResponseMsg;
import com.furongsoft.agv.frog.schedulers.ProductionPlanScheduler;
import com.furongsoft.agv.schedulers.IScheduler;
import com.furongsoft.agv.schedulers.entities.Area;
import com.furongsoft.agv.schedulers.entities.Task;
import com.furongsoft.agv.services.SiteService;
import com.furongsoft.base.misc.StringUtils;
import org.apache.commons.collections.CollectionUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;

@SpringBootTest
class FrogTests {

    @Autowired
    private ProductionPlanScheduler productionPlanScheduler;

    @Test
    public void GetMoTest() {
        GetMoResponseMsg getMoResponseMsg = productionPlanScheduler.getMo(ProductionPlanScheduler.DayType.today);
        List<GetMoResponseMsg.DataEntity> moEntities = new ArrayList<>();
        if (!CollectionUtils.isEmpty(getMoResponseMsg.getErp_mm_mo_get_response().getData())) {
            getMoResponseMsg.getErp_mm_mo_get_response().getData().forEach(moEntity -> {
                if ((!StringUtils.isNullOrEmpty(moEntity.getProductlinename())) && (moEntity.getProductlinename().indexOf("3B")>=0)) {
                    moEntities.add(moEntity);
                }
            });
        }
        System.out.println(getMoResponseMsg.toString());
    }

    @Test
    public void GetBomTest() {
        GetMoResponseMsg getMoResponseMsg = productionPlanScheduler.getMo(ProductionPlanScheduler.DayType.today);
        GetBomInfoResponseMsg getBomInfoResponseMsg = productionPlanScheduler.getBomInfo(getMoResponseMsg.getErp_mm_mo_get_response().getData().get(0));

        System.out.println(getBomInfoResponseMsg.toString());
    }

    @Test
    public void GetFullInfoList() {
        GetMoResponseMsg getMoResponseMsg = productionPlanScheduler.getMo(ProductionPlanScheduler.DayType.today);
        GetBillFullInfoResponseMsg getBillFullInfo = productionPlanScheduler.getBillFullInfo(getMoResponseMsg.getErp_mm_mo_get_response().getData());
        System.out.println(getBillFullInfo.toString());
    }

    @Test
    public void printTest() {
        productionPlanScheduler.printTest();
    }
}
