package vo;

import java.io.Serializable;
import java.util.List;

public class CreateChatVO implements Serializable {

    private List<Integer> members;

    private String chatName;

    public CreateChatVO() {
    }

    public CreateChatVO(List<Integer> members, String chatName) {
        this.members = members;
        this.chatName = chatName;
    }

    public List<Integer> getMembers() {
        return members;
    }

    public void setMembers(List<Integer> members) {
        this.members = members;
    }

    public String getChatName() {
        return chatName;
    }

    public void setChatName(String chatName) {
        this.chatName = chatName;
    }

    public void addMemeber(Integer id) {
        this.members.add(id);
    }
}
