package dao;

import org.apache.ibatis.annotations.Mapper;
import pojo.User;
import vo.CreateUserVO;
import vo.LoginUserVO;
import vo.SearchVO;
import vo.UserVO;

import java.sql.Timestamp;
import java.util.List;

@Mapper
public interface UserMapper {

    public int createUser(CreateUserVO user);

    public int getInsertId();

    public List<User> doLogin(LoginUserVO user);

    public Integer searchUsername(String username);

    public Integer searchEmail(String email);

    public Integer getIdbyUsername(String username);

    public List<UserVO> getUserbyInput(SearchVO vo);

    public void setOffline(int userId, Timestamp last);

    public Timestamp getLastOnline(int userId);

    public String getUsernameById(int userId);

}
