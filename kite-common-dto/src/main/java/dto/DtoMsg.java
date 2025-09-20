package dto;

import pojo.Message_v2;

import java.io.Serializable;

public class DtoMsg implements Serializable {

    private String errorCode;

    private String msg;

    private int type;

    private Message_v2 message_v2;

    public DtoMsg() {}

    public DtoMsg(String errorCode, int type, String msg, Message_v2 message_v2) {
        this.errorCode = errorCode;
        this.msg = msg;
        this.message_v2 = message_v2;
        this.type = type;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Message_v2 getMessage_v2() {
        return message_v2;
    }

    public void setMessage_v2(Message_v2 message_v2) {
        this.message_v2 = message_v2;
    }
}
