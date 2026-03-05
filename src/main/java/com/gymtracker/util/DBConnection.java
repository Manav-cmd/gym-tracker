package com.gymtracker.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/gym_tracker";
    private static final String USER = "root";
    private static final String PASSWORD = "Ms26102005!"; // change if needed

    public static Connection getConnection() {

        Connection conn = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Database Connected");

        } catch (Exception e) {

            e.printStackTrace();

        }

        return conn;
    }
}