package com.furongsoft.base.misc;

import java.util.UUID;

/**
 * UUID工具类
 *
 * @author linyehai
 */
public class UUIDUtils {
    /**
     * 获取UUID
     *
     * @return UUID
     */
    public static String getUUID() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    /**
     * 获取指定数目的UUID
     *
     * @param number UUID数量
     * @return UUID数组
     */
    public static String[] getUUID(int number) {
        if (number < 1) {
            return null;
        }
        String[] retArray = new String[number];
        for (int i = 0; i < number; i++) {
            retArray[i] = getUUID();
        }
        return retArray;
    }
}
