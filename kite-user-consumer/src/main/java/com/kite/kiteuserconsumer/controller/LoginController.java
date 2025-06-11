package com.kite.kiteuserconsumer.controller;

import com.kite.kiteuserconsumer.service.UserService;
import dto.Dto;
import exception.kiteException;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import utils.DtoUtil;
import vo.LoginUserVO;
import vo.TokenVO;
import vo.VerEmailVO;

import javax.validation.Valid;

@RestController
@RequestMapping("api")
public class LoginController {

     @Autowired
     private UserService userService;

     @PostMapping("/getUsername")
     public Dto getUsername(int userId) {
          System.out.println("getUsername method");
          if(userId < 1) {
               return DtoUtil.failed("401", "not authorized");
          }

          try {
               String username = userService.getUsernameById(userId);
               if(username.equals("")) {
                    return DtoUtil.failed("405", "User not exists");
               }
               return DtoUtil.success("200", "All Good", username);
          } catch (Exception e) {
               System.out.println("/getUsername error: " + e.getMessage());
               return DtoUtil.failed("500", "Something went wrong");
          }

     }

     @PostMapping("/dologin")
     public Dto doLogin(@RequestBody @Valid LoginUserVO user, BindingResult br) {
          System.out.println("In /dologin");
          if(br.hasErrors()) {
               for(FieldError error : br.getFieldErrors())
                    return DtoUtil.failed("401", error.getDefaultMessage());
          }

          try {
               String email = userService.doLogin(user);

               return DtoUtil.success("200", "", "{\"email\":\"" + email + "\"}");
          } catch (kiteException e) {
               System.out.println("dologin kiteException: " + e.getMessage());
               return DtoUtil.failed("401", e.getMessage());
          } catch (Exception e) {
               System.out.println(e.getMessage());
               return DtoUtil.failed("403", "Something went wrong");
          }

     }

     @PostMapping("/verLogin")
     public Dto verLogin(@RequestBody @Valid VerEmailVO codes, BindingResult br) {
          if(br.hasErrors()) {
               for(FieldError error : br.getFieldErrors())
                    return DtoUtil.failed("401", error.getDefaultMessage());
          }

          try {
               TokenVO token = userService.verLogin(codes);
               System.out.println("verLogin teken repsone: " + JSONObject.escape("{\"token\":\"" + token.getToken() + "\", \"userId\":" + token.getUserId() + "}"));
               return DtoUtil.success("200", "","{\"token\":\"" + token.getToken() + "\", \"userId\":" + token.getUserId() + "}");
          } catch (kiteException e) {
               return DtoUtil.failed("401", e.getMessage());
          } catch (Exception e) {
               System.out.println(e.getMessage());
               return DtoUtil.failed("403", "Something went wrong");
          }
     }

     @PostMapping("/tokenLogin")
     public Dto tokenLogin(String token) {
          if (token.equals("")) {
               return DtoUtil.failed("405", "No token");
          }
          try {
               String newToken = userService.refreshToken(token);
               return DtoUtil.success("200", "New Token", token);
//          } catch (kiteException e) {
//               return DtoUtil.failed("401", e.getMessage());
          } catch (Exception e) {
               return DtoUtil.failed("501", "Something went wront");
          }
     }

}
