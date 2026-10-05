package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.User_24133007;

public interface IUserService_24133007 {
    User_24133007 findByUsername(String username);
    User_24133007 login(String username, String password);
    boolean register(User_24133007 user);
    boolean activateUser(String username);
    List<User_24133007> findAll();
    List<User_24133007> findAll(int page, int pageSize);
    int countAll();
    boolean insert(User_24133007 user);
    boolean update(User_24133007 user);
    boolean delete(String username);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
}
