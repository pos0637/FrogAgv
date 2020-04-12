package com.furongsoft.agv.geek.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

/**
 * 回调消息
 *
 * @author linyehai
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
public class MovingCallbackMsg {

    private RequestHeader header;

    private WorkflowApiMsg body;
}
