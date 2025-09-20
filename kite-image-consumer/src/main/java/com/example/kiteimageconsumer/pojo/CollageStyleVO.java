package com.example.kiteimageconsumer.pojo;

import java.io.Serializable;
import java.util.List;

public class CollageStyleVO implements Serializable {

    private List<String> ids;

    public CollageStyleVO() {
    }

    public CollageStyleVO(List<String> ids) {
        this.ids = ids;
    }

    public List<String> getIds() {
        return ids;
    }

    public void setIds(List<String> ids) {
        this.ids = ids;
    }
}
