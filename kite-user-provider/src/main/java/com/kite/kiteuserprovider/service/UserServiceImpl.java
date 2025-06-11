package com.kite.kiteuserprovider.service;

import dao.ChatMapper;
import dao.UserMapper;
import exception.kiteException;
import org.apache.dubbo.config.annotation.DubboService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import pojo.Chat;
import pojo.User;
import service.RpcUserService;
import utils.MD5Util;
import vo.*;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@DubboService
public class UserServiceImpl implements RpcUserService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private ChatMapper chatMapper;

    ZoneId zone1 = ZoneId.of("US/Eastern");

    @Override
    public User getLogin(LoginUserVO loginUserVO) throws Exception{
        String newPass = MD5Util.getMd5(loginUserVO.getPassword());
        loginUserVO.setPassword(newPass);
        List<User> user;
        user = userMapper.doLogin(loginUserVO);
        if (user.size() < 1)
            throw new kiteException("User does not exist");
        return user.get(0);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Integer insertUser(CreateUserVO createUserVO) throws Exception{
        String newPass = MD5Util.getMd5(createUserVO.getPassword());
        createUserVO.setPassword(newPass);
//        CreateUserVO inserted = userMapper.createUser(createUserVO);
//        if (inserted == null) {
//            throw new kiteException("User could not be created");
//        }
//        System.out.println("insertUser user insert id: " + inserted.getUserId());
//        return inserted.getUserId();
        int end = userMapper.createUser(createUserVO);
        if(end < 1) {
            throw new kiteException("User could not be created");
        }
        int newUser = userMapper.getInsertId();
        System.out.println("insertUser user insert id: " + newUser);
        return newUser;
    }

    @Override
    public boolean checkUsername(String s) {
        return (userMapper.searchUsername(s) > 0);
    }

    @Override
    public boolean checkEmail(String s) {
        return !(userMapper.searchEmail(s) < 1);
    }



    @Override
    @Transactional(rollbackFor = Exception.class)
    public Chat createChat(CreateChatVO vo) throws Exception{
        Chat chat = new Chat();
        chat.setMemberNum(vo.getMembers().size());
        chat.setCreateDate(Timestamp.valueOf(LocalDateTime.now(zone1)));
        chat.setName(vo.getChatName());
        int end = chatMapper.createChat(chat);
        if(end < 1) {
            throw new kiteException("chat could not be created");
        }
        int chatId = chatMapper.getInsertId();
        chatMapper.addMember(vo.getMembers(), chatId);
        chat.setChatId(chatId);
        System.out.println("insertUser user insert id: " + chatId);
        return chat;
    }

    @Override
    public Integer getIdbyUsername(String s) {
        int userId = userMapper.getIdbyUsername(s);
        if (userId < 0) {
            return null;
        }
        return userId;
    }

    @Override
    public List<UserVO> getUserbyInput(SearchVO vo) {
        System.out.println("UserServiceImpl: getUserbyInput userId: " + vo.getUserId());
        return userMapper.getUserbyInput(vo);
    }

    @Override
    public void setLastOnline(int i) {
        userMapper.setOffline(i, Timestamp.valueOf(LocalDateTime.now(zone1)));
    }

    @Override
    public Timestamp getLastOnline(int userId) {
        return userMapper.getLastOnline(userId);
    }

    @Override
    public String getUsernameById(int i) {
        return userMapper.getUsernameById(i);
    }
}
