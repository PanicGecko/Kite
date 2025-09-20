package com.example.kitechat.pojo;

import org.springframework.web.socket.WebSocketSession;

public class SessionSet {

    private WebSocketSession session;
    private int userId;


    public SessionSet() {
    }

    public SessionSet(WebSocketSession session, int userId) {
        this.session = session;
        this.userId = userId;
    }

    public WebSocketSession getSession() {
        return session;
    }

    public void setSession(WebSocketSession session) {
        this.session = session;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
