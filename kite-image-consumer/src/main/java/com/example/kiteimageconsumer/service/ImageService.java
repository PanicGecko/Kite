package com.example.kiteimageconsumer.service;

import com.example.kiteimageconsumer.pojo.CollageStyleVO;
import org.springframework.web.multipart.MultipartFile;
import pojo.Message_v2;

import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

public interface ImageService {

    public String getImage(String id) throws Exception;

    public void storeImage(int chatId, int userId, UUID msgId, String[] imgs, String[] names) throws Exception;

    public int verifyUser(String token);

    public int testRpc();

}
