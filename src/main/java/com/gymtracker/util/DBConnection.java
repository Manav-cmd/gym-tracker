package com.gymtracker.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {

        Connection conn = null;

        try {
            // Reads from Railway environment variables automatically
            // Falls back to local MySQL if env vars not set
            String host     = System.getenv("MYSQLHOST")     != null ? System.getenv("MYSQLHOST")     : "localhost";
            String port     = System.getenv("MYSQLPORT")     != null ? System.getenv("MYSQLPORT")     : "3306";
            String database = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : "gym_tracker";
            String user     = System.getenv("MYSQLUSER")     != null ? System.getenv("MYSQLUSER")     : "root";
            String password = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : "Ms26102005!";

            String url = "jdbc:mysql://" + host + ":" + port + "/" + database + "?useSSL=false&allowPublicKeyRetrieval=true";

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Database Connected Successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }
}
