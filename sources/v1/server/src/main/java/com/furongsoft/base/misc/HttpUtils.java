package com.furongsoft.base.misc;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/**
 * HTTP请求工具
 *
 * @author Alex
 */
public class HttpUtils {
    /**
     * POST请求
     *
     * @param url     资源地址
     * @param headers 头部数据
     * @param data    数据
     * @param clazz   类型
     * @return 结果
     */
    public static <T> T postJson(String url, Map<String, String> headers, Object data, Class<T> clazz) {
        if (headers == null) {
            headers = new LinkedHashMap<>();
        }

        headers.put("Accept", "application/json");
        headers.put("Content-type", "application/json");

        return post(url, headers, data, clazz);
    }

    /**
     * POST请求
     *
     * @param url     资源地址
     * @param headers 头部数据
     * @param data    数据
     * @param clazz   类型
     * @return 结果
     */
    public static <T> T post(String url, Map<String, String> headers, Object data, Class<T> clazz) {
        HttpClient httpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(url);
        if (headers != null) {
            Set<String> keySet = headers.keySet();
            for (String s : keySet) {
                httpPost.addHeader(s, headers.get(s));
            }
        }

        try {
            ObjectMapper mapper = new ObjectMapper();
            String request = mapper.writeValueAsString(data);
            StringEntity s = new StringEntity(request, "utf-8");
            httpPost.setEntity(s);
            HttpResponse httpResponse = httpClient.execute(httpPost);
            HttpEntity httpEntity = httpResponse.getEntity();
            if (httpEntity != null) {
                String result = EntityUtils.toString(httpEntity, "utf-8");
                return mapper.readValue(result, clazz);
            }

            return null;
        } catch (IOException e) {
            Tracker.error(e);
            return null;
        }
    }
}
