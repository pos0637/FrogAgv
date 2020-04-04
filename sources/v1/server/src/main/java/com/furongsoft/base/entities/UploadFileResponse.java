package com.furongsoft.base.entities;

import com.furongsoft.base.restful.entities.RestResponse;
import org.springframework.http.HttpStatus;

/**
 * 上传文件响应内容
 *
 * @author Alex
 */
public class UploadFileResponse extends RestResponse {
    public UploadFileResponse(HttpStatus status, Object obj) {
        super(status, null, obj);
    }
}
