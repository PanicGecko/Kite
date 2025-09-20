package vo;

import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

public class CheckEmail implements Serializable {

    private String email;

    public CheckEmail() {
    }

    public CheckEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
