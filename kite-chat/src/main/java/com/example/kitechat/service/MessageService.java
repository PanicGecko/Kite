package com.example.kitechat.service;

import pojo.Message;
import pojo.Message_v2;
import vo.MessageVO;

import javax.websocket.Session;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MessageService {

    public boolean setOnline(String userId, String serverId);

    public void sendMessage(Message message) throws Exception;

    public Message_v2 sendMessage_v2(Message_v2 message);

    public void receivedMsg(UUID msgId);

    public int verifyUser(String token);

    public int getId(String token);

    public void userDisconnect(int userId);

}
