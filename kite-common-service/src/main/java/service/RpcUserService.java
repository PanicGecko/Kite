package service;

import pojo.Chat;
import pojo.User;
import vo.*;

import java.sql.Timestamp;
import java.util.List;

public interface RpcUserService {

    public User getLogin(LoginUserVO user) throws Exception;

    public Integer insertUser(CreateUserVO user) throws Exception;

    public boolean checkUsername(String username);

    public boolean checkEmail(String email);

    public Chat createChat(CreateChatVO vo) throws Exception;

    public Integer getIdbyUsername(String username);

    public List<UserVO> getUserbyInput(SearchVO vo);

    public void setLastOnline(int userId);

    public Timestamp getLastOnline(int userId);

    public String getUsernameById(int userId);

}
