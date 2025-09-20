package vo;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import java.io.Serializable;

public class LoginUserVO implements Serializable {

    @NotEmpty
    private String username;

    @NotEmpty
    @Length(min = 6)
    private String password;

    public LoginUserVO() {
    }

    public LoginUserVO(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

}
