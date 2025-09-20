package pojo;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class Chat implements Serializable {

    private int chatId;
    private String name;
    private int memberNum;

    private List<Message_v2> messages;

    private Timestamp createDate;

    public Chat() {
    }

    public Chat(int chatId, String name, int memberNum, Timestamp createDate) {
        this.chatId = chatId;
        this.name = name;
        this.memberNum = memberNum;
        this.createDate = createDate;
    }

    public int getChatId() {
        return chatId;
    }

    public void setChatId(int chatId) {
        this.chatId = chatId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getMemberNum() {
        return memberNum;
    }

    public void setMemberNum(int memberNum) {
        this.memberNum = memberNum;
    }

    public List<Message_v2> getMessages() {
        return messages;
    }

    public void setMessages(List<Message_v2> messages) {
        this.messages = messages;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }
}
