package com.example.kitechat.service.impl;

import com.example.kitechat.service.MessageService;
import org.apache.dubbo.config.annotation.DubboReference;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pojo.Message;
import pojo.Message_v2;
import service.RpcChatService;
import service.RpcTokenService;
import service.RpcUserService;
import vo.MessageVO;

import javax.websocket.Session;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class MessageServiceImpl implements MessageService {

    @DubboReference
    private RpcChatService chatService;

    @DubboReference
    private RpcTokenService tokenService;

    @DubboReference
    private RpcUserService userService;

    @Override
    public boolean setOnline(String userId, String serverId) {
        System.out.println("User uploaded to redis");
        return chatService.setOnline(userId, serverId);
    }

    @Override
    public void sendMessage(Message message) throws Exception {
        chatService.sendMessage(message);
    }

    @Override
    public Message_v2 sendMessage_v2(Message_v2 message){

        try {
            return chatService.sendMessage_v2(message);
        } catch (Exception e) {
            System.out.println("sendMessage_v2 error: " + e.getMessage());
            return null;
        }

    }

    @Override
    public void receivedMsg(UUID msgId) {
        chatService.receivedMsg(msgId);
    }

    @Override
    public int verifyUser(String token) {
        return tokenService.checkJwt(token);
    }

    @Override
    public int getId(String token) {
        return tokenService.getId(token);
    }

    @Override
    public void userDisconnect(int userId) {
        userService.setLastOnline(userId);
        chatService.setOffline(userId);
    }

//    @Override
//    public Integer createChat(List<Integer> members) {
//        return null;
//    }


    @EventListener(ApplicationReadyEvent.class)
    public void doSomethingAfterStartup() {
        System.out.println("Spring just started up");
    }

}
