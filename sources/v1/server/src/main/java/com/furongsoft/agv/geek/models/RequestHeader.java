package com.furongsoft.agv.geek.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

/**
 * request header
 *
 * @author linyehai
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
public class RequestHeader {

    private String requestId;

    private String clientCode;

    private String warehouseCode;

    private String channelId ;

    private String userId;

    private String userKey;

    private String language;

    private String version;
}
