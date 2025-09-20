package pojo;

import java.io.Serializable;

public class UserDetails implements Serializable {

    private int userId;

    public UserDetails() {
    }

    public UserDetails(int userId) {
        this.userId = userId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
