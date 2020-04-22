package com.furongsoft.agv.controllers;

import com.furongsoft.agv.models.MaterialModel;
import com.furongsoft.agv.models.StockUpRecordModel;
import com.furongsoft.agv.services.StockUpRecordService;
import com.furongsoft.base.restful.entities.RestResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/agv/mobile")
public class MobileController {
    public MobileController(StockUpRecordService stockUpRecordService) {
        this.stockUpRecordService = stockUpRecordService;
    }

    @Data
    @AllArgsConstructor
    private static class Material {
        private String code;
        private String name;
        private int count;
    }

    private final StockUpRecordService stockUpRecordService;

    @Value("${qr-code.materialCarCode}")
    private String materialCarCode;

    /**
     * 获取今日任务的所有产品
     *
     * @return 产品列表
     */
    @GetMapping("/materials")
    public List<Material> getMaterials() {
        List<MaterialModel> materialModels = stockUpRecordService.getTodayDistributionTask();
        if (!CollectionUtils.isEmpty(materialModels)) {
            List<Material> list = new ArrayList<>();
            materialModels.forEach(materialModel -> {
                list.add(new Material(materialModel.getCode(), materialModel.getName(), materialModel.getCount()));
            });
            return list;
        } else {
            return null;
        }
    }

    /**
     * 通过二维码获取二维码相关信息（料框或者地标信息）
     *
     * @param qrCode 二维码
     * @return 响应内容
     */
    @GetMapping("/getInfo")
    public RestResponse getInfo(String qrCode) {
        if (qrCode.indexOf(materialCarCode) > 0) {
            return new RestResponse(HttpStatus.OK, null, stockUpRecordService.selectMaterialBoxModelByQrCode(qrCode));
        } else {
            return new RestResponse(HttpStatus.OK, null, stockUpRecordService.selectSiteDetailModelByQrCode(qrCode));
        }
    }

    /**
     * 执行备货操作
     *
     * @return
     */
    @PostMapping("/stockUp")
    public boolean stockUp(@RequestBody StockUpRecordModel stockUpRecordModel) {
        return stockUpRecordService.stockUp(stockUpRecordModel);
    }
}
