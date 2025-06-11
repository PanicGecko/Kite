package com.kite.kiteuserconsumer.controller;

import com.kite.kiteuserconsumer.service.UserService;
import dto.Dto;
import exception.kiteException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import utils.DtoUtil;
import vo.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api")
public class VerController {

    @Autowired
    private UserService userService;

    @PostMapping("/create")
    public Dto uploadNew(@RequestBody @Valid CreateUserVO user, BindingResult br) {
        System.out.println("this is upload new " + user.getEmail());
        if(br.hasErrors()) {
            for(FieldError error : br.getFieldErrors())
                return DtoUtil.failed("401", error.getDefaultMessage());
        }

        try {
            userService.createUser(user);
            return DtoUtil.success("200", "All good", "");
        } catch (kiteException e) {
            System.out.println("VerController: uploadNew kiteException error: " + e);
            return DtoUtil.failed("401", e.getMessage());
        } catch (Exception e) {
            System.out.println("VerController: uploadNew Exception error: " + e);
            return DtoUtil.failed("403", e.getMessage());
        }
    }

    @PostMapping("/newVer")
    public Dto verNew(@RequestBody @Valid VerEmailVO codes, BindingResult br) {
        System.out.println("in newVer");
        if(br.hasErrors()) {
            for(FieldError error : br.getFieldErrors())
                return DtoUtil.failed("401", error.getDefaultMessage());
        }

        try {
            TokenVO token = userService.verNewEmail(codes);
            System.out.println("in newVer : " + token);
            return DtoUtil.success("200", "All good", "{\"token\":\"" + token.getToken() + "\", \"userId\": " + token.getUserId() + "}");
        } catch (kiteException e) {
            return DtoUtil.failed("401", e.getMessage());
        } catch (Exception e) {
            System.out.println(e);
            return DtoUtil.failed("403", "Something went wrong");
        }
    }

    @PostMapping("/findUsername")
    public Dto findUsername(@RequestBody @Valid CheckUsername username, BindingResult br) {
        System.out.println("in findUsername");
        if(br.hasErrors()) {
            for(FieldError error : br.getFieldErrors())
                return DtoUtil.failed("401", error.getDefaultMessage());
        }

        try {
            boolean status = userService.checkUsername(username.getUsername());
            System.out.println("in findUsername : " + status);
            return DtoUtil.success("200", "All good", "{\"status\":" + status + "}");
        } catch (Exception e) {
            System.out.println(e);
            return DtoUtil.failed("403", "Something went wrong");
        }
    }

    @PostMapping("/findEmail")
    public Dto findEmail(@RequestBody @Valid CheckEmail email, BindingResult br) {
        System.out.println("in findEmail");

        try {
            boolean status = userService.checkUsername(email.getEmail());
            System.out.println("in findEmail : " + status);
            return DtoUtil.success("200", "All good", "{\"status\":" + status + "}");
        } catch (Exception e) {
            System.out.println(e);
            return DtoUtil.failed("403", "Something went wrong");
        }
    }

}
