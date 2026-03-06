<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - GymTracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        body {
            background-color: #0d0d0d;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
            background-image: radial-gradient(circle at 80% 50%, #1a0000 0%, #0d0d0d 60%);
        }
        .auth-card {
            background: #141414;
            border: 1px solid #2a2a2a;
            border-radius: 16px;
            padding: 2.5rem;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 0 60px rgba(220,38,38,0.08);
            animation: fadeInUp 0.6s ease both;
        }
        .brand-logo { font-size: 1.8rem; font-weight: 800; color: #fff; letter-spacing: -0.5px; }
        .brand-logo span { color: #dc2626; }
        .subtitle { color: #6b7280; font-size: 0.9rem; }
        .form-group-animated { animation: fadeInUp 0.6s ease both; }
        .form-group-animated:nth-child(1) { animation-delay: 0.15s; }
        .form-group-animated:nth-child(2) { animation-delay: 0.25s; }
        .form-group-animated:nth-child(3) { animation-delay: 0.35s; }
        .form-label { color: #9ca3af; font-size: 0.85rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control, input, select, textarea { background: #1f1f1f !important; border: 1px solid #2a2a2a !important; color: #ffffff !important; border-radius: 8px; transition: border-color 0.2s, box-shadow 0.2s; }
        .form-control:focus, input:focus { background: #1f1f1f !important; border-color: #dc2626 !important; color: #ffffff !important; box-shadow: 0 0 0 3px rgba(220,38,38,0.15) !important; }
        .form-control::placeholder, input::placeholder { color: #6b7280 !important; }
        input:-webkit-autofill, input:-webkit-autofill:hover, input:-webkit-autofill:focus { -webkit-box-shadow: 0 0 0 1000px #1f1f1f inset !important; -webkit-text-fill-color: #ffffff !important; caret-color: #ffffff !important; }
        .input-group-text { background: #1a1a1a !important; border: 1px solid #2a2a2a !important; color: #9ca3af !important; transition: color 0.2s; }
        .input-group:focus-within .input-group-text { color: #dc2626 !important; border-color: #dc2626 !important; }
        .btn-danger { background: #dc2626; border: none; border-radius: 8px; padding: 0.75rem; font-weight: 600; font-size: 1rem; transition: all 0.25s; animation: fadeInUp 0.6s ease 0.45s both; }
        .btn-danger:hover { background: #b91c1c; transform: translateY(-2px); box-shadow: 0 6px 24px rgba(220,38,38,0.4); }
        .btn-danger:active { transform: translateY(0); }
        a.link-accent { color: #dc2626; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        a.link-accent:hover { color: #f87171; }
        .password-hint { font-size: 0.78rem; color: #4b5563; margin-top: 4px; }

        @media (max-width: 480px) {
            body { padding: 1rem; align-items: flex-start; padding-top: 3rem; }
            .auth-card { padding: 1.75rem 1.25rem; border-radius: 12px; }
            .brand-logo { font-size: 1.5rem; }
        }
    </style>
</head>
<body>
    <div class="auth-card">
        <div class="text-center mb-4">
            <div class="brand-logo mb-1">GYM<span>TRACKER</span></div>
            <p class="subtitle">Create your free account</p>
        </div>
        <form action="../register" method="post">
            <div class="mb-3 form-group-animated">
                <label class="form-label">Full Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" name="name" class="form-control" placeholder="John Doe" required>
                </div>
            </div>
            <div class="mb-3 form-group-animated">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
                </div>
            </div>
            <div class="mb-4 form-group-animated">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="Create a strong password" required>
                </div>
                <div class="password-hint"><i class="bi bi-info-circle me-1"></i>Use at least 8 characters</div>
            </div>
            <button type="submit" class="btn btn-danger w-100">
                <i class="bi bi-person-plus me-2"></i>Create Account
            </button>
        </form>
        <div class="text-center mt-4 subtitle" style="animation: fadeInUp 0.6s ease 0.5s both;">
            Already have an account? <a href="login.jsp" class="link-accent ms-1">Sign in</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
