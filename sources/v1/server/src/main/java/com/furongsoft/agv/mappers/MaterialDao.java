package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.models.MaterialModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;

/**
 * 物料表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface MaterialDao extends BaseMapper<Material> {

    @SelectProvider(type = DaoProvider.class, method = "selectMaterialById")
    MaterialModel selectMaterialById(@Param("id") Long id);

    /**
     * 通过产品Uuid获取产品信息
     *
     * @param uuid 唯一标识
     * @return 原料信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectMaterialByUuid")
    MaterialModel selectMaterialByUuid(@Param("uuid") String uuid);

    class DaoProvider {
        private static final String MATERIAL_TABLE_NAME = Material.class.getAnnotation(TableName.class).value();

        public String selectMaterialById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.code,t1.name,t1.uuid");
                    FROM(MATERIAL_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过唯一标识获取原料信息
         *
         * @return sql
         */
        public String selectMaterialByUuid() {
            return new SQL() {
                {
                    SELECT("t1.id, t1.code, t1.name, t1.uuid");
                    FROM(MATERIAL_TABLE_NAME + " t1");
                    WHERE("t1.uuid=#{uuid}");
                }
            }.toString();
        }
    }
}
