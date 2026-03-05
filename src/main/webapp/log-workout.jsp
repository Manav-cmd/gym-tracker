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
java.time.LocalDate today = java.time.LocalDate.now();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Workout - GymTracker</title>
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
        .form-control:focus, .form-select:focus, input:focus, select:focus, textarea:focus { background: #1f1f1f !important; border-color: #dc2626 !important; color: #ffffff !important; box-shadow: 0 0 0 3px rgba(220,38,38,0.15) !important; outline: none !important; }
        .form-control::placeholder, input::placeholder, textarea::placeholder { color: #6b7280 !important; }
        input:-webkit-autofill, input:-webkit-autofill:hover, input:-webkit-autofill:focus { -webkit-box-shadow: 0 0 0 1000px #1f1f1f inset !important; -webkit-text-fill-color: #ffffff !important; caret-color: #ffffff !important; }
        .input-group-text { background: #1a1a1a !important; border: 1px solid #2a2a2a !important; color: #9ca3af !important; }
        option { background: #1f1f1f !important; color: #fff !important; }
        /* Date input calendar icon color fix */
        input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(1); cursor: pointer; }
        /* END FIX */
        .btn-danger { background: #dc2626; border: none; border-radius: 8px; padding: 0.75rem 1.5rem; font-weight: 600; font-size: 1rem; transition: all 0.2s; }
        .btn-danger:hover { background: #b91c1c; transform: translateY(-1px); box-shadow: 0 4px 20px rgba(220,38,38,0.35); }
        .section-divider { color: #374151; font-size: 0.78rem; text-transform: uppercase; letter-spacing: 1px; margin: 1.5rem 0 1rem; padding-bottom: 0.5rem; border-bottom: 1px solid #1f1f1f; }
        .info-tip { background: rgba(220,38,38,0.06); border: 1px solid rgba(220,38,38,0.15); border-radius: 8px; padding: 0.75rem 1rem; font-size: 0.82rem; color: #9ca3af; }
        .no-exercises-warning { background: rgba(234,88,12,0.1); border: 1px solid rgba(234,88,12,0.2); border-radius: 8px; padding: 1rem; font-size: 0.875rem; color: #fdba74; }
        textarea.form-control { resize: none; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">GYM<span>TRACKER</span></div>
    <nav class="nav-section">
        <div class="nav-label">Main</div>
        <div class="nav-item"><a href="dashboard/dashboard.jsp"><i class="bi bi-grid-1x2"></i> Dashboard</a></div>
        <div class="nav-item"><a href="exercises.jsp"><i class="bi bi-lightning-charge"></i> Exercises</a></div>
        <div class="nav-item"><a href="log-workout.jsp" class="active"><i class="bi bi-plus-circle"></i> Log Workout</a></div>
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
        <h1>Log Workout</h1>
        <p>Record your sets, reps and weight for today's session</p>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card-dark">
                <div class="card-header-dark">
                    <h5><i class="bi bi-plus-circle me-2 text-danger"></i>New Workout Entry</h5>
                </div>
                <div class="p-4">
                    <% if(exercises.isEmpty()) { %>
                    <div class="no-exercises-warning mb-4">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        No exercises found. <a href="exercises.jsp" style="color:#fb923c; font-weight:600;">Add exercises first &rarr;</a>
                    </div>
                    <% } %>
                    <form action="logWorkout" method="post">
                        <div class="mb-3">
                            <label class="form-label">Exercise</label>
                            <select name="exercise" class="form-select" required>
                                <option value="" disabled selected>Choose an exercise</option>
                                <% for(Exercise ex : exercises) { %>
                                <option value="<%= ex.getId() %>"><%= ex.getName() %> &mdash; <%= ex.getMuscleGroup() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date</label>
                            <input type="date" name="date" class="form-control" value="<%= today %>" required>
                        </div>
                        <div class="section-divider">Performance</div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="form-label">Weight (kg)</label>
                                <input type="number" step="0.5" min="0" name="weight" class="form-control" placeholder="80" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Sets</label>
                                <input type="number" min="1" name="sets" class="form-control" placeholder="4" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Reps</label>
                                <input type="number" min="1" name="reps" class="form-control" placeholder="10" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Notes <span style="color:#4b5563; text-transform:none; font-size:0.78rem;">(optional)</span></label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="How did the set feel? Any PRs?"></textarea>
                        </div>
                        <button type="submit" class="btn btn-danger w-100" <%= exercises.isEmpty() ? "disabled" : "" %>>
                            <i class="bi bi-save me-2"></i>Save Workout
                        </button>
                    </form>
                </div>
            </div>
            <div class="info-tip mt-3">
                <i class="bi bi-lightbulb me-2 text-danger"></i>
                Tip: Log every session consistently to track your progress over time.
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
