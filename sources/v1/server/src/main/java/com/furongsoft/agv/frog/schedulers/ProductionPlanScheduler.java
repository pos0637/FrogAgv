package com.furongsoft.agv.frog.schedulers;

import com.alibaba.fastjson.JSONObject;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.frog.entities.*;
import com.furongsoft.agv.services.MaterialService;
import com.furongsoft.base.misc.DateUtils;
import com.furongsoft.base.misc.HttpUtils;
import com.furongsoft.base.misc.StringUtils;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 生产计划调度器
 */
@Component
public class ProductionPlanScheduler {
    @Value("${qwwz.url}")
    private String url;

    @Value("${qwwz.format}")
    private String format;

    @Value("${qwwz.app_key}")
    private String appKey;

    @Value("${qwwz.simplify}")
    private boolean simplify;

    @Value("${qwwz.version}")
    private String version;

    @Value("${qwwz.pkCorp}")
    private String pkCorp;

    private final MaterialService materialService;

    public ProductionPlanScheduler(MaterialService materialService) {
        this.materialService = materialService;
    }

    public enum DayType {
        today,
        yesterday,
        tomorrow;
    }

    public void printTest() {
        System.out.println(DayType.today.name());
        System.out.println(DayType.today.toString());
        System.out.println(DayType.today.hashCode());
    }

    public void getProductionPlan() {
        // 获取明日生产计划
        GetMoResponseMsg tomorrowResponse = getMo(DayType.tomorrow);
        // 获取今日生产计划
        GetMoResponseMsg todayResponse = getMo(DayType.today);
        // 明日和今日的生产计划
        List<GetMoResponseMsg.DataEntity> moEntities = new ArrayList<>();
        if (!CollectionUtils.isEmpty(tomorrowResponse.getErp_mm_mo_get_response().getData())) {
            tomorrowResponse.getErp_mm_mo_get_response().getData().forEach(moEntity -> {
                if ((!StringUtils.isNullOrEmpty(moEntity.getProductlinename())) && (moEntity.getProductlinename().indexOf("3B") >= 0) && (moEntity.getDr())) {
                    moEntities.add(moEntity);
                }
            });
        }
        if (!CollectionUtils.isEmpty(todayResponse.getErp_mm_mo_get_response().getData())) {
            todayResponse.getErp_mm_mo_get_response().getData().forEach(moEntity -> {
                if ((!StringUtils.isNullOrEmpty(moEntity.getProductlinename())) && (moEntity.getProductlinename().indexOf("3B") >= 0) && (moEntity.getDr())) {
                    moEntities.add(moEntity);
                }
            });
        }
        if (!CollectionUtils.isEmpty(moEntities)) {
            moEntities.forEach(moEntity -> {
                // 获取BOM清单
                GetBomInfoResponseMsg getBomInfoResponseMsg = getBomInfo(moEntity);
            });
            // 一堆的领料单
            GetBillFullInfoResponseMsg billFullInfoResponseMsg = getBillFullInfo(moEntities);
        }
    }

    public GetMoResponseMsg getMo(DayType dayType) {
        Map<String, String> dateMap = DateUtils.getYesterdayTodayTomorrowString("yyyy-MM-dd HH:mm:ss");
        Map<String, String> dateMap2 = DateUtils.getYesterdayTodayTomorrowString("yyyy-MM-dd");
        // 需要查询的字段
        String fields = "pk_bill,bill_code,pk_corp,dr,jhkgrq,pk_workgroupname,pk_workgroup,pk_productline,productlinename,zt,pk_invbasdoc,invcode,invname,invspec,invunit,jhsl,bomver";
        GetMoRequestMsg getMoRequestMsg = new GetMoRequestMsg();
        getMoRequestMsg.setFields(fields);
//        getMoRequestMsg.setCreated_start(dateMap.get("yesterday"));
        getMoRequestMsg.setCreated_start("2000-01-01 00:00:00");
        getMoRequestMsg.setCreated_end(dateMap.get("today"));
        // 开工日期
        getMoRequestMsg.setKgrq(dateMap2.get(dayType.toString()));
        getMoRequestMsg.setBill_corpid(pkCorp);
        BaseRequestMsg baseRequestMsg = new BaseRequestMsg("erp.mm.mo.get", appKey, getCurrentTimestamp(), format, version, simplify, null, JSONObject.toJSONString(getMoRequestMsg));
        return HttpUtils.getJson(url, null, baseRequestMsg.toParameter(), GetMoResponseMsg.class);
    }

