package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;

public class Favorite_24133007 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int favoriteId;
    private Date likedDate;
    private String videoId;
    private String username;

    public Favorite_24133007() {
    }

    public Favorite_24133007(int favoriteId, Date likedDate, String videoId, String username) {
        this.favoriteId = favoriteId;
        this.likedDate = likedDate;
        this.videoId = videoId;
        this.username = username;
    }

    public int getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(int favoriteId) {
        this.favoriteId = favoriteId;
    }

    public Date getLikedDate() {
        return likedDate;
    }

    public void setLikedDate(Date likedDate) {
        this.likedDate = likedDate;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
