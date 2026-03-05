<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.gymtracker.dao.WorkoutDAO" %>
<%@ page import="com.gymtracker.model.User" %>
<%
User user = (User) session.getAttribute("user");
if(user == null){ response.sendRedirect("auth/login.jsp"); return; }
WorkoutDAO dao = new WorkoutDAO();
List<String[]> workouts = dao.getWorkoutHistory(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>History - GymTracker</title>
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
        .card-dark { background: #141414; border: 1px solid #1f1f1f; border-radius: 12px; overflow: hidden; }
        .card-header-dark { padding: 1.25rem 1.5rem; border-bottom: 1px solid #1f1f1f; display: flex; justify-content: space-between; align-items: center; }
        .card-header-dark h5 { margin: 0; font-size: 0.95rem; font-weight: 600; color: #e5e7eb; }
        /* DARK INPUT FIX */
        .form-control, input, select, textarea { background: #1f1f1f !important; border: 1px solid #2a2a2a !important; color: #ffffff !important; border-radius: 8px; }
        .form-control:focus, input:focus { background: #1f1f1f !important; border-color: #dc2626 !important; color: #ffffff !important; box-shadow: 0 0 0 3px rgba(220,38,38,0.15) !important; outline: none !important; }
        input::placeholder { color: #6b7280 !important; }
        /* END FIX */
        .table { color: #d1d5db; margin: 0; }
        .table thead th { background: #0f0f0f; border-color: #1f1f1f; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #6b7280; font-weight: 600; padding: 0.85rem 1.5rem; }
        .table tbody td { border-color: #1a1a1a; padding: 1rem 1.5rem; font-size: 0.875rem; vertical-align: middle; }
        .table tbody tr:hover td { background: rgba(255,255,255,0.02); }
        .badge-sets { background: rgba(220,38,38,0.12); color: #f87171; font-size: 0.75rem; padding: 0.25rem 0.65rem; border-radius: 20px; font-weight: 500; }
        .badge-reps { background: rgba(234,88,12,0.12); color: #fb923c; font-size: 0.75rem; padding: 0.25rem 0.65rem; border-radius: 20px; font-weight: 500; }
        .weight-val { font-weight: 700; color: #fff; }
        .date-val { color: #9ca3af; font-size: 0.82rem; font-weight: 500; }
        .notes-val { color: #6b7280; font-size: 0.82rem; max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .empty-state { padding: 4rem; text-align: center; color: #4b5563; }
        .empty-state i { font-size: 3rem; margin-bottom: 1rem; display: block; }
        .search-box { width: 200px; padding: 0.45rem 0.9rem; font-size: 0.85rem; }
        .total-badge { background: rgba(220,38,38,0.15); color: #f87171; font-size: 0.78rem; padding: 0.35rem 0.75rem; border-radius: 20px; }
        .btn-danger { background: #dc2626; border: none; border-radius: 8px; padding: 0.5rem 1rem; font-weight: 600; transition: all 0.2s; }
        .btn-danger:hover { background: #b91c1c; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">GYM<span>TRACKER</span></div>
    <nav class="nav-section">
        <div class="nav-label">Main</div>
        <div class="nav-item"><a href="dashboard/dashboard.jsp"><i class="bi bi-grid-1x2"></i> Dashboard</a></div>
        <div class="nav-item"><a href="exercises.jsp"><i class="bi bi-lightning-charge"></i> Exercises</a></div>
        <div class="nav-item"><a href="log-workout.jsp"><i class="bi bi-plus-circle"></i> Log Workout</a></div>
        <div class="nav-item"><a href="history.jsp" class="active"><i class="bi bi-clock-history"></i> History</a></div>
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
    <div class="page-header d-flex justify-content-between align-items-start">
        <div>
            <h1>Workout History</h1>
            <p>All your logged sessions, newest first</p>
        </div>
        <a href="log-workout.jsp" class="btn btn-danger btn-sm">
            <i class="bi bi-plus me-1"></i>Log Workout
        </a>
    </div>
    <div class="card-dark">
        <div class="card-header-dark">
            <h5><i class="bi bi-table me-2 text-danger"></i>All Sessions</h5>
            <div class="d-flex align-items-center gap-3">
                <input type="text" id="searchInput" class="form-control search-box" placeholder="Search exercise...">
                <span class="total-badge"><%= workouts.size() %> total</span>
            </div>
        </div>
        <% if(workouts.isEmpty()) { %>
        <div class="empty-state">
            <i class="bi bi-calendar-x text-danger"></i>
            <p class="mb-1">No workouts logged yet</p>
            <small>Start by <a href="log-workout.jsp" style="color:#dc2626;">logging your first workout</a></small>
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-borderless" id="historyTable">
                <thead>
                    <tr><th>Date</th><th>Exercise</th><th>Weight</th><th>Sets</th><th>Reps</th><th>Notes</th></tr>
                </thead>
                <tbody>
                    <% for(String[] w : workouts) { %>
                    <tr>
                        <td><span class="date-val"><i class="bi bi-calendar3 me-1"></i><%= w[0] %></span></td>
                        <td><strong style="color:#fff"><%= w[1] %></strong></td>
                        <td><span class="weight-val"><%= w[2] %></span> <span style="color:#6b7280;font-size:0.75rem">kg</span></td>
                        <td><span class="badge-sets"><%= w[3] %> sets</span></td>
                        <td><span class="badge-reps"><%= w[4] %> reps</span></td>
                        <td><span class="notes-val"><%= (w[5] != null && !w[5].isEmpty()) ? w[5] : "—" %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('searchInput').addEventListener('keyup', function() {
        const filter = this.value.toLowerCase();
        document.querySelectorAll('#historyTable tbody tr').forEach(row => {
            row.style.display = row.cells[1].textContent.toLowerCase().includes(filter) ? '' : 'none';
        });
    });
</script>
</body>
</html>
