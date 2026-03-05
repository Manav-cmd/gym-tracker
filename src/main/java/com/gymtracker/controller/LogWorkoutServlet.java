package com.gymtracker.controller;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.gymtracker.dao.WorkoutDAO;
import com.gymtracker.model.User;
import com.gymtracker.model.Workout;

@WebServlet("/logWorkout")
public class LogWorkoutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect("auth/login.jsp");
            return;
        }

        int exerciseId = Integer.parseInt(request.getParameter("exercise"));
        float weight = Float.parseFloat(request.getParameter("weight"));
        int sets = Integer.parseInt(request.getParameter("sets"));
        int reps = Integer.parseInt(request.getParameter("reps"));
        String notes = request.getParameter("notes");
        Date date = Date.valueOf(request.getParameter("date"));

        Workout workout = new Workout(user.getId(), exerciseId, weight, sets, reps, notes, date);

        WorkoutDAO dao = new WorkoutDAO();
        dao.addWorkout(workout);

        response.sendRedirect("log-workout.jsp");
    }
}