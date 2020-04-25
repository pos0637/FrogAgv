package com.furongsoft.agv.frog.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 基本的响应信息
 *
 * @author linyehai
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class BaseResponseMsg {
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ErrorResponse {
        /**
         * 请求失败返回的错误码
         */
        private String code;

        /**
         * 请求失败返回的错误信息
         */
        private String msg;

        /**
         * 请求失败返回的子错误码
         */
        private String sub_code;

        /**
         * 请求失败返回的子错误信息
         */
        private String sub_msg;
    }

    /**
     * 平台颁发的每次请求访问的唯一标识
     */
    private String request_id;

    /**
     * 请求是否成功
     */
    private Boolean success;

    /**
     * 请求访问失败时返回的根节点
     */
    private ErrorResponse error_response;
}
