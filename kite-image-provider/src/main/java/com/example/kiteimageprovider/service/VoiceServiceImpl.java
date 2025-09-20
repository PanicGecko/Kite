package com.example.kiteimageprovider.service;

import com.example.kiteimageprovider.model.Voice;
import com.example.kiteimageprovider.repo.VoiceRepository;
import org.apache.dubbo.config.annotation.DubboService;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.beans.factory.annotation.Autowired;
import service.RpcVoiceService;
import vo.StoreImageVO;
import vo.StoreVoiceVO;

import java.util.UUID;

//@DubboService(version = "1.0.0", interfaceClass = RpcVoiceService.class)
@DubboService
public class VoiceServiceImpl implements RpcVoiceService {

    @Autowired
    private VoiceRepository voiceRepository;


    @Override
    public String storeVoice(StoreVoiceVO vo) {
        Voice voice = new Voice();
        try {
            voice.setChat(vo.getChatId());
            voice.setFrom(vo.getFrom());
            voice.setVoice(new Binary(BsonBinarySubType.BINARY, vo.getVoice().getBytes()));
            voice.setId(UUID.randomUUID().toString());
            voice = voiceRepository.insert(voice);
        } catch (Exception e) {
            System.out.println("VoiceServiceImpl: storeVoice - something went wrong: " + e.getMessage());
        }
        if (voice.getId() == null || voice.getId().equals(""))
            return null;
        return voice.getId();
    }

    @Override
    public byte[] getVoice(String s) {
        return voiceRepository.findById(s).get().getVoice().getData();
    }
}
