package com.example.kiteemailservice.pojo;

import java.io.Serializable;

public class EmailVerVO implements Serializable {

    private String email;
    private String code;

    public EmailVerVO() {
    }

    public EmailVerVO(String email, String code) {
        this.email = email;
        this.code = code;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
