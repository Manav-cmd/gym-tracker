package com.gymtracker.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.gymtracker.dao.UserDAO;
import com.gymtracker.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User(name, email, password);

        UserDAO dao = new UserDAO();

        boolean status = dao.registerUser(user);

        if(status) {
            response.sendRedirect("auth/login.jsp");
        } else {
            response.getWriter().println("Registration Failed");
        }

    }
}