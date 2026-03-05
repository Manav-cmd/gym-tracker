package com.gymtracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.gymtracker.model.Exercise;
import com.gymtracker.util.DBConnection;

public class ExerciseDAO {

    public boolean addExercise(Exercise exercise) {

        boolean result = false;

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO exercises(user_id,name,muscle_group) VALUES(?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, exercise.getUserId());
            ps.setString(2, exercise.getName());
            ps.setString(3, exercise.getMuscleGroup());

            int rows = ps.executeUpdate();

            if(rows > 0) {
                result = true;
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return result;
    }


    public List<Exercise> getExercisesByUser(int userId) {

        List<Exercise> list = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM exercises WHERE user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Exercise ex = new Exercise();

                ex.setId(rs.getInt("id"));
                ex.setName(rs.getString("name"));
                ex.setMuscleGroup(rs.getString("muscle_group"));

                list.add(ex);

            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}