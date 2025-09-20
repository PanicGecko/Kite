package dao;

import org.apache.ibatis.annotations.Param;
import pojo.Chat;

import java.util.List;

public interface ChatMapper {



    public void sendMsg(int chatId, int from, String msg);

    public Integer createChat(Chat chat);

    public Integer getInsertId();

    public void addMember(@Param("list") List<Integer> members,@Param("chatId") int chatId);

    public List<Integer> getMembers(int chatId);

    public List<Chat> getChatByUser(int id);

    public List<String> getUsernameOfOtherMember(int chatId, int userId);

    public Integer getPastChat(int userId1, int userId2);

}
