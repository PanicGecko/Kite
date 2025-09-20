package vo;

import org.springframework.web.multipart.MultipartFile;

import java.io.Serializable;
import java.util.UUID;

public class StoreVoiceVO implements Serializable {

    private int chatId;

    private int from;

    private MultipartFile voice;

    private UUID msgId;

    public StoreVoiceVO() {
    }

    public StoreVoiceVO(int chatId, int from, MultipartFile voice, UUID msgId) {
        this.chatId = chatId;
        this.from = from;
        this.voice = voice;
        this.msgId = msgId;
    }

    public int getChatId() {
        return chatId;
    }

    public void setChatId(int chatId) {
        this.chatId = chatId;
    }

    public int getFrom() {
        return from;
    }

    public void setFrom(int from) {
        this.from = from;
    }

    public MultipartFile getVoice() {
        return voice;
    }

    public void setVoice(MultipartFile voice) {
        this.voice = voice;
    }

    public UUID getMsgId() {
        return msgId;
    }

    public void setMsgId(UUID msgId) {
        this.msgId = msgId;
    }
}
