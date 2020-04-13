package com.furongsoft.agv.mappers;

import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.furongsoft.agv.entities.DeliveryTask;
import com.furongsoft.agv.entities.Material;
import com.furongsoft.agv.models.DeliveryTaskModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.UpdateProvider;
import org.apache.ibatis.jdbc.SQL;

import java.util.List;
import java.util.Map;

/**
 * 配送任务表数据库操作
 *
 * @author linyehai
 */
@Mapper
public interface DeliveryTaskDao extends BaseMapper<DeliveryTask> {
    /**
     * 通过ID获取配送任务信息
     *
     * @param id 配送任务ID
     * @return 配送任务信息
     */
    @SelectProvider(type = DaoProvider.class, method = "selectDeliveryTaskById")
    DeliveryTaskModel selectDeliveryTaskById(@Param("id") Long id);

    /**
     * 根据条件获取配送任务列表（默认获取未完成的）
     *
     * @param type  配送任务类型[1：消毒-灌装；2：灌装-消毒；3：包材-拆包；4：拆包-包材；5：包材-包装；6：包装-包材]
     * @param state 状态[0：待接单；1：取货中；2：配送中；3：已完成]
     * @return 配送任务列表
     */
    @SelectProvider(type = DaoProvider.class, method = "selectDeliveryTasksByConditions")
    List<DeliveryTaskModel> selectDeliveryTasksByConditions(@Param("type") Integer type, @Param("state") Integer state);

    /**
     * 通过ID对配送任务信息进行伪删除
     *
     * @param id 配送任务ID
     * @return 是否成功
     */
    @UpdateProvider(type = DaoProvider.class, method = "deleteDeliveryTask")
    boolean deleteDeliveryTask(@Param("id") long id);

    class DaoProvider {
        private static final String DELIVERY_TASK_MATERIAL_TABLE_NAME = DeliveryTask.class.getAnnotation(TableName.class).value();
        private static final String MATERIAL_TABLE_NAME = Material.class.getAnnotation(TableName.class).value();

        /**
         * 通过ID获取配送任务信息
         *
         * @return sql
         */
        public String selectDeliveryTaskById() {
            return new SQL() {
                {
                    SELECT("t1.id,t1.material_id,t1.count,t1.acceptance_count,t1.state,t1.call_time,t1.wave_detail_code,t1.type,t1.cancel_reason");
                    FROM(DELIVERY_TASK_MATERIAL_TABLE_NAME + " t1");
                    WHERE("t1.id = #{id}");
                }
            }.toString();
        }

        /**
         * 通过类型获取配送任务列表(默认获取到未完成的配送任务列表)
         *
         * @return sql
         */
        public String selectDeliveryTasksByConditions(final Map<String, Object> param) {
            return new SQL() {
                {
                    SELECT("t1.id,t1.task_no,t1.start_site_id,t1.end_site_id,t1.material_box_id,t1.agv_uuid,t1.state,t1.type");
                    FROM(DELIVERY_TASK_MATERIAL_TABLE_NAME + " t1 ");
                    WHERE("t1.enabled = 1 ");
                    if (null != param.get("state")) {
                        WHERE("t1.state = #{state}");
                    } else {
                        WHERE("t1.state <> 3");
                    }
                    if (null != param.get("type")) {
                        WHERE("t1.type=#{type}");
                    }
                }
            }.toString();
        }

        /**
         * 通过ID对配送任务信息进行伪删除
         *
         * @return sql
         */
        public String deleteDeliveryTask() {
            return new SQL() {
                {
                    UPDATE(DELIVERY_TASK_MATERIAL_TABLE_NAME);
                    SET("enable=0");
                    WHERE("id=#{id}");
                }
            }.toString();
        }
    }
}
