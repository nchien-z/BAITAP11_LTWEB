package vn.iotstar.service;

import java.util.List;
import vn.iotstar.dao.IVideoDao_24133007;
import vn.iotstar.dao.VideoDaoImpl_24133007;
import vn.iotstar.entity.Video_24133007;

public class VideoService_24133007 implements IVideoService_24133007 {

    private final IVideoDao_24133007 videoDao = new VideoDaoImpl_24133007();

    @Override
    public Video_24133007 findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public Video_24133007 findDetailById(String videoId) {
        return videoDao.findDetailById(videoId);
    }

    @Override
    public List<Video_24133007> findAll() {
        return videoDao.findAll();
    }

    @Override
    public List<Video_24133007> findAll(int page, int pageSize) {
        return videoDao.findAll(page, pageSize);
    }

    @Override
    public int countAll() {
        return videoDao.countAll();
    }

    @Override
    public List<Video_24133007> findByCategoryId(int categoryId, int page, int pageSize) {
        return videoDao.findByCategoryId(categoryId, page, pageSize);
    }

    @Override
    public int countByCategoryId(int categoryId) {
        return videoDao.countByCategoryId(categoryId);
    }

    @Override
    public int getLikeCount(String videoId) {
        return videoDao.getLikeCount(videoId);
    }

    @Override
    public int getShareCount(String videoId) {
        return videoDao.getShareCount(videoId);
    }

    @Override
    public void incrementView(String videoId) {
        videoDao.incrementView(videoId);
    }

    @Override
    public boolean insert(Video_24133007 video) {
        return videoDao.insert(video);
    }

    @Override
    public boolean update(Video_24133007 video) {
        return videoDao.update(video);
    }

    @Override
    public boolean delete(String videoId) {
        return videoDao.delete(videoId);
    }
}
