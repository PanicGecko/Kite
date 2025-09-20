package com.example.kiteimageconsumer.model;

import org.bson.types.Binary;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.Serializable;
import java.time.Instant;
import java.util.Date;

@Document(collection = "image")
public class Image implements Serializable {

    @Id
    private String id;

    private int chat;

    private int from;

    @Indexed(name = "createdDateIndex", expireAfterSeconds = 60)
    private Date createdDate;

    private String image;

    public Image() {
    }

    public Image(String id, int chat, int from, String image) {
        this.id = id;
        this.chat = chat;
        this.from = from;
        this.image = image;
        this.createdDate = Date.from(Instant.now());
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getChat() {
        return chat;
    }

    public void setChat(int chat) {
        this.chat = chat;
    }

    public int getFrom() {
        return from;
    }

    public void setFrom(int from) {
        this.from = from;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
