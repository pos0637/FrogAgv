package com.furongsoft.agv.services;

import com.furongsoft.agv.entities.StockUpRecord;
import com.furongsoft.agv.mappers.StockUpRecordDao;
import com.furongsoft.agv.models.StockUpRecordModel;
import com.furongsoft.base.services.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 备货服务
 *
 * @author linyehai
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class StockUpRecordService extends BaseService<StockUpRecordDao, StockUpRecord> {

    private final StockUpRecordDao stockUpRecordDao;

    @Autowired
    public StockUpRecordService(StockUpRecordDao stockUpRecordDao) {
        super(stockUpRecordDao);
        this.stockUpRecordDao = stockUpRecordDao;
    }

    /**
     * 通过主键获取备货详情
     *
     * @param id 备货ID
     * @return 备货信息
     */
    public StockUpRecordModel selectStockUpRecordById(Long id) {
        return stockUpRecordDao.selectStockUpRecordById(id);
    }

//    public
}
