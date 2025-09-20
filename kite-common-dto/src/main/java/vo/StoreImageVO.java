package vo;

import org.springframework.web.multipart.MultipartFile;

import java.io.Serializable;
import java.util.UUID;

public class StoreImageVO implements Serializable {

    private int chatId;

    private int from;

    private MultipartFile[] images;

    private UUID msgId;

    private String[] names;

    public StoreImageVO() {
    }

    public StoreImageVO(int chatId, int from, MultipartFile[] images, UUID msgId, String[] names) {
        this.chatId = chatId;
        this.from = from;
        this.images = images;
        this.msgId = msgId;
        this.names = names;
    }

    public int getChatId() {
        return chatId;
    }

    public void setChatId(int chatId) {
        this.chatId = chatId;
    }

    public MultipartFile[] getImages() {
        return images;
    }

    public void setImages(MultipartFile[] images) {
        this.images = images;
    }

    public int getFrom() {
        return from;
    }

    public void setFrom(int from) {
        this.from = from;
    }

    public UUID getMsgId() {
        return msgId;
    }

    public void setMsgId(UUID msgId) {
        this.msgId = msgId;
    }

    public String[] getNames() {
        return names;
    }

    public void setNames(String[] names) {
        this.names = names;
    }
}
