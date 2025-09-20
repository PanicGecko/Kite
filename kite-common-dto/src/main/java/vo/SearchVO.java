package vo;

import java.io.Serializable;

public class SearchVO implements Serializable {

    private String search;

    private int userId;

    public SearchVO() {
    }

    public SearchVO(String search, int userId) {
        this.search = search;
        this.userId = userId;
    }

    public String getSearch() {
        return search;
    }

    public void setSearch(String search) {
        this.search = search;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}


