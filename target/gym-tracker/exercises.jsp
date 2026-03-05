<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gymtracker.dao.ExerciseDAO" %>
<%@ page import="com.gymtracker.model.Exercise" %>
<%@ page import="com.gymtracker.model.User" %>
<%
User user = (User) session.getAttribute("user");
if(user == null){ response.sendRedirect("auth/login.jsp"); return; }
ExerciseDAO dao = new ExerciseDAO();
List<Exercise> exercises = dao.getExercisesByUser(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exercises - GymTracker</title>
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
        .page-header { margin-bottom: 2rem; }
        .page-header h1 { font-size: 1.6rem; font-weight: 700; color: #fff; margin: 0; }
        .page-header p { color: #6b7280; margin: 0.25rem 0 0; font-size: 0.9rem; }
        .card-dark { background: #141414; border: 1px solid #1f1f1f; border-radius: 12px; }
        .card-header-dark { padding: 1.25rem 1.5rem; border-bottom: 1px solid #1f1f1f; }
        .card-header-dark h5 { margin: 0; font-size: 0.95rem; font-weight: 600; color: #e5e7eb; }
        .form-label { color: #9ca3af; font-size: 0.82rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        /* DARK INPUT FIX */
        .form-control, .form-select, input, select, textarea { background: #1f1f1f !important; border: 1px solid #2a2a2a !important; color: #ffffff !important; border-radius: 8px; }
        .form-control:focus, .form-select:focus, input:focus, select:focus { background: #1f1f1f !important; border-color: #dc2626 !important; color: #ffffff !important; box-shadow: 0 0 0 3px rgba(220,38,38,0.15) !important; outline: none !important; }
        .form-control::placeholder, input::placeholder { color: #6b7280 !important; }
        input:-webkit-autofill, input:-webkit-autofill:hover, input:-webkit-autofill:focus { -webkit-box-shadow: 0 0 0 1000px #1f1f1f inset !important; -webkit-text-fill-color: #ffffff !important; }
        .input-group-text { background: #1a1a1a !important; border: 1px solid #2a2a2a !important; color: #9ca3af !important; }
        option { background: #1f1f1f !important; color: #fff !important; }
        /* END FIX */
        .btn-danger { background: #dc2626; border: none; border-radius: 8px; padding: 0.65rem 1.5rem; font-weight: 600; transition: all 0.2s; }
        .btn-danger:hover { background: #b91c1c; transform: translateY(-1px); box-shadow: 0 4px 20px rgba(220,38,38,0.35); }
        .table { color: #d1d5db; margin: 0; }
        .table thead th { background: #0f0f0f; border-color: #1f1f1f; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #6b7280; font-weight: 600; padding: 0.75rem 1.5rem; }
        .table tbody td { border-color: #1a1a1a; padding: 0.85rem 1.5rem; font-size: 0.875rem; vertical-align: middle; }
        .table tbody tr:hover td { background: rgba(255,255,255,0.02); }
        .muscle-badge { background: rgba(220,38,38,0.12); color: #f87171; font-size: 0.75rem; padding: 0.3rem 0.8rem; border-radius: 20px; font-weight: 500; }
        .exercise-id { color: #4b5563; font-size: 0.8rem; font-weight: 600; }
        .empty-state { padding: 3rem; text-align: center; color: #4b5563; }
        .empty-state i { font-size: 2.5rem; margin-bottom: 0.75rem; display: block; }
        .total-badge { background: rgba(220,38,38,0.15); color: #f87171; font-size: 0.78rem; padding: 0.35rem 0.75rem; border-radius: 20px; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">GYM<span>TRACKER</span></div>
    <nav class="nav-section">
        <div class="nav-label">Main</div>
        <div class="nav-item"><a href="dashboard/dashboard.jsp"><i class="bi bi-grid-1x2"></i> Dashboard</a></div>
        <div class="nav-item"><a href="exercises.jsp" class="active"><i class="bi bi-lightning-charge"></i> Exercises</a></div>
        <div class="nav-item"><a href="log-workout.jsp"><i class="bi bi-plus-circle"></i> Log Workout</a></div>
        <div class="nav-item"><a href="history.jsp"><i class="bi bi-clock-history"></i> History</a></div>
    </nav>
    <div class="sidebar-footer">
        <div class="d-flex align-items-center gap-2">
            <div class="user-avatar"><%= user.getName().substring(0,1).toUpperCase() %></div>
            <div>
                <div class="user-name"><%= user.getName() %></div>
                <div class="user-email"><%= user.getEmail() %></div>
            </div>
        </div>
        <a href="auth/login.jsp" class="btn-logout"><i class="bi bi-box-arrow-left"></i> Sign Out</a>
    </div>
</div>
<div class="main-content">
    <div class="page-header">
        <h1>Exercise Library</h1>
        <p>Create and manage your personal exercise list</p>
    </div>
    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card-dark">
                <div class="card-header-dark">
                    <h5><i class="bi bi-plus-lg me-2 text-danger"></i>Add New Exercise</h5>
                </div>
                <div class="p-4">
                    <form action="addExercise" method="post">
                        <div class="mb-3">
                            <label class="form-label">Exercise Name</label>
                            <input type="text" name="name" class="form-control" placeholder="e.g. Bench Press" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Muscle Group</label>
                            <select name="muscle" class="form-select" required>
                                <option value="" disabled selected>Select muscle group</option>
                                <option>Chest</option>
                                <option>Back</option>
                                <option>Shoulders</option>
                                <option>Biceps</option>
                                <option>Triceps</option>
                                <option>Legs</option>
                                <option>Glutes</option>
                                <option>Core / Abs</option>
                                <option>Calves</option>
                                <option>Full Body</option>
                                <option>Cardio</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-danger w-100">
                            <i class="bi bi-plus-circle me-2"></i>Add Exercise
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-dark">
                <div class="card-header-dark d-flex justify-content-between align-items-center">
                    <h5><i class="bi bi-lightning-charge me-2 text-danger"></i>Your Exercises</h5>
                    <span class="total-badge"><%= exercises.size() %> exercises</span>
                </div>
                <% if(exercises.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-lightning text-danger"></i>
                        <p class="mb-1">No exercises yet</p>
                        <small>Add your first exercise using the form</small>
                    </div>
                <% } else { %>
                <table class="table table-borderless">
                    <thead><tr><th>#</th><th>Exercise Name</th><th>Muscle Group</th></tr></thead>
                    <tbody>
                        <% for(Exercise ex : exercises) { %>
                        <tr>
                            <td><span class="exercise-id">#<%= ex.getId() %></span></td>
                            <td><strong style="color:#fff"><%= ex.getName() %></strong></td>
                            <td><span class="muscle-badge"><%= ex.getMuscleGroup() %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
