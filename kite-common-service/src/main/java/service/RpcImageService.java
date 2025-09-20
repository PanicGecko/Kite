package service;

import vo.GetImageVO;
import vo.StoreImageVO;

import java.util.List;

public interface RpcImageService {

    public List<String> storeImages(StoreImageVO imgs);

    public byte[] getImage(String id);

    public int testRPC();

}
