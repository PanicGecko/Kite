package com.example.kitechatproducer.service;

import dao.ChatMapper;
import exception.kiteException;
import org.apache.dubbo.config.annotation.DubboService;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pojo.Chat;
import pojo.Message;
import pojo.MessageVO_v2;
import pojo.Message_v2;
import repos.MessageRepo;
import service.RpcChatService;
import utils.RedisUtil;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.*;

@DubboService(timeout = 6000)
public class ChatServiceImpl implements RpcChatService {

    @Resource
    private RedisUtil redis;

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Resource
    private ChatMapper chatMapper;

    @Resource
    private MessageRepo messageRepo;

    ZoneId zone1 = ZoneId.of("US/Eastern");

    @Override
    public boolean setOnline(String userId, String serverId) {
        System.out.println("setOnline called");
        return redis.set(userId, serverId);
    }

    @Override
    public void setOffline(int userId) {
        redis.delete(userId + "");
    }

    @Override
    public void receivedMsg(UUID id) {
        Optional<Message_v2> message = messageRepo.findById(id);
        if (!message.isPresent()) {
            return;
        }
        if (message.get().getViewCount() < 2) {
            messageRepo.delete(message.get());
        } else {
            message.get().setViewCount(message.get().getViewCount() - 1);
            messageRepo.save(message.get());
        }
    }

    @Override
    public boolean receivedReturn(List<String> msgIds) throws Exception {
        System.out.println("In receivedReturn");
        List<UUID> theIds = new ArrayList<>();
        for(String i : msgIds) {
            theIds.add(UUID.fromString(i));
        }
        List<Message_v2> messages = new ArrayList<>();
        try {
            messages = messageRepo.findAllById(theIds);
//            messages = messageRepo.findAllFromIds(theIds);
        } catch (Exception e) {
            System.out.println("receivedReturn ERROR: " + e.getMessage());
            return false;
        }

        for (Message_v2 message : messages) {
            if (message.getViewCount() < 2) {
                messageRepo.delete(message);
            } else {
                message.setViewCount(message.getViewCount() - 1);
                messageRepo.save(message);
            }
        }
        return true;
    }

    @Override
    public int checkIndivChat(int userId1, int userId2) {

        int pastChatId = -1;
        try {
            pastChatId = chatMapper.getPastChat(userId1, userId2);
        } catch (NullPointerException e) {
        } catch (Exception e) {
            pastChatId = -2;
        }
        return pastChatId;
    }

    @Override
    public List<Chat> getUpdatedMessages(int userId, Timestamp lastOnline) {
        List<Chat> chatList = chatMapper.getChatByUser(userId);
        System.out.println("chatlist: " + chatList.get(0) + " size: " + chatList.size());
        if(chatList.size() == 0) {
            return null;
        }
        List<Chat> result = new ArrayList<>();
        for (Chat chat: chatList) {

            List<Message_v2> messages = lastOnline == null ? messageRepo.findByChatId(chat.getChatId()) : messageRepo.findByChatIdandTime(chat.getChatId(), lastOnline);


            if(messages.size() == 0) {
                continue;
            }
            //set name of the chat if there are two people and chatname is empty
            if(chat.getMemberNum() == 2) {
                List<String> names = chatMapper.getUsernameOfOtherMember(chat.getChatId(), userId);
                if (names.isEmpty()) {
                    continue;
                }
                chat.setName(names.get(0));
                System.out.println("ChatServiceImpl: getUpdatedMessages othername: " + names.get(0));
            }

            for(Message_v2 old: messages) {
                if (old.getMsgType() == 5) {
                    old.setMessage(chat.getName());
                }
            }
            chat.setMessages(messages);
            result.add(chat);
        }
        System.gc();
        return result;
    }



    @Override
    public void sendMessage(Message message) throws Exception{
        System.out.println("sendMessage called");

//        if(redis.exist(message.getToUser())) {
//            rabbitTemplate.convertAndSend(redis.get(message.getToUser()).toString(), message);
//            System.out.println("sendMessage touser: " + message.getToUser() + " message: " + message.getMessage() + " serverId: " + redis
//                    .get(message.getToUser()));
//        } else {
//            System.out.println("sendMessage user does not exist");
//        }
//        ------------------------------
        try {
            //save to db
            chatMapper.sendMsg(message.getChatId(), message.getFrom(), message.getMessage());

        } catch (Exception e) {
            System.out.println("SendMessage error: " + e.getMessage());
            throw new kiteException("Message failed to save");
        }
        List<Integer> members = chatMapper.getMembers(message.getChatId());
        for (int member: members) {
            if(member == message.getFrom()) {
                continue;
            }
            if (redis.exist(member + "")) {
                message.setToUser(member);
                rabbitTemplate.convertAndSend(redis.get(member + "").toString(), message);
                System.out.println("sendMessage touser: " + member + " message: " + message.getMessage() + " serverId: " + redis
                    .get(member + ""));
            } else {
                System.out.println("Send notification to user: " + member);
            }
        }
    }

    //msgType: 1- text, 2 - voice, 3 - images
    @Override
    public Message_v2 sendMessage_v2(Message_v2 message) throws Exception {
        System.out.println("sendMessage called");

        List<Integer> members = null;



        try {
            members = chatMapper.getMembers(message.getChatId());
            System.out.println("sendMessage_v2 memebers in before: " + message.getDeliveredTime() + " msgType: " + message.getMsgType() + " chatId: " + message.getChatId() + " from: " + message.getFrom() + " viewCount: " + message.getViewCount() + " chatSize: " + message.getChatSize());
//            if (message.getMsgType() != 5) { // 5 is new chat created
//                message.setDeliveredTime(Timestamp.valueOf(LocalDateTime.now(zone1)));
//                message.setViewCount(members.size() - 1);
//                messageRepo.save(message);
//            }
            message.setDeliveredTime(Timestamp.valueOf(LocalDateTime.now(zone1)));
            message.setViewCount(members.size() - 1);
            messageRepo.save(message);

            System.out.println("incoming message date: " + message.getDeliveredTime().toString());
        }catch (Exception e) {
            System.out.println("SendMessage error: " + e.getMessage());
            throw new kiteException("Message failed to save");
        }
        for (int member: members) {
            System.out.println("sendMessage_v2 members: " + member);
            if(member == message.getFrom()) {
                continue;
            }
            message.setToUser(member);
            if (redis.exist(member + "")) {
//                message.setToUser(member);
                rabbitTemplate.convertAndSend(redis.get(member + "").toString(), message);
                System.out.println("sendMessage touser: " + member + " message: " + message.getMessage() + " serverId: " + (String) redis
                        .get(member + ""));
            } else {
                System.out.println("Send notification to user: " + member);
            }
        }
        return message;
    }


}
