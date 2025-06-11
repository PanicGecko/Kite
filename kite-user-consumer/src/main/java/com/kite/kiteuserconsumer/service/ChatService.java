package com.kite.kiteuserconsumer.service;

import pojo.Chat;
import pojo.Message_v2;
import vo.CreateChatVO;
import vo.SearchVO;
import vo.UserVO;

import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface ChatService {


    public Message_v2 createChat(CreateChatVO vo, String token) throws Exception;

    public boolean validateToken(String token);

    public List<UserVO> searchUsers(SearchVO vo);

    public List<Chat> getLastMessage(String token) throws Exception;

    public boolean returnLastMessage(List<String> msgIds) throws Exception;

    public int testPastChat(int userId1, int userId2);

}
