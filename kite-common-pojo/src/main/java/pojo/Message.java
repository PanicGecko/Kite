package pojo;

import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

public class Message implements Serializable {

    private int from;
    private String message;

    private int chatId;

    private Date deliveredTime;

    private int toUser;

    public Message(int from, String message, int chatId, Date deliveredTime) {
        this.from = from;
        this.message = message;
        this.chatId = chatId;
        this.deliveredTime = deliveredTime;
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

    public int getToUser() {
        return toUser;
    }

    public void setToUser(int toUser) {
        this.toUser = toUser;
    }
}
