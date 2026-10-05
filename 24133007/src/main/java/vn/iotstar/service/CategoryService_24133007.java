package vn.iotstar.service;

import java.util.List;
import vn.iotstar.dao.CategoryDaoImpl_24133007;
import vn.iotstar.dao.ICategoryDao_24133007;
import vn.iotstar.entity.Category_24133007;

public class CategoryService_24133007 implements ICategoryService_24133007 {

    private final ICategoryDao_24133007 categoryDao = new CategoryDaoImpl_24133007();

    @Override
    public List<Category_24133007> findAll() {
        return categoryDao.findAll();
    }

    @Override
    public List<Category_24133007> findAllWithVideoCount() {
        return categoryDao.findAllWithVideoCount();
    }

    @Override
    public Category_24133007 findById(int categoryId) {
        return categoryDao.findById(categoryId);
    }

    @Override
    public int countVideosByCategoryId(int categoryId) {
        return categoryDao.countVideosByCategoryId(categoryId);
    }
}
