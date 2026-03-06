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
        @keyframes fadeInUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        @keyframes fadeInLeft { from { opacity:0; transform:translateX(-20px); } to { opacity:1; transform:translateX(0); } }
        @keyframes rowIn { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }

        body { background: #0d0d0d; color: #e5e7eb; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 240px; min-height: 100vh; background: #111; border-right: 1px solid #1f1f1f; position: fixed; top: 0; left: 0; display: flex; flex-direction: column; padding: 1.5rem 0; z-index: 100; animation: fadeInLeft 0.4s ease both; transition: transform 0.3s ease; }
        .brand { font-size: 1.4rem; font-weight: 800; color: #fff; padding: 0 1.5rem 1.5rem; border-bottom: 1px solid #1f1f1f; }
        .brand span { color: #dc2626; }
        .nav-section { padding: 1.5rem 0; flex: 1; }
        .nav-label { font-size: 0.7rem; color: #4b5563; text-transform: uppercase; letter-spacing: 1px; padding: 0 1.5rem; margin-bottom: 0.5rem; }
        .nav-item a { display: flex; align-items: center; gap: 0.75rem; padding: 0.65rem 1.5rem; color: #9ca3af; text-decoration: none; font-size: 0.9rem; font-weight: 500; border-left: 3px solid transparent; transition: all 0.2s; }
        .nav-item a:hover, .nav-item a.active { color: #fff; background: rgba(220,38,38,0.08); border-left-color: #dc2626; }
        .nav-item a i { transition: transform 0.2s; }
        .nav-item a:hover i { transform: translateX(3px); }
        .sidebar-footer { padding: 1rem 1.5rem; border-top: 1px solid #1f1f1f; }
        .user-avatar { width: 36px; height: 36px; background: #dc2626; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; color: #fff; flex-shrink: 0; }
        .user-name { font-size: 0.85rem; color: #d1d5db; font-weight: 600; }
        .user-email { font-size: 0.75rem; color: #6b7280; }
        .btn-logout { font-size: 0.8rem; color: #6b7280; text-decoration: none; display: flex; align-items: center; gap: 0.4rem; margin-top: 0.5rem; transition: color 0.2s; }
        .btn-logout:hover { color: #dc2626; }
        .main-content { margin-left: 240px; padding: 2rem; }
        .card-dark { background: #141414; border: 1px solid #1f1f1f; border-radius: 12px; overflow: hidden; animation: fadeInUp 0.5s ease 0.1s both; }
        .card-header-dark { padding: 1.25rem 1.5rem; border-bottom: 1px solid #1f1f1f; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.75rem; }
        .card-header-dark h5 { margin: 0; font-size: 0.95rem; font-weight: 600; color: #e5e7eb; }
        .form-control, input { background: #1f1f1f !important; border: 1px solid #2a2a2a !important; color: #ffffff !important; border-radius: 8px; transition: border-color 0.2s; }
        .form-control:focus, input:focus { background: #1f1f1f !important; border-color: #dc2626 !important; color: #ffffff !important; box-shadow: 0 0 0 3px rgba(220,38,38,0.15) !important; outline: none !important; }
        input::placeholder { color: #6b7280 !important; }
        .table { color: #d1d5db; margin: 0; }
        .table thead th { background: #0f0f0f; border-color: #1f1f1f; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #6b7280; font-weight: 600; padding: 0.85rem 1.5rem; }
        .table tbody td { border-color: #1a1a1a; padding: 1rem 1.5rem; font-size: 0.875rem; vertical-align: middle; }
        .table tbody tr { animation: rowIn 0.3s ease both; }
        .table tbody tr:hover td { background: rgba(220,38,38,0.04); }
        .badge-sets { background: rgba(220,38,38,0.12); color: #f87171; font-size: 0.75rem; padding: 0.25rem 0.65rem; border-radius: 20px; font-weight: 500; }
        .badge-reps { background: rgba(234,88,12,0.12); color: #fb923c; font-size: 0.75rem; padding: 0.25rem 0.65rem; border-radius: 20px; font-weight: 500; }
        .empty-state { padding: 4rem; text-align: center; color: #4b5563; }
        .empty-state i { font-size: 3rem; margin-bottom: 1rem; display: block; }
        .search-box { width: 200px; padding: 0.45rem 0.9rem; font-size: 0.85rem; }
        .total-badge { background: rgba(220,38,38,0.15); color: #f87171; font-size: 0.78rem; padding: 0.35rem 0.75rem; border-radius: 20px; white-space: nowrap; }
        .btn-danger { background: #dc2626; border: none; border-radius: 8px; padding: 0.5rem 1rem; font-weight: 600; transition: all 0.25s; }
        .btn-danger:hover { background: #b91c1c; transform: translateY(-1px); }
        .hamburger { display: none; position: fixed; top: 1rem; left: 1rem; z-index: 200; background: #141414; border: 1px solid #2a2a2a; border-radius: 8px; padding: 0.5rem 0.65rem; cursor: pointer; color: #fff; font-size: 1.2rem; transition: background 0.2s; }
        .hamburger:hover { background: #dc2626; }
        .overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 99; }

        @media (max-width: 768px) {
            .hamburger { display: block; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .overlay.show { display: block; }
            .main-content { margin-left: 0; padding: 1rem; padding-top: 4rem; }
            .search-box { width: 140px; }
            .table thead { display: none; }
            .table tbody tr { display: block; border: 1px solid #1f1f1f; border-radius: 8px; margin-bottom: 0.75rem; padding: 0.5rem; }
            .table tbody td { display: flex; justify-content: space-between; align-items: center; border: none; padding: 0.4rem 0.75rem; font-size: 0.82rem; }
            .table tbody td::before { content: attr(data-label); color: #6b7280; font-size: 0.72rem; text-transform: uppercase; margin-right: 0.5rem; }
        }
    </style>
</head>
<body>
<button class="hamburger" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
<div class="overlay" id="overlay" onclick="toggleSidebar()"></div>
<div class="sidebar" id="sidebar">
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
            <div><div class="user-name"><%= user.getName() %></div><div class="user-email"><%= user.getEmail() %></div></div>
        </div>
        <a href="auth/login.jsp" class="btn-logout"><i class="bi bi-box-arrow-left"></i> Sign Out</a>
    </div>
</div>
<div class="main-content">
    <div class="d-flex justify-content-between align-items-start mb-4" style="animation: fadeInUp 0.5s ease both;">
        <div>
            <h1 style="font-size:1.6rem;font-weight:700;color:#fff;margin:0">Workout History</h1>
            <p style="color:#6b7280;margin:0.25rem 0 0;font-size:0.9rem">All your logged sessions, newest first</p>
        </div>
        <a href="log-workout.jsp" class="btn btn-danger btn-sm"><i class="bi bi-plus me-1"></i>Log Workout</a>
    </div>
    <div class="card-dark">
        <div class="card-header-dark">
            <h5><i class="bi bi-table me-2 text-danger"></i>All Sessions</h5>
            <div class="d-flex align-items-center gap-2">
                <input type="text" id="searchInput" class="form-control search-box" placeholder="Search exercise...">
                <span class="total-badge"><%= workouts.size() %> total</span>
            </div>
        </div>
        <% if(workouts.isEmpty()) { %>
        <div class="empty-state">
            <i class="bi bi-calendar-x text-danger"></i>
            <p class="mb-1">No workouts logged yet</p>
            <small>Start by <a href="log-workout.jsp" style="color:#dc2626">logging your first workout</a></small>
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-borderless" id="historyTable">
                <thead><tr><th>Date</th><th>Exercise</th><th>Weight</th><th>Sets</th><th>Reps</th><th>Notes</th></tr></thead>
                <tbody>
                    <% for(String[] w : workouts) { %>
                    <tr>
                        <td data-label="Date" style="color:#9ca3af;font-size:0.82rem"><i class="bi bi-calendar3 me-1"></i><%= w[0] %></td>
                        <td data-label="Exercise"><strong style="color:#fff"><%= w[1] %></strong></td>
                        <td data-label="Weight"><strong style="color:#fff"><%= w[2] %></strong> <span style="color:#6b7280;font-size:0.75rem">kg</span></td>
                        <td data-label="Sets"><span class="badge-sets"><%= w[3] %> sets</span></td>
                        <td data-label="Reps"><span class="badge-reps"><%= w[4] %> reps</span></td>
                        <td data-label="Notes" style="color:#6b7280"><%= (w[5] != null && !w[5].isEmpty()) ? w[5] : "&mdash;" %></td>
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
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('open');
        document.getElementById('overlay').classList.toggle('show');
    }
    document.getElementById('searchInput').addEventListener('keyup', function() {
        const filter = this.value.toLowerCase();
        document.querySelectorAll('#historyTable tbody tr').forEach(row => {
            row.style.display = row.cells[1].textContent.toLowerCase().includes(filter) ? '' : 'none';
        });
    });
</script>
</body>
</html>
