package com.example.kiteimageconsumer.controller;

import com.example.kiteimageconsumer.pojo.DtoImage;
import com.example.kiteimageconsumer.pojo.UploadSet;
import com.example.kiteimageconsumer.service.ImageService;
import com.example.kiteimageconsumer.vo.deliveredVO;
import dto.Dto;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import pojo.Message_v2;
import utils.DtoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.UUID;

@Controller
@RequestMapping("image")
public class ImageController {

    @Autowired
    private ImageService imageService;

    ZoneId zone1 = ZoneId.of("US/Eastern");

    @GetMapping("/gettest")
    public Dto getImage() {
        System.out.println("lskdjfsljfsljfdskl" + imageService.verifyUser("lsdkjf"));
        return DtoUtil.success("yo", "to", null);
    }

    @GetMapping("/getImage/{id}")
    @ResponseBody
    public Dto getImage(@PathVariable String id) {

        System.out.println("ImageController - getImage - start");

        if (id.equals("")) {
            return DtoUtil.failed("401", "Empty ID");
        }
        String imageData = null;
        try {
            imageData = imageService.getImage(id);
        } catch (Exception e) {
            return DtoUtil.failed("405", "Image is wrong");
        }
        if (imageData == null) {
            System.out.println("ImageController - getImage - imageData is null");
            return DtoUtil.failed("405", "Image does not exists");
        }

        System.out.println("ImageController - getImage - imageData is: good");
        return DtoUtil.success("201", "all good", imageData);
    }

    @PostMapping(value = "/upload")
    @ResponseBody
    public Dto uploadImages(@RequestBody UploadSet pic, @RequestHeader(value = "X-Authentication") String token) {

        System.out.println("uploadImages: chatId: ");
//        String[] arr = new String[file.length];
//        for (int i = 0; i < file.length; i++) {
//            System.out.println("uploadImages: filesize: "+ file[i].getContentType());
//            System.out.println("uploadImages: filesize: "+ file[i].getSize());
//            System.out.println("uploadImages: filename: "+ file[i].getOriginalFilename());
//            arr[i] = file[i].getOriginalFilename();
//        }

//        if (file.length < 1 || msgId.toString().equals("") || chat.trim().equals("")) {
//            return DtoUtil.failed("501", "Params are not good");
//        }
//        String[] arr = names.trim().split(",");
//        if (arr.length != file.length) {
//            return DtoUtil.failed("501", "Params are not good images don't add up??????");
//        }

        if (pic.getNames().length == 0 || pic.getImages().length == 0 || pic.getImages().length != pic.getNames().length) {
            return DtoUtil.failed("501", "Params are not good");
        }

        int userId = -1;
        int chatId = -1;

        try {
            userId = imageService.verifyUser(token);
            chatId = Integer.parseInt(pic.getChatId());
        } catch (Exception e) {
            e.printStackTrace();
            return DtoUtil.failed("502", "user or chat is not good");
        }
        if (userId == -1 || chatId == -1) {
            return DtoUtil.failed("502", "user or chat does not exists");
        }

        try {
            imageService.storeImage(chatId, userId, pic.getMsgId(), pic.getImages(), pic.getNames());
        } catch (Exception e) {
            e.printStackTrace();
            DtoUtil.failed("503", "something went wrong");
        }
        return DtoUtil.success("200", "All good", new deliveredVO(Timestamp.valueOf(LocalDateTime.now(zone1))));

    }

//    @PostMapping("/upload")
//    public Dto uploadImages(@RequestParam("files") MultipartFile[] images, @RequestHeader(value = "X-Authentication") String token, @RequestHeader(value = "X-ChatId") String chat) {
//        int userId = -1;
//        int chatId = -1;
//        try {
//            userId = imageService.verifyUser(token);
//            chatId = Integer.parseInt(chat);
//        } catch (Exception e) {
//            return DtoUtil.failed("501", "Not authorized");
//        }
//        if (userId == -1 || chatId == -1) {
//            System.out.println("ImageController: uploadImage - userId: " + userId + " , chatId: " + chatId);
//            return DtoUtil.failed("501", "Not authorized, one doesnt exist");
//        }
//        Message_v2 flag = null;
//        try {
//            flag = imageService.storeImage(images, chatId, userId);
//        } catch (Exception e) {
//            System.out.println("ImageController: uploadImage storing errormsg: " + e.getMessage() + "------");
//            e.printStackTrace();
//        }
//        if (flag == null) {
//            return DtoUtil.failed("301", "Something went wrong");
//        }
//        return DtoUtil.success("201", "good", flag);
//    }

}
