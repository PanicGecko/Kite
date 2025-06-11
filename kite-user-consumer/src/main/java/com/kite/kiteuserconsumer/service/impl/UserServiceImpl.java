package com.kite.kiteuserconsumer.service.impl;

import com.kite.kiteuserconsumer.service.UserService;
import exception.kiteException;
import org.apache.dubbo.config.annotation.DubboReference;
import org.springframework.stereotype.Service;
import pojo.User;
import service.RpcTokenService;
import service.RpcUserService;
import vo.*;


@Service
public class UserServiceImpl implements UserService {

    @DubboReference
    private RpcUserService userService;

    @DubboReference
    private RpcTokenService tokenService;

    @Override
    public String doLogin(LoginUserVO user) throws Exception{
        User currUser = null;
        try {
            currUser = userService.getLogin(user);
        } catch (Exception e) {
            System.out.println("doLogin exc: " + e.getMessage());
        }

        String code = tokenService.saveUserToken(currUser.getEmail());
        System.out.println("doLogin Code: " + code);
        if(code.equals("") || !tokenService.saveCurrUser(currUser)) {
            throw new kiteException("Something went wrong");
        }
        tokenService.sendEmail(new EmailVerVO(currUser.getEmail(), code));
        return currUser.getEmail();
    }

    @Override
    public TokenVO verLogin(VerEmailVO ver) throws Exception {
        User logUser = tokenService.checkLoginCode(ver);
        if(logUser == null) {
            throw new kiteException("Code Expired");
        }

        return new TokenVO(tokenService.genJwt(logUser.getUserId()), logUser.getUserId());
    }

    @Override
    public boolean checkUsername(String username) {
        return userService.checkUsername(username);
    }

    @Override
    public boolean checkEmail(String email) {
        return userService.checkEmail(email);
    }

    @Override
    public void createUser(CreateUserVO user) throws Exception {
//        if(userService.checkEmail(user.getEmail()) || userService.checkUsername(user.getUsername())) {
//            throw new kiteException("Already exists");
//        }
        if(userService.checkEmail(user.getEmail())) {
            System.out.println("UserServiceImpl: createUser email already exists");
            throw new kiteException("email already exists");
        }
        if(userService.checkUsername(user.getUsername())) {
            System.out.println("UserServiceImpl: createUser username already exists");
            throw new kiteException("username already exists");
        }
        String code = tokenService.saveUserToken(user.getEmail());
        System.out.println("UserServiceImpl: createUser code: " + code);
        if(!tokenService.saveNewUser(user) || code.equals("")) {
            System.out.println("UserServiceImpl: createUser somethihng went wrong with redis");
            throw new Exception("Something went wrong with redis");
        }
        System.out.println("UserServiceImpl: createUser send email");
        tokenService.sendEmail(new EmailVerVO(user.getEmail(), code));
    }

    @Override
    public TokenVO verNewEmail(VerEmailVO ver) throws Exception{
        CreateUserVO verUser = tokenService.checkCode(ver);
        if(verUser == null) {
            throw new kiteException("Code Expired");
        }
        int userid = userService.insertUser(verUser);
        return new TokenVO(tokenService.genJwt(userid), userid);
    }

    @Override
    public String refreshToken(String token){
        return tokenService.refreshToken(token);
    }

    @Override
    public String getUsernameById(int userId) throws Exception {
        return userService.getUsernameById(userId);
    }

    @Override
    public int getUserFromToken(String token) {
        return tokenService.checkJwt(token);
    }


}
