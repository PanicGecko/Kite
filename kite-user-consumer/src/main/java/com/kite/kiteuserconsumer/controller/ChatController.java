package com.kite.kiteuserconsumer.controller;

import com.kite.kiteuserconsumer.service.ChatService;
import com.kite.kiteuserconsumer.service.UserService;
import dto.Dto;
import dto.DtoMsg;
import org.apache.dubbo.common.utils.JsonUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import pojo.Chat;
import pojo.MessageVO_v2;
import pojo.Message_v2;
import utils.DtoUtil;
import utils.JsonConverter;
import vo.CreateChatVO;
import vo.SearchResultVO;
import vo.SearchVO;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private UserService userService;

    @GetMapping("/testPast")
    public Dto testPastChat(@RequestParam(name = "user1") int userId1, @RequestParam(name = "user2") int userId2) {
        System.out.println("in testPastChat: user1: " + userId1 + ", user2: " + userId2);
        System.out.println("in testPastChat: resutl: " + chatService.testPastChat(userId1, userId2));
        return DtoUtil.success("300", "got it", null);
    }

    @PostMapping("/create")
    public DtoMsg createChat(@RequestBody CreateChatVO members, @RequestHeader(value = "X-Authentication") String token) {
        System.out.println("In creatChat input: " + members.toString());
        try {
//            if(!chatService.validateToken(token)) {
//                return DtoUtil.failed("501", "Unaurotized");7
//            }
            Message_v2 newChat = chatService.createChat(members, token);
            return DtoUtil.sending("200", 5, "chat created", newChat);
        } catch (Exception e) {
            System.out.println("ChatController Error: " + e.getMessage());
            return DtoUtil.sending("400", 5, "not good", null);
        }

    }

    @PostMapping("/search")
    public Dto searchUser(@RequestBody SearchVO input, @RequestHeader(value = "X-Authentication") String token) {
        System.out.println("In searchUser input: " + input.getSearch());
        try {
            int userId = userService.getUserFromToken(token);
            if (userId == -1) {
                return DtoUtil.failed("501", "Unaurotized");
            }
            input.setUserId(userId);
//            if(!chatService.validateToken(token)) {
//                return DtoUtil.failed("501", "Unaurotized");
//            }
            SearchResultVO result = new SearchResultVO(chatService.searchUsers(input));
            return DtoUtil.success("200", "Good", JsonConverter.toJson(result));
        } catch (Exception e) {
            System.out.println("ChatController Error: " + e.getMessage());
            return DtoUtil.failed("401", "Something went wrong");
        }
    }

    @PostMapping("/latest")
    public Dto getLatestChats(@RequestHeader(value = "X-Authentication") String token, HttpServletResponse response) {
        System.out.println("In getChats input: ");

        if(chatService.validateToken(token)) {
            System.out.println("ChatController: getLatestChats validateToken failed");
            return DtoUtil.failed("501", "Unaurotized");
        }
        String newToken = userService.refreshToken(token);
        System.out.println("ChatController: getLatestChats new Token: " + newToken);
        if(newToken == null) {
            System.out.println("ChatController: getLatestChats new Token: failed");
            return DtoUtil.failed("501", "Unaurotized");
        }
        response.setHeader("X-Authentication", newToken);
        try {
            List<Chat> updateMsgs = chatService.getLastMessage(token);
            for (Chat i : updateMsgs) {
                System.out.println("getLatestChats chat value: " + i.getChatId());
                for (Message_v2 y : i.getMessages()) {
                    System.out.println("getLatestChats value: " + y.getMsgType());
                }

            }

            return DtoUtil.success("200", "all good", updateMsgs);
        } catch (Exception e) {
            System.out.println("ChatController Error: " + e.getMessage());
            return DtoUtil.failed("401", "Something went wrong");
        }
    }

    @PostMapping("/returnLatest")
    public Dto returnLatestChats(@RequestBody List<String> msgIds, @RequestHeader(value = "X-Authentication") String token) {
        System.out.println("in returnLastest: " + msgIds.toString());
        try {
            Boolean recieved = chatService.returnLastMessage(msgIds);
            if (recieved) {
                return DtoUtil.success("200", "good", null);
            } else {
                return DtoUtil.failed("400", "not good");
            }
        } catch (Exception e) {
            System.out.println("returnLatest error: " + e.getMessage());
            return DtoUtil.failed("400", "not good at all");
        }
    }

}
