package com.kite.kiteuserconsumer.controller;

import com.kite.kiteuserconsumer.service.UserService;
import dto.Dto;
import exception.kiteException;
import org.apache.dubbo.config.annotation.DubboReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pojo.UserDetails;
import service.RpcTokenService;
import utils.DtoUtil;
import vo.TokenVO;

import javax.annotation.Resource;
import javax.validation.Valid;

@RestController
@RequestMapping("/api")
public class TokenController {

    @Autowired
    private UserService userService;

//    @PostMapping("/test")
//    public String testToken() {
//        System.out.println("in test token");
//        return tokenService.genJwt("k");
//    }

    @PostMapping("/refreshToken")
    public Dto validateToken(@RequestBody TokenVO tokenVO) {
        if(tokenVO.getToken().trim().equals("") || tokenVO.getToken() == null) {
            return DtoUtil.failed("401", "No token");
        }
        try {
            String newToken = userService.refreshToken(tokenVO.getToken());
            tokenVO.setToken(newToken);
//        } catch (kiteException e) {
//            return DtoUtil.failed("401", e.getMessage());
        } catch (Exception e) {
            return DtoUtil.failed("403", e.getMessage());
        }
        return DtoUtil.success("200", "All good", tokenVO);
    }

}
