package vn.iotstar.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.iotstar.connection.DBConnection_24133007;
import vn.iotstar.entity.Video_24133007;

public class VideoDaoImpl_24133007 implements IVideoDao_24133007 {

    @Override
    public Video_24133007 findById(String videoId) {
        String sql = "SELECT v.*, c.Categoryname FROM Videos v LEFT JOIN Category c ON v.CategoryId = c.CategoryId WHERE v.VideoId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, videoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Video_24133007 v = extractVideo(rs);
                    v.setLikeCount(getLikeCount(videoId));
                    v.setShareCount(getShareCount(videoId));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Video_24133007 findDetailById(String videoId) {
        incrementView(videoId);
        return findById(videoId);
    }

    @Override
    public List<Video_24133007> findAll() {
        List<Video_24133007> list = new ArrayList<>();
        String sql = "SELECT v.*, c.Categoryname FROM Videos v LEFT JOIN Category c ON v.CategoryId = c.CategoryId ORDER BY v.VideoId ASC";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Video_24133007 v = extractVideo(rs);
                v.setLikeCount(getLikeCount(v.getVideoId()));
                v.setShareCount(getShareCount(v.getVideoId()));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Video_24133007> findAll(int page, int pageSize) {
        List<Video_24133007> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT v.*, c.Categoryname FROM Videos v "
                   + "LEFT JOIN Category c ON v.CategoryId = c.CategoryId "
                   + "ORDER BY v.VideoId ASC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Video_24133007 v = extractVideo(rs);
                    v.setLikeCount(getLikeCount(v.getVideoId()));
                    v.setShareCount(getShareCount(v.getVideoId()));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Videos";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Video_24133007> findByCategoryId(int categoryId, int page, int pageSize) {
        List<Video_24133007> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT v.*, c.Categoryname FROM Videos v "
                   + "LEFT JOIN Category c ON v.CategoryId = c.CategoryId "
                   + "WHERE v.CategoryId = ? "
                   + "ORDER BY v.VideoId ASC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Video_24133007 v = extractVideo(rs);
                    v.setLikeCount(getLikeCount(v.getVideoId()));
                    v.setShareCount(getShareCount(v.getVideoId()));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countByCategoryId(int categoryId) {
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

    @Override
    public int getLikeCount(String videoId) {
        String sql = "SELECT COUNT(*) FROM Favorites WHERE VideoId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, videoId);
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

    @Override
    public int getShareCount(String videoId) {
        String sql = "SELECT COUNT(*) FROM Shares WHERE VideoId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, videoId);
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

    @Override
    public void incrementView(String videoId) {
        String sql = "UPDATE Videos SET Views = Views + 1 WHERE VideoId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, videoId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean insert(Video_24133007 video) {
        String sql = "INSERT INTO Videos (VideoId, Title, Poster, VideoUrl, Views, Description, Active, CategoryId, UploadedBy, IsPrivate, CourseId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, video.getVideoId());
            ps.setString(2, video.getTitle());
            ps.setString(3, video.getPoster());
            ps.setString(4, video.getVideoUrl());
            ps.setInt(5, video.getViews());
            ps.setString(6, video.getDescription());
            ps.setBoolean(7, video.isActive());
            ps.setInt(8, video.getCategoryId());
            ps.setString(9, video.getUploadedBy());
            ps.setBoolean(10, video.isPrivateVideo());
            ps.setObject(11, video.getCourseId(), java.sql.Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Video_24133007 video) {
        String sql = "UPDATE Videos SET Title = ?, Poster = ?, VideoUrl = ?, Description = ?, Active = ?, CategoryId = ?, IsPrivate = ?, CourseId = ? WHERE VideoId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, video.getTitle());
            ps.setString(2, video.getPoster());
            ps.setString(3, video.getVideoUrl());
            ps.setString(4, video.getDescription());
            ps.setBoolean(5, video.isActive());
            ps.setInt(6, video.getCategoryId());
            ps.setBoolean(7, video.isPrivateVideo());
            ps.setObject(8, video.getCourseId(), java.sql.Types.INTEGER);
            ps.setString(9, video.getVideoId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(String videoId) {
        String sql = "DELETE FROM Videos WHERE VideoId = ?";
        try (Connection conn = DBConnection_24133007.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, videoId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Video_24133007 extractVideo(ResultSet rs) throws Exception {
        Video_24133007 v = new Video_24133007();
        v.setVideoId(rs.getString("VideoId"));
        v.setTitle(rs.getString("Title"));
        v.setPoster(rs.getString("Poster"));
        v.setVideoUrl(rs.getString("VideoUrl"));
        v.setViews(rs.getInt("Views"));
        v.setDescription(rs.getString("Description"));
        v.setActive(rs.getBoolean("Active"));
        v.setCategoryId(rs.getInt("CategoryId"));
        v.setPrivateVideo(rs.getBoolean("IsPrivate"));
        v.setCourseId(rs.getObject("CourseId", Integer.class));
        try { v.setUploadedBy(rs.getString("UploadedBy")); } catch (Exception ignored) {}
        try { v.setCategoryName(rs.getString("Categoryname")); } catch (Exception ignored) {}
        return v;
    }
}
