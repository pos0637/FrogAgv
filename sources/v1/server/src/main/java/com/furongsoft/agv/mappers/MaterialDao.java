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

//        public String selectCashoutDetail(final Map<String, Object> param) {
//            return new SQL() {
//                {
//                    SELECT("t2.name,t2.mobile,t1.money,t1.create_time AS applyTime,t2.openid,t1.id,t1.attachment_id,t1.status");
//                    FROM("t_cashout_detail t1,t_sys_user t2");
//                    WHERE("t1.create_user = t2.id");
//                    if (!StringUtils.isNullOrEmpty(param.get("status"))) {
//                        WHERE("t1.status = #{status}");
//                    }
//                    if (!StringUtils.isNullOrEmpty(param.get("name"))) {
//                        WHERE("t2.name LIKE CONCAT('%', #{name},'%')");
//                    }
//                    ORDER_BY("t1.create_time DESC ");
//                }
//            }.toString();
//        }
    }
}
