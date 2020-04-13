package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.entities.Wave;
import com.furongsoft.agv.models.WaveModel;
import com.furongsoft.base.misc.StringUtils;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.UpdateProvider;
import org.apache.ibatis.jdbc.SQL;

import java.util.List;
import java.util.Map;

/**
 * 物料表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface WaveDao extends BaseMapper<Wave> {

    /**
     * 通过波次ID获取波次信息
     *
     * @param id 波次ID
     * @return 波次信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectWaveById")
    WaveModel selectWaveById(@Param("id") Long id);

    /**
     * 通过波次编号获取波次详情
     *
     * @param code 波次编号
     * @return 波次详情
     */
    @SelectProvider(type = DaoProvider.class, method = "selectWaveByCode")
    WaveModel selectWaveByCode(@Param("code") String code);

    /**
     * 查找波次信息
     *
     * @param type   类型[1：灌装区；2：包装区]
     * @param teamId 班组ID
     * @param state  状态[0：未配送；1：配送中；2：已完成]
     * @return 波次信息集合
     */
    @SelectProvider(type = DaoProvider.class, method = "selectWaveModels")
    List<WaveModel> selectWaveModels(@Param("type") int type, @Param("teamId") String teamId, @Param("state") Integer state);

    /**
     * 通过区域ID查找波次列表
     *
     * @param areaId 区域ID
     * @return 波次信息集合
     */
    @SelectProvider(type = DaoProvider.class, method = "selectWaveModelsByAreaId")
    List<WaveModel> selectWaveModelsByAreaId(@Param("areaId") Long areaId);

    /**
     * 通过ID集合删除波次
     *
     * @param ids id集合
     * @return 是否成功
     */
    @UpdateProvider(type = DaoProvider.class, method = "deleteWavesByIds")
    int deleteWavesByIds(@Param("ids") List<Long> ids);

    /**
     * 通过编号删除波次信息
     *
     * @param code 波次编号
     * @return 是否成功
     */
    @UpdateProvider(type = DaoProvider.class, method = "deleteWaveByCode")
    boolean deleteWaveByCode(@Param("code") String code);

    class DaoProvider {
        private static final String WAVE_TABLE_NAME = Wave.class.getAnnotation(TableName.class).value();
        private static final String MATERIAL_TABLE_NAME = Material.class.getAnnotation(TableName.class).value();
        private static final String AGV_AREA_TABLE_NAME = AgvArea.class.getAnnotation(TableName.class).value();

        /**
         * 通过波次ID获取波次信息
         *
         * @return sql
         */
        public String selectWaveById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.code,t1.team_id,t1.team_name,t1.area_id,t1.material_id,t1.execution_time,t1.finish_time,t1.state,t1.type");
                    FROM(WAVE_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过编号获取波次详情
         *
         * @return sql
         */
        public String selectWaveByCode() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.code,t1.team_id,t1.team_name,t1.area_id,t1.material_id,t1.execution_time,t1.finish_time,t1.state,t1.type");
                    FROM(WAVE_TABLE_NAME + " t1");
                    WHERE("t1.code=#{code} AND t1.enabled=1");
                }
            }.toString();
        }

        /**
         * 通过波次ID获取波次信息
         *
         * @return sql
         */
        public String selectWaveModels(final Map<String, Object> param) {
            return new SQL() {
                {
                    SELECT("t1.id,t1.code,t1.team_id,t1.team_name,t1.area_id,t1.material_id,t1.execution_time,t1.finish_time,t1.state,t1.type," +
                            "t2.name AS materialName,t2.uuid AS materialCode,t3.name AS productLineName,t3.code AS productLineCode");
                    FROM(WAVE_TABLE_NAME + " t1");
                    LEFT_OUTER_JOIN(MATERIAL_TABLE_NAME + " t2 ON t1.material_id = t2.id");
                    LEFT_OUTER_JOIN(AGV_AREA_TABLE_NAME + " t3 ON t1.area_id = t3.id");
                    WHERE("t1.enabled=1 and t1.type = #{type} ");
                    if (!StringUtils.isNullOrEmpty(param.get("teamId"))) {
                        WHERE("t1.team_id = #{teamId}");
                    }
                    if (null != param.get("state") && (int) param.get("state") == 0) {
                        WHERE("t1.state <> 2");
                    } else if (null != param.get("state")) {
                        WHERE("t1.state = #{state}");
                    }
                }
            }.toString();
        }

        /**
         * 通过区域ID获取波次信息
         *
         * @return sql
         */
        public String selectWaveModelsByAreaId(final Map<String, Object> param) {
            return new SQL() {
                {
                    SELECT("t1.id,t1.code,t1.team_id,t1.team_name,t1.area_id,t1.material_id,t1.execution_time,t1.finish_time,t1.state,t1.type," +
                            "t2.name AS materialName,t2.uuid AS materialCode,t3.name AS productLineName,t3.code AS productLineCode");
                    FROM(WAVE_TABLE_NAME + " t1");
                    LEFT_OUTER_JOIN(MATERIAL_TABLE_NAME + " t2 ON t1.material_id = t2.id");
                    LEFT_OUTER_JOIN(AGV_AREA_TABLE_NAME + " t3 ON t1.area_id = t3.id");
                    WHERE("t1.enabled=1 and t1.area_id = #{areaId} ");
                }
            }.toString();
        }

        /**
         * 通过ID集合删除波次
         *
         * @param param 参数
         * @return sql
         */
        public String deleteWavesByIds(final Map<String, Object> param) {
            return new SQL() {
                {
                    UPDATE(WAVE_TABLE_NAME);
                    SET("enabled = 0");
                    StringBuffer sql = new StringBuffer();
                    List<Long> ids = (List<Long>) param.get("ids");
                    sql.append(" id in (");
                    sql.append(org.apache.commons.lang3.StringUtils.join(ids, ","));
                    sql.append(")");
                    WHERE(sql.toString());
                }
            }.toString();
        }

        /**
         * 根据编号删除波次
         *
         * @return sql
         */
        public String deleteWaveByCode() {
            return new SQL() {
                {
                    UPDATE(WAVE_TABLE_NAME);
                    SET("enabled=0");
                    WHERE("code=#{code}");
                }
            }.toString();
        }
    }
}
