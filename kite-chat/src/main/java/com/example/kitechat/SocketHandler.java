package com.example.kitechat;

import com.example.kitechat.pojo.SessionSet;
import com.example.kitechat.service.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import dto.Dto;
import dto.DtoMsg;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;
import pojo.Message;
import pojo.Message_v2;
import utils.DtoUtil;
import utils.JsonConverter;
import vo.MessageVO;

import javax.annotation.Resource;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class SocketHandler extends TextWebSocketHandler {

    @Resource
    private MessageService messageService;

    public static Map<Integer, WebSocketSession> sessions = new ConcurrentHashMap<>();
    public static Map<String, Integer> sessionMap = new ConcurrentHashMap<>();

    ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        super.handleTextMessage(session, message);
        System.out.println("Message from user: " + message.getPayload());
        System.out.println("User name: " + session.getHandshakeHeaders());
//        Message newMessage = new Gson().fromJson(message.getPayload(), Message.class);
//        Message_v2 newMessage = new Gson().fromJson(message.getPayload(), Message_v2.class);
        DtoMsg incoming = new Gson().fromJson(message.getPayload(), DtoMsg.class);
        int currentUser = -1;
        try {
            currentUser = messageService.verifyUser(session.getHandshakeHeaders().get("X-Authentication").get(0));
        } catch (Exception e) {
            System.out.println("error with authent: " + e.getMessage());
        }
        System.out.println("Handletextmessage currentUser: " + currentUser);
        if (currentUser == -1){
            System.out.println("handleTextMessage no authorization");
            return;
        }
        String result = "";
        switch (incoming.getType()) {
            //incoming new message
            case 0:

                Message_v2 incomingMsg = incoming.getMessage_v2();
                System.out.println("");

                incomingMsg.setFrom(currentUser);
                incomingMsg = messageService.sendMessage_v2(incomingMsg);
                if (incomingMsg != null) {
                    incomingMsg.setMsgType(0);
//                    System.out.println("Messahehandler incomingMsg date: " + message);

                    result = mapper.writeValueAsString(DtoUtil.sending("200", 1, "Message delivered", incomingMsg));
                    System.out.println("result: " + result);
                } else {
                    System.out.println("Something wrong with sending message");
                    result = JsonConverter.toJson(DtoUtil.sending("400", -1, "Message Failed to be Delivered", null));
                }
                session.sendMessage(new TextMessage(result));

                break;
            case 1: //received message
                Message_v2 msg = (Message_v2) incoming.getMessage_v2();
                System.out.println("SocketHandler: handleTextMessage received message");
                messageService.receivedMsg(msg.getId());
                return;
            default:
                System.out.println("handleTextMessage: Something went wrong ");
        }


    }


    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
//        sessions.put(session.getId(), session);
//        System.out.println("User just connected");
//        messageService.setOnline(session.getId(), "server1");
        System.out.println("Client Connected");
        System.out.println("headers: " + session.getHandshakeHeaders());
        try {
            String token = session.getHandshakeHeaders().get("X-Authentication").get(0);
            int userId = messageService.verifyUser(token);
            if (userId == -1) {
                session.close(new CloseStatus(-1));
                return;
            }
            sessions.put(userId, session);
            sessionMap.put(session.getId(), userId);
            messageService.setOnline(userId + "", "server1");
        } catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            session.close();
        }


    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        super.afterConnectionClosed(session, status);
//        System.out.println("Clossed session method session auth: " + session.getHandshakeHeaders().get("X-Authenication").get(0));
        System.out.println("Session closed");
        if (status.getCode() == -1) {
            System.out.println("SocketHandler: afterConnectionClosed status is -1: " + status.getCode());
            return;
        }
        int userId = sessionMap.get(session.getId());
        sessions.remove(sessionMap.get(session.getId()));
        messageService.userDisconnect(userId);
        sessionMap.remove(session.getId());
    }

    @RabbitListener(queues = {"${queue.name}"})
    public void receive(@Payload Message_v2 message) throws IOException {
//        System.out.println("Message from rabbit: " + message.getMessage());
//        System.out.println("Sessions: from other: " + sessions.toString());

        //0 - text message
//        String result = JsonConverter.toJson(DtoUtil.success("200", "msg", message));


        //id, chatId, message, type, deliverdTime, from
        //String newResult = "{\"id\":"+message.getId()+", \"chatId\":"+ message.getChatId() +", \"message\":"+ message.getMessage() +", \"type\":" + message.getMsgType() + ", \"deliveredTime\": "+ message.getDeliveredTime()+", \"from\": "+message.getFrom()+"}";


        if(sessions.get(message.getToUser()) == null) {
            return;
        }
        DtoMsg result = DtoUtil.sending("200", 0, "all good", message);
        if (message.getMsgType() == 5) {
            result.setType(5);
        }

        sessions.get(message.getToUser()).sendMessage(new TextMessage(mapper.writeValueAsString(result)));

    }

}
