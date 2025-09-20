package vo;

import java.io.Serializable;

public class TokenVO implements Serializable {

    private String token;

    private int userId;

    public TokenVO(){}

    public TokenVO(String token, int userId){
        this.token = token;
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
