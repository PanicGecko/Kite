package com.kite.kiteuserprovider.service;

import com.alibaba.fastjson.JSON;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.apache.dubbo.config.annotation.DubboService;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import pojo.User;
import pojo.UserDetails;
import service.RpcTokenService;
import utils.*;
import vo.CreateUserVO;
import vo.EmailVerVO;
import vo.TokenVO;
import vo.VerEmailVO;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@DubboService
public class TokenServiceImpl implements RpcTokenService {

    @Resource
    private RedisUtil redis;

    @Resource
    private TokenManager tokenManager;

    @Autowired
    private RabbitTemplate rabbitTemplate;


    @Override
    public String saveUserToken(String s) throws Exception {
        String code = MD5Util.getRandomNum();
        if(redis.set(code, s, 70)) {
            return code;
        }
        return "";
    }

    @Override
    public boolean saveNewUser(CreateUserVO user) {
        System.out.println("in saveNewUser");
        return redis.set(user.getEmail(), JsonConverter.toJson(user), 70);

    }

    @Override
    public CreateUserVO checkCode(VerEmailVO ver) {
        String corEmail = (String) redis.get(ver.getCode());
        if(corEmail == null) {
            return null;
        }
        return JSON.parseObject((String) redis.get(corEmail), CreateUserVO.class);
    }

    @Override
    public boolean saveCurrUser(User user) {
        return redis.set(user.getEmail(), JsonConverter.toJson(user), 70);
    }

    @Override
    public User checkLoginCode(VerEmailVO verEmailVO) {
        String corEmail = (String) redis.get(verEmailVO.getCode());
        if(corEmail == null) {
            return null;
        }
        return JSON.parseObject((String) redis.get(corEmail), User.class);

    }

    @Override
    public String genJwt(int s) {
        System.out.println("in gen JWT");
        return tokenManager.generateJwtToken(new UserDetails(s));
    }

    @Override
    public void sendEmail(EmailVerVO emailVerVO) {
        System.out.println("TokenServiceIMpl: sendEmail good");
        rabbitTemplate.convertAndSend("EmailVer", JsonConverter.toJson(emailVerVO));
    }

    @Override
    public int checkJwt(String s) {
        int result = -1;
        try {
            result = tokenManager.getIdFromToken(s);
        } catch (Exception e) {
            System.out.println("CheckJWT getting Id from token failed");
        }
        System.out.println("TokenServiceImpl - check JST: " + result);
        return result;
    }

    @Override
    public boolean validateToken(String s) {
        try {
            return tokenManager.isTokenExpired(s);
        } catch (Exception e) {
            System.out.println("TokenServiceImpl: validateToken excetpion: " + e.getMessage());
            return true;
        }

    }

    @Override
    public Integer getId(String s) {
        System.out.println("provider token get Id from token");
        return tokenManager.getIdFromToken(s);
    }

    @Override
    public String refreshToken(String s) {
        int result = -1;
        try {
            result = checkJwt(s);
            if (result < 0) {
                return null;
            }
        } catch (Exception e) {
            System.out.println("TokenServiceIMple RefreshToken error: " + e.getMessage());
            return null;
        }
        return genJwt(result);
    }


}
