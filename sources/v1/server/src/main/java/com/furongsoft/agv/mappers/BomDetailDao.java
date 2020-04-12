package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.BomDetail;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.models.BomDetailModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;

import java.util.List;

/**
 * BOM表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface BomDetailDao extends BaseMapper<BomDetail> {

    /**
     * 通过BOM ID获取BOM信息
     *
     * @param id BOM ID
     * @return BOM信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectBomDetailById")
    BomDetailModel selectBomDetailById(@Param("id") Long id);

    /**
     * 通过BOMID获取BOM详情集合
     *
     * @param bomId
     * @return BOM详情集合
     */
    @SelectProvider(type = DaoProvider.class, method = "selectBomDetailByBomId")
    List<BomDetailModel> selectBomDetailByBomId(@Param("bomId") long bomId);

    class DaoProvider {
        private static final String BOM_DETAIL_TABLE_NAME = BomDetail.class.getAnnotation(TableName.class).value();
        private static final String MATERIAL_TABLE_NAME = Material.class.getAnnotation(TableName.class).value();

        /**
         * 通过BOMID获取BOM信息
         *
         * @return sql
         */
        public String selectBomDetailById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.bom_id,t1.material_code,t1.count,t1.type,t2.name AS materialName");
                    FROM(BOM_DETAIL_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过物料编号获取BOM信息
         *
         * @return sql
         */
        public String selectBomDetailByBomId() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.bom_id,t1.material_code,t1.count,t1.type,t2.name AS materialName,t2.id AS materialId");
                    FROM(BOM_DETAIL_TABLE_NAME + " t1");
                    LEFT_OUTER_JOIN(MATERIAL_TABLE_NAME +" t2 ON t1.material_code = t2.uuid");
                    WHERE("t1.bom_id=#{bomId} AND t1.enabled=1");
                }
            }.toString();
        }

    }
}
