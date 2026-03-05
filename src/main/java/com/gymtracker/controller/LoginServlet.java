package com.gymtracker.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.gymtracker.dao.UserDAO;
import com.gymtracker.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();

        User user = dao.loginUser(email, password);

        if(user != null) {

            HttpSession session = request.getSession();

            session.setAttribute("user", user);

            response.sendRedirect("dashboard/dashboard.jsp");

        } else {

            response.getWriter().println("Invalid credentials");

        }

    }
}