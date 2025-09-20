package service;

import vo.StoreImageVO;
import vo.StoreVoiceVO;

public interface RpcVoiceService {

    public String storeVoice(StoreVoiceVO vo);

    public byte[] getVoice(String id);

}
