package dto;

import java.io.Serializable;

public class Dto implements Serializable {

    private String errorCode;

    private String msg;

    private String success;

    private Object data;

    public Dto() {}

    public Dto(String errorCode, String msg, String success, Object data) {
        this.errorCode = errorCode;
        this.msg = msg;
        this.success = success;
        this.data = data;
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

    public String getSuccess() {
        return success;
    }

    public void setSuccess(String success) {
        this.success = success;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

}
