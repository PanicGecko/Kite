package pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.data.cassandra.core.mapping.*;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;

@Table
public class Message_v2 implements Serializable {

    @PrimaryKey
    @Column
    @CassandraType(type = CassandraType.Name.UUID)
    private UUID id;

    @Column
    private int msgType;

    @Column
    private int from;

    @Column
    private String message;

    @Column
    private int chatId;

    @Column
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSX")
    private Timestamp deliveredTime;

    @Column
    private int toUser;

    @Column
    private int viewCount;

    @Column
    private int chatSize;


    public Message_v2(){}

    public Message_v2(UUID id, int from, String message,int msgType, int chatId, Timestamp deliveredTime, int toUser, int viewCount, int chatSize) {
        this.id = id;
        this.from = from;
        this.message = message;
        this.chatId = chatId;
        this.msgType = msgType;
        this.deliveredTime = deliveredTime;
        this.toUser = toUser;
        this.viewCount = viewCount;
        this.chatSize = chatSize;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
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

    public Timestamp getDeliveredTime() {
        return deliveredTime;
    }

    public void setDeliveredTime(Timestamp deliveredTime) {
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

    public int getMsgType() {
        return msgType;
    }

    public void setMsgType(int msgType) {
        this.msgType = msgType;
    }

    public int getChatSize() {
        return chatSize;
    }

    public void setChatSize(int chatSize) {
        this.chatSize = chatSize;
    }
}
