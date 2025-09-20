package com.example.kiteimageconsumer.controller;


import com.example.kiteimageconsumer.service.VoiceService;
import com.example.kiteimageconsumer.vo.deliveredVO;
import dto.Dto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import utils.DtoUtil;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.UUID;

@Controller
@RequestMapping("voice")
public class VoiceController {

    @Autowired
    private VoiceService voiceService;

    ZoneId zone1 = ZoneId.of("US/Eastern");

    @GetMapping("/getVoice/{id}")
    public Dto getVoice(@PathVariable String id) {

        System.out.println("VoiceController - getVoice - start");

        if (id.equals("")) {
            return DtoUtil.failed("401", "Empty ID");
        }
        byte[] voiceData = null;
        try {
            voiceData = voiceService.getVoice(id);
        } catch (Exception e) {
            return DtoUtil.failed("405", "Voice is wrong");
        }
        if (voiceData == null) {
            return DtoUtil.failed("405", "Voice does not exists");
        }
        return DtoUtil.success("201", "all good", voiceData);
    }


    @PostMapping(value = "/upload", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    @ResponseBody
    public Dto uploadVoice(@RequestHeader(value = "X-Authentication") String token, @RequestParam("msgId") UUID msgId, @RequestParam("chatId") String chat, @RequestParam("images") MultipartFile file) {

        System.out.println("VoiceController - upload - start");

        System.out.println("uploadImages: chatId: " + chat);
//        for (MultipartFile i : file) {
//            System.out.println("uploadImages: filesize: "+ i.getContentType());
//            System.out.println("uploadImages: filesize: "+ i.getSize());
//
//        }

        if (msgId.toString().equals("") || chat.trim().equals("")) {
            return DtoUtil.failed("501", "Params are not good");
        }
        int userId = -1;
        int chatId = -1;

        try {
            userId = voiceService.verifyUser(token);
            chatId = Integer.parseInt(chat);
        } catch (Exception e) {
            e.printStackTrace();
            return DtoUtil.failed("502", "user or chat is not good");
        }
        if (userId == -1 || chatId == -1) {
            return DtoUtil.failed("502", "user or chat does not exists");
        }

        try {
            voiceService.storeVoice(file, chatId, userId, msgId);
        } catch (Exception e) {
            e.printStackTrace();
            DtoUtil.failed("503", "something went wrong");
        }
        return DtoUtil.success("200", "All good", new deliveredVO(Timestamp.valueOf(LocalDateTime.now(zone1))));

    }

}
