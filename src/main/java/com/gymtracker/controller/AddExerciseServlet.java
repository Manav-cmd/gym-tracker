package com.gymtracker.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.gymtracker.dao.ExerciseDAO;
import com.gymtracker.model.Exercise;
import com.gymtracker.model.User;

@WebServlet("/addExercise")
public class AddExerciseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession();

    	User user = (User) session.getAttribute("user");

    	if(user == null){
    	    response.sendRedirect("auth/login.jsp");
    	    return;
    	}

    	String name = request.getParameter("name");
    	String muscle = request.getParameter("muscle");

    	Exercise exercise = new Exercise(user.getId(), name, muscle);

        ExerciseDAO dao = new ExerciseDAO();

        dao.addExercise(exercise);

        response.sendRedirect("exercises.jsp");

    }

}