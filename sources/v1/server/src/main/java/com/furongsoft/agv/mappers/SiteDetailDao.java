package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.SiteDetail;
import com.furongsoft.agv.models.SiteDetailModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;

/**
 * 库位详情表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface SiteDetailDao extends BaseMapper<SiteDetail> {

    /**
     * 通过ID获取站点详情信息
     *
     * @param id 站点详情ID
     * @return 站点详情信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectSiteDetailById")
    SiteDetailModel selectSiteDetailById(@Param("id") Long id);

    /**
     * 通过站点ID获取站点详情
     *
     * @param siteId 站点ID
     * @return 站点详情
     */
    @SelectProvider(type = DaoProvider.class, method = "selectSiteDetailBySiteId")
    SiteDetailModel selectSiteDetailBySiteId(@Param("siteId") Long siteId);

    class DaoProvider {
        private static final String SITE_DETAIL_TABLE_NAME = SiteDetail.class.getAnnotation(TableName.class).value();

        /**
         * 通过波次ID获取波次信息
         *
         * @return sql
         */
        public String selectSiteDetailById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.site_id,t1.stock_up_record_id,t1.state,t1.delivery_task_id,t1.enabled");
                    FROM(SITE_DETAIL_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过站点ID获取站点详情
         *
         * @return sql
         */
        public String selectSiteDetailBySiteId() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.site_id,t1.stock_up_record_id,t1.state,t1.delivery_task_id,t1.enabled");
                    FROM(SITE_DETAIL_TABLE_NAME + " t1");
                    WHERE("t1.site_id = #{siteId}");
                }
            }.toString();
        }

    }
}
