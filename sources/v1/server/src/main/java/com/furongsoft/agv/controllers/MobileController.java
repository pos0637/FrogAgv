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

    /**
     * 原料信息
     */
    @Data
    @AllArgsConstructor
    private static class Material {
        private String code;
        private String name;
        private int count;
    }

    /**
     * 备货操作
     */
    @Data
    @AllArgsConstructor
    private static class StockUpModel {
        /**
         * 产品码
         */
        private String materialCode;

        /**
         * 料车码
         */
        private String materialCarCode;

        /**
         * 地标码
         */
        private String landMaskCode;

        /**
         * 原料列表
         */
        private List<Material> materials;
    }

    /**
     * 前台获取的备货任务列表
     */
    @Data
    @AllArgsConstructor
    private static class StockUpTask {
        /**
         * 产品码（用于回传）
         */
        private String materialCode;

        /**
         * 产品名称（用于展示）
         */
        private String materialName;

        /**
         * 原料列表(列表中的原料数量有默认值，支持修改)
         */
        private List<Material> materials;
    }

    private final StockUpRecordService stockUpRecordService;

    @Value("${qr-code.materialCarCode}")
    private String materialCarCode;

    /**
     * 获取今日任务的所有产品 TODO 待修改
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
     * 执行备货操作 TODO 待修改
     *
     * @return
     */
    @PostMapping("/stockUp")
    public boolean stockUp(@RequestBody StockUpRecordModel stockUpRecordModel) {
        return stockUpRecordService.stockUp(stockUpRecordModel);
    }
}
