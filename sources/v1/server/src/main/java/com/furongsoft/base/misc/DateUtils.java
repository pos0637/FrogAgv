package com.furongsoft.base.misc;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 日期工具类
 *
 * @author linyehai
 */
public class DateUtils {
    /**
     * 获取Date格式的今日、昨日、明日
     *
     * @return 三日Map
     */
    public static Map<String, Date> getYesterdayTodayTomorrow() {
        Map<String, Date> map = new HashMap<>();
        Date today = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(today);
        int day = calendar.get(Calendar.DATE);
        map.put("today", today);
        calendar.set(Calendar.DATE, day - 1);
        map.put("yesterday", calendar.getTime());
        calendar.set(Calendar.DATE, day + 1);
        map.put("tomorrow", calendar.getTime());
        return map;
    }
}
