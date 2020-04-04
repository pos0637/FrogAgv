//package com.furongsoft.schedulers;
//
//import com.furongsoft.base.misc.DataMemoryManager;
//import com.furongsoft.base.misc.StringUtils;
//import com.furongsoft.base.rbac.entities.Config;
//import com.furongsoft.base.rbac.entities.User;
//import com.furongsoft.base.rbac.mappers.UserDao;
//import com.furongsoft.distribution.entities.IncomeDetail;
//import com.furongsoft.distribution.entities.IncomeUser;
//import com.furongsoft.distribution.mappers.IncomeDetailDao;
//import com.furongsoft.distribution.mappers.IncomeUserDao;
//import com.furongsoft.shop.mappers.GoodDao;
//import com.furongsoft.shop.models.GoodUser;
//import org.apache.shiro.util.CollectionUtils;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.core.annotation.Order;
//import org.springframework.scheduling.annotation.EnableScheduling;
//import org.springframework.scheduling.annotation.SchedulingConfigurer;
//import org.springframework.scheduling.config.ScheduledTaskRegistrar;
//import org.springframework.scheduling.support.CronTrigger;
//
//import java.util.List;
//
///**
// * @author chenfuqian
// */
//@Configuration
//@EnableScheduling
//@Order(2)
//public class ShopSchedulerConfig implements SchedulingConfigurer {
//    private final GoodDao goodDao;
//    private final IncomeDetailDao incomeDetailDao;
//    private final IncomeUserDao incomeUserDao;
//    private final UserDao userDao;
//
//    public ShopSchedulerConfig(GoodDao goodDao, IncomeDetailDao incomeDetailDao, IncomeUserDao incomeUserDao, UserDao userDao) {
//        this.goodDao = goodDao;
//        this.incomeDetailDao = incomeDetailDao;
//        this.incomeUserDao = incomeUserDao;
//        this.userDao = userDao;
//    }
//
//
//    @Override
//    public void configureTasks(ScheduledTaskRegistrar scheduledTaskRegistrar) {
//        scheduledTaskRegistrar.addTriggerTask(
//                () -> {
//                    handleGoodUser();
//                },
//                triggerContext -> {
//                    //  每5分钟检查一次用户数据
//                    return new CronTrigger("0 */1 * * * ?").nextExecutionTime(triggerContext);
//                }
//        );
//    }
//
//    private void handleGoodUser() {
//        List<GoodUser> goodUserList = goodDao.selectGoodUser();
//        Config config = DataMemoryManager.getInstance().getConfig();
//        if (!CollectionUtils.isEmpty(goodUserList)) {
//            goodUserList.forEach(goodUser -> {
//                calc(goodUser, 1, config);
//                goodDao.deleteGoodUser(goodUser.getId());
//            });
//        }
//    }
//
//    // 计算当前 goodUser 信息的收益
//    private void calc(GoodUser goodUser, int agent, Config config) {
//        if (goodUser != null && !StringUtils.isNullOrEmpty(goodUser.getOpenid()) && agent <= 3) {
//            Integer incomeRatio = 0;
//            if (agent == 1) {
//                incomeRatio = config.getLevel1();
//            } else if (agent == 2) {
//                incomeRatio = config.getLevel2();
//            } else {
//                incomeRatio = config.getLevel3();
//            }
//            IncomeDetail detail = new IncomeDetail();
//            detail.setMoney(incomeRatio);
//            detail.setAgentLevel(agent);
//            detail.setBeneficiaries(goodUser.getOpenid());
//            detail.setConsumer(goodUser.getRecommendOpenid());
//            incomeDetailDao.insert(detail);
//            // 处理个人总收益
//            IncomeUser incomeUser = incomeUserDao.selectCountByOpenid(goodUser.getOpenid());
//            if (incomeUser == null) {
//                incomeUser = new IncomeUser();
//                incomeUser.setMoney(incomeRatio);
//                incomeUser.setOpenid(goodUser.getOpenid());
//                incomeUserDao.insert(incomeUser);
//            } else {
//                incomeUserDao.addMoney(incomeRatio,incomeUser.getId());
//            }
//            if (!StringUtils.isNullOrEmpty(goodUser.getRecommendOpenid())) {
//                goodUser = goodDao.selectCountGoodUser(goodUser.getRecommendOpenid(),goodUser.getGoodId());
//                calc(goodUser, agent + 1, config);
//            }
//        }
//    }
//}