    public GetBomInfoResponseMsg getBomInfo(GetMoResponseMsg.DataEntity moEntity) {
        Map<String, String> dateMap = DateUtils.getYesterdayTodayTomorrowString("yyyy-MM-dd HH:mm:ss");
        // 需要查询的字段
        String fields = "pk_bomid,wlbmid,wlbm,wlmc,fxinvspec,fxinvtype,version,sdate,wlzjldwmc,sl,pk_bom_bid,dr,zxbmid,zxbm,zxmc,zxinvspec,zxinvtype,zxsl,zxzjldwmc";
        GetBomInfoRequestMsg getBomInfoRequestMsg = new GetBomInfoRequestMsg();
        getBomInfoRequestMsg.setFields(fields);
        getBomInfoRequestMsg.setCreated_start("2000-01-01 00:00:00");
//        getBomInfoRequestMsg.setCreated_start(dateMap.get("yesterday"));
        getBomInfoRequestMsg.setCreated_end(dateMap.get("today"));
        getBomInfoRequestMsg.setWlbm(moEntity.getInvcode());
        getBomInfoRequestMsg.setVersion(moEntity.getBomver());

        BaseRequestMsg baseRequestMsg = new BaseRequestMsg("erp.basedoc.bominfo.get", appKey, getCurrentTimestamp(), format, version, simplify, null, JSONObject.toJSONString(getBomInfoRequestMsg));
        return HttpUtils.getJson(url, null, baseRequestMsg.toParameter(), GetBomInfoResponseMsg.class);
    }

    public GetBillFullInfoResponseMsg getBillFullInfo(List<GetMoResponseMsg.DataEntity> moEntities) {
        String fields = "bill_code,rdname,pk_corp,dr,dbilldate,cdptid,deptcode";
        String fieldsItem = "pk_invbasdoc,invcode,invname,invspec,invunit,nnum,vbatchcode,dr";
        GetBillFullInfoRequestMsg getBillFullInfoRequestMsg = new GetBillFullInfoRequestMsg();
        getBillFullInfoRequestMsg.setFields(fields);
        getBillFullInfoRequestMsg.setFields_item(fieldsItem);
        getBillFullInfoRequestMsg.setPk_corp(pkCorp);
        List<GetBillFullInfoRequestMsg.CFirstBillCode> moCodes = new ArrayList<>();
        List<GetMoResponseMsg.DataEntity> filters = new ArrayList<>();

        if (!CollectionUtils.isEmpty(moEntities)) {
            moEntities.forEach(moEntity -> {
                if ((!StringUtils.isNullOrEmpty(moEntity.getProductlinename())) && (moEntity.getProductlinename().indexOf("3B") >= 0)) {
                    moCodes.add(new GetBillFullInfoRequestMsg.CFirstBillCode(moEntity.getBill_code()));
                    filters.add(moEntity);
                }
            });
        }
//        moEntities.forEach(moEntity -> {
//            moCodes.add(new GetBillFullInfoRequestMsg.CFirstBillCode(moEntity.getBill_code()));
//        });
        getBillFullInfoRequestMsg.setCfirstbillcode(moCodes);
        BaseRequestMsg baseRequestMsg = new BaseRequestMsg("erp.stock.bill.fullinfo.list", appKey, getCurrentTimestamp(), format, version, simplify, null, JSONObject.toJSONString(getBillFullInfoRequestMsg));
        return HttpUtils.getJson(url, null, baseRequestMsg.toParameter(), GetBillFullInfoResponseMsg.class);
    }

    /**
     * 获取当前时间 yyyy-MM-dd HH:mm:ss 格式
     *
     * @return
     */
    private String getCurrentTimestamp() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }

//    /**
//     * 获取添加的原料列表
//     *
//     * @return
//     */
//    private List<Material> getAddMaterials(List<>) {
//        // 将数据库中所有有效原料加入到Set中
//        List<Material>  materials = materialService.selectMaterials();
//        HashSet<String> exitMaterial = new HashSet<>();
//        if (!CollectionUtils.isEmpty(materials)) {
//            materials.forEach(material -> {
//                exitMaterial.add(material.getUuid());
//            });
//            // 遍历要比较的对象
//        }
//
//    }
}
