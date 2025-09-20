package service;

import pojo.User;
import vo.CreateUserVO;
import vo.EmailVerVO;
import vo.TokenVO;
import vo.VerEmailVO;

public interface RpcTokenService {

    public String saveUserToken(String email) throws Exception;

    public boolean saveNewUser(CreateUserVO user);

    public CreateUserVO checkCode(VerEmailVO ver);

    public boolean saveCurrUser(User user);

    public User checkLoginCode(VerEmailVO ver);

    public String genJwt(int userId);

    public void sendEmail(EmailVerVO email);

    public int checkJwt(String token);

    public boolean validateToken(String token);

    public Integer getId(String token);

    public String refreshToken(String token);

}
