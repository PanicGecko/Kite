package vo;

import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

public class MessageVO implements Serializable {

    private int type;

    private UUID id;

    private int from;
    private String message;
    private int chatId;
    private Date deliveredTime;
    private int toUser;
    private int viewCount;

    public MessageVO() {}

    public MessageVO(int type,UUID id, int from, String message, int chatId, Date deliveredTime, int toUser, int viewCount) {
        this.type = type;
        this.id = id;
        this.from = from;
        this.message = message;
        this.chatId = chatId;
        this.deliveredTime = deliveredTime;
        this.toUser = toUser;
        this.viewCount = viewCount;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
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

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }
}
