package com.example.kiteimageprovider.model;

import org.bson.types.Binary;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.Serializable;
import java.util.Date;

@Document(collection = "voice")
public class Voice implements Serializable {

    @Id
    private String id;

    private int chat;

    private int from;

    @Indexed(name = "createdDateIndex", expireAfterSeconds = 60)
    private Date createdDate;

    private Binary voice;

    public Voice() {
    }

    public Voice(String id, int chat, int from, Date createdDate, Binary voice) {
        this.id = id;
        this.chat = chat;
        this.from = from;
        this.createdDate = createdDate;
        this.voice = voice;
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

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Binary getVoice() {
        return voice;
    }

    public void setVoice(Binary voice) {
        this.voice = voice;
    }
}
