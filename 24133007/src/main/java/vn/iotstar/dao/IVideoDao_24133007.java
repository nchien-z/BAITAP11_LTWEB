package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Video_24133007;

public interface IVideoDao_24133007 {
    Video_24133007 findById(String videoId);
    Video_24133007 findDetailById(String videoId);
    List<Video_24133007> findAll();
    List<Video_24133007> findAll(int page, int pageSize);
    int countAll();
    List<Video_24133007> findByCategoryId(int categoryId, int page, int pageSize);
    int countByCategoryId(int categoryId);
    int getLikeCount(String videoId);
    int getShareCount(String videoId);
    void incrementView(String videoId);
    boolean insert(Video_24133007 video);
    boolean update(Video_24133007 video);
    boolean delete(String videoId);
}
