package vo;

import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

public class CheckUsername implements Serializable {

    @Length(min = 8, max = 20)
    private String username;

    public CheckUsername() {
    }

    public CheckUsername(String username) {
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
