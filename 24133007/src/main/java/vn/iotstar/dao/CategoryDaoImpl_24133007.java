package vn.iotstar.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.iotstar.connection.DBConnection_24133007;
import vn.iotstar.entity.Category_24133007;

public class CategoryDaoImpl_24133007 implements ICategoryDao_24133007 {

    @Override
    public List<Category_24133007> findAll() {
        List<Category_24133007> list = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY CategoryId ASC";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category_24133007 cat = new Category_24133007();
                cat.setCategoryId(rs.getInt("CategoryId"));
                cat.setCategoryname(rs.getString("Categoryname"));
                cat.setCategorycode(rs.getString("Categorycode"));
                cat.setImages(rs.getString("Images"));
                cat.setStatus(rs.getBoolean("Status"));
                list.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Category_24133007> findAllWithVideoCount() {
        List<Category_24133007> list = new ArrayList<>();
        String sql = "SELECT c.CategoryId, c.Categoryname, c.Categorycode, c.Images, c.Status, COUNT(v.VideoId) AS VideoCount "
                   + "FROM Category c LEFT JOIN Videos v ON c.CategoryId = v.CategoryId "
                   + "GROUP BY c.CategoryId, c.Categoryname, c.Categorycode, c.Images, c.Status "
                   + "ORDER BY c.CategoryId ASC";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category_24133007 cat = new Category_24133007();
                cat.setCategoryId(rs.getInt("CategoryId"));
                cat.setCategoryname(rs.getString("Categoryname"));
                cat.setCategorycode(rs.getString("Categorycode"));
                cat.setImages(rs.getString("Images"));
                cat.setStatus(rs.getBoolean("Status"));
                cat.setVideoCount(rs.getInt("VideoCount"));
                list.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Category_24133007 findById(int categoryId) {
        String sql = "SELECT * FROM Category WHERE CategoryId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category_24133007 cat = new Category_24133007();
                    cat.setCategoryId(rs.getInt("CategoryId"));
                    cat.setCategoryname(rs.getString("Categoryname"));
                    cat.setCategorycode(rs.getString("Categorycode"));
                    cat.setImages(rs.getString("Images"));
                    cat.setStatus(rs.getBoolean("Status"));
                    return cat;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int countVideosByCategoryId(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Videos WHERE CategoryId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
