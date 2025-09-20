package vo;

import java.io.Serializable;

public class UserVO implements Serializable {

    private String username;
    private int userId;

    public UserVO() {
    }

    public UserVO(String username, int userId) {
        this.username = username;
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
