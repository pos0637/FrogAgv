package com.furongsoft.agv.controllers;

import com.furongsoft.agv.frog.models.BomModel;
import com.furongsoft.agv.frog.services.BomService;
import com.furongsoft.agv.mappers.MaterialDao;
import com.furongsoft.agv.models.*;
import com.furongsoft.agv.services.CallMaterialService;
import com.furongsoft.agv.services.StockUpRecordService;
import com.furongsoft.agv.services.WaveDetailService;
import com.furongsoft.base.misc.Tracker;
import com.furongsoft.base.restful.entities.RestResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/agv/mobile")
public class MobileController {
    public MobileController(StockUpRecordService stockUpRecordService, CallMaterialService callMaterialService, MaterialDao materialDao, BomService bomService, WaveDetailService waveDetailService) {
        this.stockUpRecordService = stockUpRecordService;
        this.callMaterialService = callMaterialService;
        this.materialDao = materialDao;
        this.bomService = bomService;
        this.waveDetailService = waveDetailService;
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
    private static class Product {
        /**
         * 产品码（用于回传）
         */
        private String code;

        /**
         * 产品名称（用于展示）
         */
        private String name;

        /**
         * 原料列表(列表中的原料数量有默认值，支持修改)
         */
        private List<Material> materials;
    }

    private final StockUpRecordService stockUpRecordService;
    private final CallMaterialService callMaterialService;
    private final MaterialDao materialDao;
    private final BomService bomService;
    private final WaveDetailService waveDetailService;

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
     * 获取产品列表
     *
     * @return 产品列表
     */
    @GetMapping("/products")
    public List<Product> getProducts(@RequestParam(required = false) String areaCode) {
        List<CallMaterialModel> callModels = callMaterialService.selectUnDeliveryWaves(areaCode);
        List<Product> backProducts = new ArrayList<>();
        if (!CollectionUtils.isEmpty(callModels)) {
            callModels.forEach(callMaterialModel -> {
                MaterialModel materialModel = materialDao.selectMaterialById(callMaterialModel.getMaterialId());
                // 查找BOM获取满料数量  产品ID、名称、数量、编号、类型
                BomModel bomModel = bomService.selectBomByMaterialUuid(materialModel.getUuid());
                // name = 产品名称+[包材类型]+
                String materialName = "";
                // code = 波次编码+类型+区域ID+站点ID
                String waveKey = callMaterialModel.getWaveCode() + "_" + callMaterialModel.getType();
                // 如果是包装区叫料
                if (!StringUtils.isEmpty(callMaterialModel.getProductLineCode())) {
                    materialName += callMaterialModel.getProductLineCode() + "_";
                    if (null != callMaterialModel.getSiteId()) {
                        materialName += "_" + callMaterialModel.getSiteId();
                    }
                }
                if (callMaterialModel.getType() == 2) {
                    materialName += materialModel.getName() + "[外包材]";
                } else {
                    materialName += materialModel.getName() + "[内包材]";
                }
                if (null != callMaterialModel.getAreaId()) {
                    waveKey += "_" + callMaterialModel.getAreaId();
                } else {
                    waveKey += "_0";
                }
                if (null != callMaterialModel.getSiteId()) {
                    waveKey += "_" + callMaterialModel.getSiteId();
                } else {
                    waveKey += "_0";
                }
                List<WaveDetailModel> waveDetailModels = waveDetailService.selectWaveDetails(callMaterialModel.getWaveCode());
                List<Material> materials = new ArrayList<>();
                if (!CollectionUtils.isEmpty(waveDetailModels)) {
                    waveDetailModels.forEach(waveDetailModel -> {
                        materials.add(new Material(waveDetailModel.getMaterialCode(), waveDetailModel.getMaterialName(), waveDetailModel.getCount()));
                    });
                }
                Product product = new Product(waveKey, materialName, materials);
                backProducts.add(product);
            });
        }
        return backProducts;
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

//    /**
//     * 执行发货操作 TODO 待修改
//     *
//     * @return
//     */
//    @PostMapping("/stockUp")
//    public boolean stockUp(@RequestBody StockUpModel stockUpModel) {
//        return stockUpRecordService.stockUp(stockUpModel.getMaterialCode(), stockUpModel.getMaterialCarCode(), stockUpModel.getLandMaskCode());
//    }

    /**
     * 执行发货操作
     *
     * @return
     */
    @PostMapping("/stockUp")
    public String stockUp(String materialName, String materialCarName, String landMaskName) {
        try {
            return stockUpRecordService.stockUp(materialName, materialCarName, landMaskName);
        } catch (Exception ex) {
            Tracker.error(ex);
            return "发货失败，请重试！";
        }
    }
}
