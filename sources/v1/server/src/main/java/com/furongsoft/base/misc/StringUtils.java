package com.furongsoft.base.misc;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.hateoas.hal.Jackson2HalModule;

/**
 * 字符串工具类
 *
 * @author Alex
 */
public class StringUtils {
    private static ObjectMapper mapper = new ObjectMapper();

    static {
        mapper.registerModule(new Jackson2HalModule());
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        mapper.configure(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY, true);
    }

    /**
     * 字符串是否为空
     *
     * @param object 字符串
     * @return 是否为空
     */
    public static boolean isNullOrEmpty(Object object) {
        if (object == null) {
            return true;
        }

        if (!(object instanceof String)) {
            return false;
        }

        return ((String) object).isEmpty();
    }

    /**
     * 将对象转换为HAL字符串
     *
     * @param object 对象
     * @return HAL字符串
     */
    public static String toHALString(Object object) {
        try {
            return mapper.writeValueAsString(object);
        } catch (JsonProcessingException e) {
            return null;
        }
    }
}
