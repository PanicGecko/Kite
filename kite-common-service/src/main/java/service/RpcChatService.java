package service;

import pojo.Chat;
import pojo.Message;
import pojo.Message_v2;
import pojo.MessageVO_v2;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface RpcChatService {

    public boolean setOnline(String userId, String serverId);

    public void setOffline(int userId);

    public void sendMessage(Message message) throws Exception;

    public Message_v2 sendMessage_v2(Message_v2 message) throws Exception;

    public void receivedMsg(UUID id);

    public List<Chat> getUpdatedMessages(int chatId, Timestamp lastOnline);

    public boolean receivedReturn(List<String> msgIds) throws Exception;

    public int checkIndivChat(int userId1, int userId2);

}
