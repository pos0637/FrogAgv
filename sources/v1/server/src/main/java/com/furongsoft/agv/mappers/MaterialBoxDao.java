package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.MaterialBox;
import com.furongsoft.agv.models.MaterialBoxModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;

/**
 * 料框表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface MaterialBoxDao extends BaseMapper<MaterialBox> {

    /**
     * 通过料框ID获取料框信息
     *
     * @param id 料框ID
     * @return 料框信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectMaterialBoxById")
    MaterialBoxModel selectMaterialBoxById(@Param("id") Long id);

    class DaoProvider {
        private static final String MATERIAL_BOX_TABLE_NAME = MaterialBox.class.getAnnotation(TableName.class).value();

        /**
         * 通过料框ID获取料框信息
         *
         * @return sql
         */
        public String selectMaterialBoxById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.qr_code,t1.name,t1.state");
                    FROM(MATERIAL_BOX_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }
    }
}
