package vo;

import java.io.Serializable;

public class GetImageVO implements Serializable {

    private String chatId;

    private String filename;

    public GetImageVO() {
    }

    public GetImageVO(String chatId, String filename) {
        this.chatId = chatId;
        this.filename = filename;
    }

    public String getChatId() {
        return chatId;
    }

    public void setChatId(String chatId) {
        this.chatId = chatId;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }
}
