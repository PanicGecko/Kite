package com.kite.kiteuserconsumer.service;

import vo.CreateUserVO;
import vo.LoginUserVO;
import vo.TokenVO;
import vo.VerEmailVO;

public interface UserService {

    public String doLogin(LoginUserVO user) throws Exception;

    public boolean checkUsername(String username);

    public boolean checkEmail(String email);

    public void createUser(CreateUserVO user) throws Exception;

    public TokenVO verNewEmail(VerEmailVO ver) throws Exception;

    public TokenVO verLogin(VerEmailVO ver) throws Exception;

    public String refreshToken(String token);

    public String getUsernameById(int userId) throws Exception;

    public int getUserFromToken(String token);

}
