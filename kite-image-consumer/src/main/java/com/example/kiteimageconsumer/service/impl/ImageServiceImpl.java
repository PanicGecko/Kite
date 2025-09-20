package com.example.kiteimageconsumer.service.impl;

import com.example.kiteimageconsumer.model.Image;
import com.example.kiteimageconsumer.pojo.CollageStyleVO;
import com.example.kiteimageconsumer.repo.ImageRepository;
import com.example.kiteimageconsumer.service.ImageService;
import org.apache.dubbo.config.annotation.DubboReference;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import pojo.Message_v2;
import service.RpcChatService;
import service.RpcImageService;
import service.RpcTokenService;
import utils.JsonConverter;
import vo.StoreImageVO;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class ImageServiceImpl implements ImageService {


    @Autowired
    private ImageRepository imageRepository;

    @DubboReference
    private RpcTokenService tokenService;

    @DubboReference
    private RpcChatService chatService;

    @Override
    public String getImage(String id) throws Exception {
        return imageRepository.findById(id).get().getImage();
    }


    public void storeImage(int chatId, int userId, UUID msgId, String[] imgs, String[] names) throws Exception{
        ArrayList<String> fileUrls = new ArrayList<>();
        try {
            for (int i = 0; i < names.length; i++) {
                Image image = new Image();
                image.setChat(chatId);
                image.setFrom(userId);
                image.setImage(imgs[i]);
                image.setId(names[i]);
                image = imageRepository.insert(image);
            }


        } catch (Exception e) {
            System.out.println("ImageServiceImpl: storeImages - something went wrong: " + e.getMessage());
        }
//        if (fileUrls.isEmpty()) {
//            throw new Exception("ImageServiceImpl - storeImage - fileURlS is empty");
//        }
//        for (int i = 0; i < fileUrls.size(); i++) {
//            System.out.println("names: " + images[i].getOriginalFilename() + ", vs: fileUrls: " + fileUrls.get(i) + ", are the same: " + (images[i].getOriginalFilename().equals(fileUrls.get(i))));
//        }

//        CollageStyleVO vo = new CollageStyleVO();
//        vo.setIds(fileUrls);
        Message_v2 msg = new Message_v2();
        msg.setId(msgId);
        msg.setMsgType(3);
        msg.setFrom(userId);
        msg.setChatId(chatId);
        msg.setMessage(String.join(",", names));
        msg = chatService.sendMessage_v2(msg);
    }


///v2
//    public void storeImage(MultipartFile[] images, int chatId, int userId, UUID msgId, String[] names) throws Exception{
//        ArrayList<String> fileUrls = new ArrayList<>();
//        try {
//            for (int i = 0; i < images.length; i++) {
//                Image image = new Image();
//                image.setChat(chatId);
//                image.setFrom(userId);
//                image.setImage(new Binary(BsonBinarySubType.BINARY, images[i].getBytes()));
//                image.setId(images[i].getOriginalFilename());
//                image = imageRepository.insert(image);
//                fileUrls.add(image.getId()); //change this when we can confirm that the names and ids match up
//            }
//
//        } catch (Exception e) {
//            System.out.println("ImageServiceImpl: storeImages - something went wrong: " + e.getMessage());
//        }
//        if (fileUrls.isEmpty()) {
//            throw new Exception("ImageServiceImpl - storeImage - fileURlS is empty");
//        }
//        for (int i = 0; i < fileUrls.size(); i++) {
//            System.out.println("names: " + images[i].getOriginalFilename() + ", vs: fileUrls: " + fileUrls.get(i) + ", are the same: " + (images[i].getOriginalFilename().equals(fileUrls.get(i))));
//        }
//
////        CollageStyleVO vo = new CollageStyleVO();
////        vo.setIds(fileUrls);
//        Message_v2 msg = new Message_v2();
//        msg.setId(msgId);
//        msg.setMsgType(3);
//        msg.setFrom(userId);
//        msg.setChatId(chatId);
//        msg.setMessage(String.join(",", fileUrls));
//        msg = chatService.sendMessage_v2(msg);
//    }

//    @Override v1
//    public void storeImage(MultipartFile[] images, int chatId, int userId, UUID msgId, String[] names) throws Exception{
//
//        List<String> ids = imageService.storeImages(new StoreImageVO(chatId, userId, images, msgId, names));
//        if (ids.size() == 0 || ids == null) {
//            throw new Exception("No files stored");
//        }
//        CollageStyleVO vo = new CollageStyleVO();
//        vo.setIds(ids);
//        Message_v2 msg = new Message_v2();
//        msg.setId(msgId);
//        msg.setMsgType(3);
//        msg.setFrom(userId);
//        msg.setChatId(chatId);
//        msg.setMessage(JsonConverter.toJson(vo));
//        msg = chatService.sendMessage_v2(msg);
//
//    }

    @Override
    public int verifyUser(String token) {
        return tokenService.checkJwt(token);
//        return 1;
    }

    @Override
    public int testRpc() {
        return 7;
    }


}
