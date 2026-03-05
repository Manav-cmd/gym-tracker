package com.gymtracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.gymtracker.model.User;
import com.gymtracker.util.DBConnection;

public class UserDAO {

    public boolean registerUser(User user) {

        boolean result = false;

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO users(name,email,password) VALUES(?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());

            int rows = ps.executeUpdate();

            if(rows > 0) {
                result = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }


    public User loginUser(String email, String password) {

        User user = null;

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE email=? AND password=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                user = new User();

                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

}