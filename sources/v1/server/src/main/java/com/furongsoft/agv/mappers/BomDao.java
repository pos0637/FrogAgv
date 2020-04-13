package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.Bom;
import com.furongsoft.agv.models.BomModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;

/**
 * BOM表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface BomDao extends BaseMapper<Bom> {

    /**
     * 通过BOM ID获取BOM信息
     *
     * @param id BOM ID
     * @return BOM信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectBomById")
    BomModel selectBomById(@Param("id") Long id);

    /**
     * 通过BOM编号获取BOM详情
     *
     * @param materialCode 物料编号
     * @return BOM详情
     */
    @SelectProvider(type = DaoProvider.class, method = "selectBomByMaterialCode")
    BomModel selectBomByMaterialCode(@Param("materialCode") String materialCode);

    class DaoProvider {
        private static final String BOM_TABLE_NAME = Bom.class.getAnnotation(TableName.class).value();

        /**
         * 通过BOMID获取BOM信息
         *
         * @return sql
         */
        public String selectBomById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.material_code,t1.full_count,t1.version");
                    FROM(BOM_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过物料编号获取BOM信息
         *
         * @return sql
         */
        public String selectBomByMaterialCode() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.material_code,t1.full_count,t1.version");
                    FROM(BOM_TABLE_NAME + " t1");
                    WHERE("t1.material_code=#{materialCode} AND t1.enabled=1");
                }
            }.toString();
        }

    }
}
