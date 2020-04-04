package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.CallMaterial;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.models.CallMaterialModel;
import com.furongsoft.base.misc.StringUtils;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
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

    @SelectProvider(type = DaoProvider.class, method = "selectCallMaterialById")
    CallMaterialModel selectCallMaterialById(@Param("id") Long id);

    /**
     * 通过类型获取叫料列表
     *
     * @param type 类型【1：灌装区；2：包装区；3：消毒间；4：拆包间】
     * @return 叫料列表
     */
    @SelectProvider(type = DaoProvider.class, method = "selectCallMaterialsByConditions")
    List<CallMaterialModel> selectCallMaterialsByConditions(@Param("type") int type, @Param("state") int state, @Param("teamId") String teamId, @Param("areaId") Long areaId);

    class DaoProvider {
        private static final String CALL_MATERIAL_TABLE_NAME = CallMaterial.class.getAnnotation(TableName.class).value();
        private static final String MATERIAL_TABLE_NAME = Material.class.getAnnotation(TableName.class).value();

        /**
         * 通过ID进行叫料
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
         * 通过类型获取叫料列表
         *
         * @return sql
         */
        public String selectCallMaterialsByConditions(final Map<String, Object> param) {
            return new SQL() {
                {
                    SELECT("t1.id,t1.material_id,t1.count,t1.acceptance_count,t1.state,t1.call_time,t1.wave_detail_code,t1.cancel_reason,t1.area_id,t1.team_id, " +
                            "t2.name AS productName, t2.code AS productCode, t2.uuid AS productUuid, t2.specs AS productSpecs, t2.unit AS productUnit, " +
                            "t2.batch AS productBatch");
                    FROM(CALL_MATERIAL_TABLE_NAME+" t1 ");
                    LEFT_OUTER_JOIN(MATERIAL_TABLE_NAME+" t2 ON t1.material_id = t2.id ");
                    WHERE("t1.enabled = 1 and t1.type=#{type} and t1.state = {state}");
                    if (!StringUtils.isNullOrEmpty(param.get("teamId"))) {
                        WHERE("t1.team_id = #{teamId}");
                    }
                    if (param.get("areaId") != null) {
                        WHERE("t1.area_id = #{areaId}");
                    }
                }
            }.toString();
        }
    }
}
