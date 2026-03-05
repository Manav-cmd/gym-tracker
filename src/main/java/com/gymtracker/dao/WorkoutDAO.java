package com.gymtracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.List;
import java.util.ArrayList;

import com.gymtracker.model.Workout;
import com.gymtracker.util.DBConnection;

public class WorkoutDAO {

    public boolean addWorkout(Workout workout){

        boolean result = false;

        try{

            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO workouts(user_id,exercise_id,weight,sets,reps,notes,workout_date) VALUES(?,?,?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, workout.getUserId());
            ps.setInt(2, workout.getExerciseId());
            ps.setFloat(3, workout.getWeight());
            ps.setInt(4, workout.getSets());
            ps.setInt(5, workout.getReps());
            ps.setString(6, workout.getNotes());
            ps.setDate(7, workout.getWorkoutDate());

            int rows = ps.executeUpdate();

            if(rows > 0){
                result = true;
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return result;
    }

    public List<String[]> getWorkoutHistory(int userId){

        List<String[]> list = new ArrayList<>();

        try{

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT w.workout_date, e.name, w.weight, w.sets, w.reps, w.notes " +
                         "FROM workouts w JOIN exercises e ON w.exercise_id = e.id " +
                         "WHERE w.user_id=? ORDER BY w.workout_date DESC";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                String[] row = new String[6];

                row[0] = rs.getString("workout_date");
                row[1] = rs.getString("name");
                row[2] = rs.getString("weight");
                row[3] = rs.getString("sets");
                row[4] = rs.getString("reps");
                row[5] = rs.getString("notes");

                list.add(row);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}