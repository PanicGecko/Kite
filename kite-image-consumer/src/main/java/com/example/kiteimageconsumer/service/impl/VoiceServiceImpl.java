package com.example.kiteimageconsumer.service.impl;

import com.example.kiteimageconsumer.repo.ImageRepository;
import com.example.kiteimageconsumer.repo.VoiceRepository;
import com.example.kiteimageconsumer.service.VoiceService;
import org.apache.dubbo.config.annotation.DubboReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import pojo.Message_v2;
import service.RpcChatService;
import service.RpcTokenService;
import service.RpcVoiceService;
import utils.JsonConverter;
import vo.StoreVoiceVO;

import java.util.UUID;

@Service
public class VoiceServiceImpl implements VoiceService {

    @Autowired
    private VoiceRepository voiceRepository;

    @DubboReference
    private RpcTokenService tokenService;

    @DubboReference
    private RpcChatService chatService;

    @Override
    public byte[] getVoice(String id) throws Exception {
        return voiceRepository.findById(id).get().getVoice().getData();
    }

    @Override
    public void storeVoice(MultipartFile voice, int chatId, int userId, UUID msgId) throws Exception {
//        if(voice.isEmpty()) {
//            throw new Exception("Empty Voice File");
//        }
//        String ids = voiceService.storeVoice(new StoreVoiceVO(chatId, userId, voice, msgId));
//        if (ids == null || ids.equals("")) {
//            throw new Exception("No files stored");
//        }
//        Message_v2 msg = new Message_v2();
//        msg.setId(msgId);
//        msg.setMsgType(2);
//        msg.setFrom(userId);
//        msg.setChatId(chatId);
//        msg.setMessage(ids);
//        msg = chatService.sendMessage_v2(msg);

    }

    @Override
    public int verifyUser(String token) {
        return tokenService.checkJwt(token);
//        return 1;
    }
}
