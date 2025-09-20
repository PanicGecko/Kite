package pojo;

import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

public class MessageVO_v2 implements Serializable {

    private UUID id;

    private int msgType;

    private int from;

    private String message;

    private int chatId;

    private Date deliveredTime;

    public MessageVO_v2() {
    }

    public MessageVO_v2(UUID id, int msgType, int from, String message, int chatId, Date deliveredTime) {
        this.id = id;
        this.msgType = msgType;
        this.from = from;
        this.message = message;
        this.chatId = chatId;
        this.deliveredTime = deliveredTime;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public int getMsgType() {
        return msgType;
    }

    public void setMsgType(int msgType) {
        this.msgType = msgType;
    }

    public int getFrom() {
        return from;
    }

    public void setFrom(int from) {
        this.from = from;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getChatId() {
        return chatId;
    }

    public void setChatId(int chatId) {
        this.chatId = chatId;
    }

    public Date getDeliveredTime() {
        return deliveredTime;
    }

    public void setDeliveredTime(Date deliveredTime) {
        this.deliveredTime = deliveredTime;
    }
}
