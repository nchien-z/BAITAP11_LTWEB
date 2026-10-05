package vn.iotstar.service;

import java.util.List;
import vn.iotstar.dao.IUserDao_24133007;
import vn.iotstar.dao.UserDaoImpl_24133007;
import vn.iotstar.entity.User_24133007;

public class UserService_24133007 implements IUserService_24133007 {

    private final IUserDao_24133007 userDao = new UserDaoImpl_24133007();

    @Override
    public User_24133007 findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User_24133007 login(String username, String password) {
        return userDao.login(username, password);
    }

    @Override
    public boolean register(User_24133007 user) {
        return userDao.register(user);
    }

    @Override
    public boolean activateUser(String username) {
        return userDao.activateUser(username);
    }

    @Override
    public List<User_24133007> findAll() {
        return userDao.findAll();
    }

    @Override
    public List<User_24133007> findAll(int page, int pageSize) {
        return userDao.findAll(page, pageSize);
    }

    @Override
    public int countAll() {
        return userDao.countAll();
    }

    @Override
    public boolean insert(User_24133007 user) {
        return userDao.insert(user);
    }

    @Override
    public boolean update(User_24133007 user) {
        return userDao.update(user);
    }

    @Override
    public boolean delete(String username) {
        return userDao.delete(username);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }
}
