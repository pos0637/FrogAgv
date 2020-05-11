package com.furongsoft.agv.controllers;

import com.furongsoft.agv.models.CallMaterialModel;
import com.furongsoft.agv.models.WaveDetailModel;
import com.furongsoft.agv.services.CallMaterialService;
import com.furongsoft.base.restful.entities.RestResponse;
import lombok.NonNull;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 叫料控制层
 *
 * @author linyehai
 */
@RestController
@RequestMapping("/api/v1/agv")
public class CallMaterialController {

    private final CallMaterialService callMaterialService;

    public CallMaterialController(CallMaterialService callMaterialService) {
        this.callMaterialService = callMaterialService;
    }

    /**
     * 根据条件获取叫料列表
     *
     * @param type   类型
     * @param state  状态
     * @param teamId 班组唯一标识
     * @param areaId 区域ID
     * @return 响应内容
     */
    @GetMapping("/callMaterials")
    public RestResponse getCallMaterials(int type, @RequestParam(required = false) Integer state, @RequestParam(required = false) String teamId, @RequestParam(required = false) Long areaId, @RequestParam(required = false) Long siteId) {
        return new RestResponse(HttpStatus.OK, null, callMaterialService.selectCallMaterialsByConditions(type, state, teamId, areaId, siteId));
    }

    /**
     * 按条件查询配货任务
     *
     * @param type   叫料类型[1：灌装区；2：包装区；3：消毒间；4：拆包间]
     * @param state  状态[1：未配送；2：配送中；3：已完成]
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 响应内容
     */
    @GetMapping("/callMaterials/distributionTasks")
    public RestResponse selectDistributionTaskByConditions(int type, @RequestParam(required = false) Integer state, @RequestParam(required = false) String teamId, @RequestParam(required = false) Long areaId, @RequestParam(required = false) Long siteId) {
        return new RestResponse(HttpStatus.OK, null, callMaterialService.selectDistributionTaskByConditions(type, state, teamId, areaId, siteId));
    }

    /**
     * 获取仓库任务
     *
     * @return 响应内容
     */
    @GetMapping("/callMaterials/selectWarehouseTask")
    public RestResponse selectWarehouseTask() {
        return new RestResponse(HttpStatus.OK, null, callMaterialService.selectWarehouseTask());
    }

    /**
     * 根据叫料ID获取叫料信息
     *
     * @param id 叫料ID
     * @return 响应内容
     */
    @GetMapping("/callMaterials/{id}")
    public RestResponse getCallMaterials(@NonNull @PathVariable Long id) {
        return new RestResponse(HttpStatus.OK, null, callMaterialService.selectCallMaterialById(id));
    }

    /**
     * 新增叫料信息
     *
     * @param callMaterialModel 叫料信息
     * @return 响应内容
     */
    @PostMapping("/callMaterials")
    public RestResponse addCallMaterial(@NonNull @RequestBody CallMaterialModel callMaterialModel) {
        callMaterialService.addCallMaterial(callMaterialModel);
        return new RestResponse(HttpStatus.OK);
    }

    /**
     * 添加波次详情叫料
     *
     * @param waveDetailModels 波次详情列表
     * @return 响应内容
     */
    @PostMapping("/callMaterials/addWaveDetailCallMaterials")
    public RestResponse addWaveDetailCallMaterials(@RequestBody List<WaveDetailModel> waveDetailModels) {
        callMaterialService.addWaveDetailCallMaterials(waveDetailModels);
        return new RestResponse(HttpStatus.OK);
    }

    /**
     * 删除叫料信息
     *
     * @param id 叫料ID
     * @return 响应内容
     */
    @DeleteMapping("/callMaterials/{id}")
    public RestResponse deleteCallMaterial(@NonNull @PathVariable Long id) {
        return new RestResponse(HttpStatus.OK, null, callMaterialService.deleteCallMaterial(id));
    }

    /**
     * 通过叫料ID取消叫料
     *
     * @param id 叫料ID
     * @return 响应内容
     */
    @DeleteMapping("/callMaterials/cancel/{id}")
    public RestResponse cancelCallMaterial(@NonNull @PathVariable Long id) {
        callMaterialService.cancelCallMaterial(id);
        return new RestResponse(HttpStatus.OK);
    }

    /**
     * 通过波次取消叫料
     *
     * @param waveCode 波次编号
     * @return 响应内容
     */
    @PostMapping("/callMaterials/cancelWave")
    public RestResponse cancelWaveCallMaterials(@RequestParam String waveCode) {
        callMaterialService.cancelWaveCallMaterials(waveCode);
        return new RestResponse(HttpStatus.OK);
    }

}
