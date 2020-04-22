package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.*;
import com.furongsoft.agv.models.CallMaterialModel;
import com.furongsoft.base.misc.StringUtils;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.UpdateProvider;
import org.apache.ibatis.jdbc.SQL;

import java.util.List;
import java.util.Map;

/**
 * 叫料表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface CallMaterialDao extends BaseMapper<CallMaterial> {
    /**
     * 通过ID获取叫料信息
     *
     * @param id 叫料ID
     * @return 叫料信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectCallMaterialById")
    CallMaterialModel selectCallMaterialById(@Param("id") Long id);

    /**
     * 通过ID获取未配送的叫料信息
     *
     * @param id 叫料ID
     * @return 叫料信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectUnDeliveryCallMaterialById")
    CallMaterialModel selectUnDeliveryCallMaterialById(@Param("id") Long id);

    /**
     * 根据条件获取叫料列表（默认获取未完成的）
     *
     * @param type   叫料类型[1：灌装区；2：包装区；3：消毒间；4：拆包间]
     * @param state  状态[1：未配送；2：配送中；3：已完成；4：已取消]
     * @param teamId 班组唯一标识
     * @param areaId 区域ID（产线ID）
     * @return 叫料列表
     */
    @SelectProvider(type = DaoProvider.class, method = "selectCallMaterialsByConditions")
    List<CallMaterialModel> selectCallMaterialsByConditions(@Param("type") int type, @Param("state") Integer state, @Param("teamId") String teamId, @Param("areaId") Long areaId);

    /**
     * 通过波次详情编码以及区域类型获取叫料信息
     *
     * @param waveDetailCode 波次详情编码
     * @param areaType       区域类型
     * @return 叫料信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectCallMaterialByWaveDetailCodeAndAreaType")
    CallMaterialModel selectCallMaterialByWaveDetailCodeAndAreaType(@Param("waveDetailCode") String waveDetailCode, @Param("areaType") int areaType);

    /**
     * 通过ID对叫料信息进行伪删除
     *
     * @param id 叫料ID
     * @return 是否成功
     */
    @UpdateProvider(type = DaoProvider.class, method = "deleteCallMaterial")
    boolean deleteCallMaterial(@Param("id") long id);

    /**
     * 更新叫料状态
     *
     * @param id    叫料ID
     * @param state 状态
     * @return 是否成功
     */
    @UpdateProvider(type = DaoProvider.class, method = "updateCallMaterialState")
    boolean updateCallMaterialState(@Param("id") long id, int state);

    class DaoProvider {
        private static final String CALL_MATERIAL_TABLE_NAME = CallMaterial.class.getAnnotation(TableName.class).value();
        private static final String MATERIAL_TABLE_NAME = Material.class.getAnnotation(TableName.class).value();
        private static final String WAVE_TABLE_NAME = Wave.class.getAnnotation(TableName.class).value();
        private static final String WAVE_DETAIL_TABLE_NAME = WaveDetail.class.getAnnotation(TableName.class).value();
        private static final String AGV_AREA_TABLE_NAME = AgvArea.class.getAnnotation(TableName.class).value();

        /**
         * 通过ID获取叫料信息
         *
         * @return sql
         */
        public String selectCallMaterialById() {
            return new SQL() {
                {
                    SELECT("t1.material_id,t1.count,t1.acceptance_count,t1.state,t1.call_time,t1.wave_detail_code,t1.type,t1.cancel_reason");
                    FROM(CALL_MATERIAL_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过ID获取未配送的叫料信息
         *
         * @return sql
         */
        public String selectUnDeliveryCallMaterialById() {
            return new SQL() {
                {
                    SELECT("t1.material_id,t1.count,t1.acceptance_count,t1.state,t1.call_time,t1.wave_detail_code,t1.type,t1.cancel_reason");
                    FROM(CALL_MATERIAL_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id} AND t1.state=1");
                }
            }.toString();
        }

        /**
         * 通过类型获取叫料列表(默认获取到未完成的叫料列表)
         *
         * @return sql
         */
        public String selectCallMaterialsByConditions(final Map<String, Object> param) {
            return new SQL() {
                {
                    SELECT("t1.id,t1.material_id,t1.count,t1.acceptance_count,t1.state,t1.call_time,t1.wave_detail_code,t1.cancel_reason,t1.area_id,t1.team_id, " +
                            "t2.name AS materialName, t2.code AS materialCode, t2.uuid AS materialUuid, t2.specs AS materialSpecs, t2.unit AS materialUnit, " +
                            "t2.batch AS materialBatch, t4.code AS waveCode, t4.material_id AS productId, t5.name AS productName, t5.uuid AS productUuid, t6.code AS productLineCode");
                    FROM(CALL_MATERIAL_TABLE_NAME + " t1 ");
                    LEFT_OUTER_JOIN(MATERIAL_TABLE_NAME + " t2 ON t1.material_id = t2.id ");
                    LEFT_OUTER_JOIN(WAVE_DETAIL_TABLE_NAME + " t3 ON t1.wave_detail_code = t3.code");
                    LEFT_OUTER_JOIN(WAVE_TABLE_NAME + " t4 ON t4.code = t3.wave_code");
                    LEFT_OUTER_JOIN(MATERIAL_TABLE_NAME + " t5 ON t4.material_id = t5.id ");
                    LEFT_OUTER_JOIN(AGV_AREA_TABLE_NAME + " t6 ON t1.area_id = t6.id");
                    WHERE("t1.enabled = 1 and t1.type=#{type} and t3.enabled=1 and t4.enabled=1");
                    if (null != param.get("state") && (int) param.get("state") == 0) {
                        WHERE("t1.state <> 3 AND t1.state <>4");
                    } else if (null != param.get("state")) {
                        WHERE("t1.state = #{state}");
                    }
                    if (!StringUtils.isNullOrEmpty(param.get("teamId"))) {
                        WHERE("t1.team_id = #{teamId}");
                    }
                    if (null != param.get("areaId")) {
                        WHERE("t1.area_id = #{areaId}");
                    }
                }
            }.toString();
        }

        /**
         * 通过ID对叫料信息进行伪删除
         *
         * @return sql
         */
        public String deleteCallMaterial() {
            return new SQL() {
                {
                    UPDATE(CALL_MATERIAL_TABLE_NAME);
                    SET("enabled=0");
                    WHERE("id=#{id}");
                }
            }.toString();
        }

        /**
         * 通过波次详情编码以及区域类型获取叫料信息
         *
         * @return sql
         */
        public String selectCallMaterialByWaveDetailCodeAndAreaType() {
            return new SQL() {
                {
                    SELECT("t1.material_id,t1.count,t1.acceptance_count,t1.state,t1.call_time,t1.wave_detail_code,t1.type,t1.cancel_reason");
                    FROM(CALL_MATERIAL_TABLE_NAME + " t1");
                    WHERE("t1.wave_detail_code = #{waveDetailCode} AND t1.type = #{areaType} AND t1.enabled = 1");
                }
            }.toString();
        }

        /**
         * 更新叫料状态
         *
         * @return sql
         */
        public String updateCallMaterialState() {
            return new SQL() {
                {
                    UPDATE(CALL_MATERIAL_TABLE_NAME);
                    SET("state=#{state}");
                    WHERE("id=#{id}");
                }
            }.toString();
        }
    }
}
