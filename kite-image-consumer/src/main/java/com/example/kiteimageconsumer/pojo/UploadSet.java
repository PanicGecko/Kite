package com.example.kiteimageconsumer.pojo;

import org.springframework.web.multipart.MultipartFile;

import java.io.Serializable;
import java.util.UUID;

public class UploadSet implements Serializable {

//    struct DtoImage2: Codable {
//        let msgId: UUID
//        let chatId: String
//        let images: [String]
//        let names: [String]
//    }


    private UUID msgId;

    private String chatId;

    private String[] images;

    private String[] names;

    public UploadSet() {
    }

    public UploadSet(UUID msgId, String chatId, String[] images, String[] names) {
        this.msgId = msgId;
        this.chatId = chatId;
        this.images = images;
        this.names = names;
    }

    public UUID getMsgId() {
        return msgId;
    }

    public void setMsgId(UUID msgId) {
        this.msgId = msgId;
    }

    public String getChatId() {
        return chatId;
    }

    public void setChatId(String chatId) {
        this.chatId = chatId;
    }

    public String[] getImages() {
        return images;
    }

    public void setImages(String[] images) {
        this.images = images;
    }

    public String[] getNames() {
        return names;
    }

    public void setNames(String[] names) {
        this.names = names;
    }
}
