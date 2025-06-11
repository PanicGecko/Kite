package com.kite.kiteuserconsumer.service.impl;

import com.kite.kiteuserconsumer.service.ChatService;
import exception.kiteException;
import org.apache.dubbo.config.annotation.DubboReference;
import org.springframework.stereotype.Service;
import pojo.Chat;
import pojo.Message_v2;
import service.RpcChatService;
import service.RpcTokenService;
import service.RpcUserService;
import vo.CreateChatVO;
import vo.SearchVO;
import vo.UserVO;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class ChatServiceImpl implements ChatService {

    @DubboReference
    private RpcUserService userService;

    @DubboReference
    private RpcTokenService tokenService;

    @DubboReference
    private RpcChatService chatService;

    @Override
    public Message_v2 createChat(CreateChatVO vo, String token) throws Exception{
        int userId = tokenService.getId(token);
//        newChat.members.add(userId);
        vo.addMemeber(userId);


        if (vo.getMembers().size() == 2) {
            vo.setChatName(userService.getUsernameById(userId));
        }
        Chat chat = userService.createChat(vo);
        if (chat.getChatId() != -1) {
            Message_v2 newChat = new Message_v2();
            newChat.setId(UUID.randomUUID());
            newChat.setFrom(userId);
            newChat.setViewCount(vo.getMembers().size());
            newChat.setChatId(chat.getChatId());
            newChat.setMessage(vo.getChatName());
            newChat.setMsgType(5);
            newChat.setDeliveredTime(chat.getCreateDate());
            newChat.setChatSize(vo.getMembers().size());
            System.out.println("createChat chatSize: " + newChat.getChatSize());
            chatService.sendMessage_v2(newChat);
            return newChat;
        }
        return null;
    }

    @Override
    public boolean validateToken(String token) {
        return tokenService.validateToken(token);
    }

    @Override
    public List<UserVO> searchUsers(SearchVO vo) {
        return userService.getUserbyInput(vo);
    }

    @Override
    public List<Chat> getLastMessage(String token) throws Exception {
        int userId = tokenService.getId(token);
        Timestamp timestamp = userService.getLastOnline(userId);
        return chatService.getUpdatedMessages(userId, timestamp);
    }

    @Override
    public boolean returnLastMessage(List<String> msgIds) throws Exception {
        return chatService.receivedReturn(msgIds);
    }

    @Override
    public int testPastChat(int userId1, int userId2) {
        return chatService.checkIndivChat(userId1, userId2);
    }


}
