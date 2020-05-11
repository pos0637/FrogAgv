package com.furongsoft.agv.controllers;

import com.furongsoft.agv.models.StockUpRecordModel;
import com.furongsoft.agv.services.StockUpRecordService;
import com.furongsoft.base.restful.entities.RestResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

/**
 * 备货管理控制层
 *
 * @author linyehai
 */
@RestController
@RequestMapping("/api/v1/agv")
public class StockUpController {

    private final StockUpRecordService stockUpRecordService;

    @Value("${qr-code.materialCarCode}")
    private String materialCarCode;


    public StockUpController(StockUpRecordService stockUpRecordService) {
        this.stockUpRecordService = stockUpRecordService;
    }

    /**
     * 通过二维码获取二维码相关信息（料框或者地标信息）
     *
     * @param qrCode 二维码
     * @return 响应内容
     */
    @GetMapping("/stockUp/getInfo")
    public RestResponse getInfo(String qrCode) {
        if (qrCode.indexOf(materialCarCode) > 0) {
            return new RestResponse(HttpStatus.OK, null, stockUpRecordService.selectMaterialBoxModelByQrCode(qrCode));
        } else {
            return new RestResponse(HttpStatus.OK, null, stockUpRecordService.selectSiteDetailModelByQrCode(qrCode));
        }
    }

    /**
     * 获取今日任务
     *
     * @return 响应内容
     */
    @GetMapping("/stockUp/getTasks")
    public RestResponse getTodayDistributionTask() {
        return new RestResponse(HttpStatus.OK, null, stockUpRecordService.getTodayDistributionTask());
    }

    /**
     * 执行备货操作
     *
     * @return
     */
    @PostMapping("/stockUp")
    public RestResponse stockUp(@RequestBody StockUpRecordModel stockUpRecordModel) {
//        stockUpRecordService.stockUp(stockUpRecordModel);
        return new RestResponse(HttpStatus.OK);
    }
}
