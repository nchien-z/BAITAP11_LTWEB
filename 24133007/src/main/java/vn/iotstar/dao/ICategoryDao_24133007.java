package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Category_24133007;

public interface ICategoryDao_24133007 {
    List<Category_24133007> findAll();
    List<Category_24133007> findAllWithVideoCount();
    Category_24133007 findById(int categoryId);
    int countVideosByCategoryId(int categoryId);
}
