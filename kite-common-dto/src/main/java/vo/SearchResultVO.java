package vo;

import java.io.Serializable;
import java.util.List;

public class SearchResultVO implements Serializable {

    private List<UserVO> users;

    public SearchResultVO() {
    }

    public SearchResultVO(List<UserVO> users) {
        this.users = users;
    }

    public List<UserVO> getUsers() {
        return users;
    }

    public void setUsers(List<UserVO> users) {
        this.users = users;
    }

    public void addUser(UserVO user) {
        this.users.add(user);
    }
}
