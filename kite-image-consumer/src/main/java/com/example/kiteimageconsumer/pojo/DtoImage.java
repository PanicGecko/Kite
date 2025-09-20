package com.example.kiteimageconsumer.pojo;

import java.io.Serializable;

public class DtoImage implements Serializable {

    private String errorCode;

    private String msg;

    private String success;

    private byte[] data;

    public DtoImage() {}

    public DtoImage(String errorCode, String msg, String success, byte[] data) {
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

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

}
