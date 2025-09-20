package com.example.kiteimageconsumer.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

public interface VoiceService {

    public byte[] getVoice(String id) throws Exception;

    public void storeVoice(MultipartFile voice, int chatId, int userId, UUID msgId) throws Exception;

    public int verifyUser(String token);


}
