<%@ page import="com.gymtracker.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gymtracker.dao.WorkoutDAO" %>
<%@ page import="com.gymtracker.dao.ExerciseDAO" %>
<%@ page import="java.util.List" %>
<%
User user = (User) session.getAttribute("user");
if(user == null){ response.sendRedirect("../auth/login.jsp"); return; }
WorkoutDAO wDao = new WorkoutDAO();
ExerciseDAO eDao = new ExerciseDAO();
List<String[]> workouts = wDao.getWorkoutHistory(user.getId());
int totalWorkouts = workouts.size();
int totalExercises = eDao.getExercisesByUser(user.getId()).size();
String lastWorkoutDate = totalWorkouts > 0 ? workouts.get(0)[0] : "—";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - GymTracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #0d0d0d; color: #e5e7eb; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 240px; min-height: 100vh; background: #111; border-right: 1px solid #1f1f1f; position: fixed; top: 0; left: 0; display: flex; flex-direction: column; padding: 1.5rem 0; z-index: 100; }
        .brand { font-size: 1.4rem; font-weight: 800; color: #fff; padding: 0 1.5rem 1.5rem; border-bottom: 1px solid #1f1f1f; }
        .brand span { color: #dc2626; }
        .nav-section { padding: 1.5rem 0; flex: 1; }
        .nav-label { font-size: 0.7rem; color: #4b5563; text-transform: uppercase; letter-spacing: 1px; padding: 0 1.5rem; margin-bottom: 0.5rem; }
        .nav-item a { display: flex; align-items: center; gap: 0.75rem; padding: 0.65rem 1.5rem; color: #9ca3af; text-decoration: none; font-size: 0.9rem; font-weight: 500; border-left: 3px solid transparent; transition: all 0.15s; }
        .nav-item a:hover, .nav-item a.active { color: #fff; background: rgba(220,38,38,0.08); border-left-color: #dc2626; }
        .sidebar-footer { padding: 1rem 1.5rem; border-top: 1px solid #1f1f1f; }
        .user-avatar { width: 36px; height: 36px; background: #dc2626; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; color: #fff; flex-shrink: 0; }
        .user-name { font-size: 0.85rem; color: #d1d5db; font-weight: 600; }
        .user-email { font-size: 0.75rem; color: #6b7280; }
        .btn-logout { font-size: 0.8rem; color: #6b7280; text-decoration: none; display: flex; align-items: center; gap: 0.4rem; margin-top: 0.5rem; }
        .btn-logout:hover { color: #dc2626; }
        .main-content { margin-left: 240px; padding: 2rem; }
        .stat-card { background: #141414; border: 1px solid #1f1f1f; border-radius: 12px; padding: 1.5rem; transition: border-color 0.2s; }
        .stat-card:hover { border-color: #dc2626; }
        .stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; margin-bottom: 1rem; }
        .stat-icon.red { background: rgba(220,38,38,0.15); color: #dc2626; }
        .stat-icon.orange { background: rgba(234,88,12,0.15); color: #ea580c; }
        .stat-icon.green { background: rgba(22,163,74,0.15); color: #16a34a; }
        .stat-value { font-size: 1.8rem; font-weight: 700; color: #fff; line-height: 1; }
        .stat-label { font-size: 0.82rem; color: #6b7280; margin-top: 0.25rem; }
        .section-card { background: #141414; border: 1px solid #1f1f1f; border-radius: 12px; overflow: hidden; }
        .section-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid #1f1f1f; display: flex; justify-content: space-between; align-items: center; }
        .section-header h5 { margin: 0; font-size: 0.95rem; font-weight: 600; color: #e5e7eb; }
        .table { color: #d1d5db; margin: 0; }
        .table thead th { background: #0f0f0f; border-color: #1f1f1f; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #6b7280; font-weight: 600; padding: 0.75rem 1.5rem; }
        .table tbody td { border-color: #1a1a1a; padding: 0.85rem 1.5rem; font-size: 0.875rem; vertical-align: middle; }
        .table tbody tr:hover td { background: rgba(255,255,255,0.02); }
        .badge-muscle { background: rgba(220,38,38,0.15); color: #f87171; font-size: 0.75rem; padding: 0.3rem 0.7rem; border-radius: 20px; font-weight: 500; }
        .quick-btn { background: #1a1a1a; border: 1px solid #2a2a2a; color: #e5e7eb; border-radius: 10px; padding: 1rem 1.25rem; text-decoration: none; display: flex; align-items: center; gap: 0.75rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; }
        .quick-btn:hover { border-color: #dc2626; color: #fff; background: rgba(220,38,38,0.08); }
        .quick-btn i { font-size: 1.1rem; color: #dc2626; }
        .empty-state { padding: 2.5rem; text-align: center; color: #4b5563; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">GYM<span>TRACKER</span></div>
    <nav class="nav-section">
        <div class="nav-label">Main</div>
        <div class="nav-item"><a href="dashboard.jsp" class="active"><i class="bi bi-grid-1x2"></i> Dashboard</a></div>
        <div class="nav-item"><a href="../exercises.jsp"><i class="bi bi-lightning-charge"></i> Exercises</a></div>
        <div class="nav-item"><a href="../log-workout.jsp"><i class="bi bi-plus-circle"></i> Log Workout</a></div>
        <div class="nav-item"><a href="../history.jsp"><i class="bi bi-clock-history"></i> History</a></div>
    </nav>
    <div class="sidebar-footer">
        <div class="d-flex align-items-center gap-2">
            <div class="user-avatar"><%= user.getName().substring(0,1).toUpperCase() %></div>
            <div>
                <div class="user-name"><%= user.getName() %></div>
                <div class="user-email"><%= user.getEmail() %></div>
            </div>
        </div>
        <a href="../auth/login.jsp" class="btn-logout"><i class="bi bi-box-arrow-left"></i> Sign Out</a>
    </div>
</div>
<div class="main-content">
    <div class="mb-4">
        <h1 style="font-size:1.6rem;font-weight:700;color:#fff;margin:0">Welcome back, <%= user.getName().split(" ")[0] %></h1>
        <p style="color:#6b7280;margin:0.25rem 0 0;font-size:0.9rem">Here's your training overview</p>
    </div>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon red"><i class="bi bi-activity"></i></div>
                <div class="stat-value"><%= totalWorkouts %></div>
                <div class="stat-label">Total Workouts Logged</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon orange"><i class="bi bi-lightning-charge"></i></div>
                <div class="stat-value"><%= totalExercises %></div>
                <div class="stat-label">Exercises Created</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon green"><i class="bi bi-calendar-check"></i></div>
                <div class="stat-value" style="font-size:1.15rem;padding-top:4px"><%= lastWorkoutDate %></div>
                <div class="stat-label">Last Workout Date</div>
            </div>
        </div>
    </div>
    <p style="color:#6b7280;font-size:0.78rem;text-transform:uppercase;letter-spacing:1px;margin-bottom:0.75rem">Quick Actions</p>
    <div class="row g-3 mb-4">
        <div class="col-md-3 col-6"><a href="../log-workout.jsp" class="quick-btn"><i class="bi bi-plus-circle-fill"></i> Log Workout</a></div>
        <div class="col-md-3 col-6"><a href="../exercises.jsp" class="quick-btn"><i class="bi bi-lightning-charge-fill"></i> Add Exercise</a></div>
        <div class="col-md-3 col-6"><a href="../history.jsp" class="quick-btn"><i class="bi bi-clock-history"></i> View History</a></div>
    </div>
    <div class="section-card">
        <div class="section-header">
            <h5><i class="bi bi-clock-history me-2 text-danger"></i>Recent Workouts</h5>
            <a href="../history.jsp" style="font-size:0.82rem;color:#dc2626;text-decoration:none">View All →</a>
        </div>
        <% if(totalWorkouts == 0) { %>
        <div class="empty-state">
            <i class="bi bi-calendar-x" style="font-size:2rem;color:#4b5563;display:block;margin-bottom:0.5rem"></i>
            No workouts yet. <a href="../log-workout.jsp" style="color:#dc2626">Log your first one!</a>
        </div>
        <% } else { %>
        <table class="table table-borderless">
            <thead><tr><th>Date</th><th>Exercise</th><th>Weight</th><th>Sets</th><th>Reps</th><th>Notes</th></tr></thead>
            <tbody>
                <% int limit = Math.min(5, workouts.size()); for(int i=0;i<limit;i++){ String[] w=workouts.get(i); %>
                <tr>
                    <td style="color:#9ca3af;font-size:0.82rem"><%= w[0] %></td>
                    <td><strong style="color:#fff"><%= w[1] %></strong></td>
                    <td><strong style="color:#fff"><%= w[2] %></strong> <span style="color:#6b7280;font-size:0.75rem">kg</span></td>
                    <td><span class="badge-muscle"><%= w[3] %> sets</span></td>
                    <td><%= w[4] %> reps</td>
                    <td style="color:#6b7280"><%= w[5] != null ? w[5] : "—" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
