package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.AgvArea;
import com.furongsoft.agv.entities.CallButton;
import com.furongsoft.agv.entities.Site;
import com.furongsoft.agv.models.CallButtonModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;

import java.util.Map;

/**
 * 叫料按钮表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface CallButtonDao extends BaseMapper<CallButton> {
    /**
     * 通过ID获取叫料按钮信息
     *
     * @param id 主键
     * @return 叫料按钮信息
     */
    @SelectProvider(type = CallButtonDao.DaoProvider.class, method = "selectCallButtonById")
    CallButtonModel selectCallButtonById(@Param("id") Long id);

    /**
     * 通过编码获取叫料按钮信息
     *
     * @param code 编码
     * @return 叫料按钮信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectCallButtonByCode")
    CallButtonModel selectCallButtonByCode(@Param("code") String code);

    /**
     * 通过IP地址查找按钮所属区域
     *
     * @param ipAddress ip地址
     * @return 按钮信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectCallButtonAreaByIpAddress")
    CallButtonModel selectCallButtonAreaByIpAddress(@Param("ipAddress") String ipAddress, @Param("buttonCode") String buttonCode);

    class DaoProvider {
        private static final String CALL_BUTTON_TABLE_NAME = CallButton.class.getAnnotation(TableName.class).value();
        private static final String SITE_TABLE_NAME = Site.class.getAnnotation(TableName.class).value();
        private static final String AGV_AREA_TABLE_NAME = AgvArea.class.getAnnotation(TableName.class).value();
        private static final String AREA_SITE_TABLE_NAME = "t_agv_area_site";


        /**
         * 通过ID获取叫料按钮信息
         *
         * @return sql
         */
        public String selectCallButtonById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.ip_address,t1.button_code,t1.site_id,t1.code,t1.name");
                    FROM(CALL_BUTTON_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过类型获取叫料按钮信息
         *
         * @return sql
         */
        public String selectCallButtonByCode(final Map<String, Object> param) {
            return new SQL() {
                {
                    SELECT("t1.id,t1.ip_address,t1.button_code,t1.site_id,t1.code,t1.name");
                    FROM(CALL_BUTTON_TABLE_NAME + " t1");
                    WHERE("t1.code = #{code}");
                }
            }.toString();
        }

        /**
         * 通过IP地址查找按钮所属区域信息
         *
         * @return sql
         */
        public String selectCallButtonAreaByIpAddress() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.ip_address,t1.button_code,t1.site_id,t1.code,t1.name,t3.name AS areaName,t3.id AS areaId, t3.type AS areaType");
                    FROM(CALL_BUTTON_TABLE_NAME + " t1");
                    LEFT_OUTER_JOIN(AREA_SITE_TABLE_NAME + " t2 ON t2.site_id = t1.site_id");
                    LEFT_OUTER_JOIN(AGV_AREA_TABLE_NAME + " t3 ON t2.area_id = t3.id");
                    WHERE("t1.ip_address = #{ipAddress} AND t1.button_code = #{buttonCode}");
                }
            }.toString();
        }
    }
}
