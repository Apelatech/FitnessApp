<?php
session_start();

$error = '';

// Handle login
if ($_POST['username'] ?? false) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // Simple authentication (in production, use proper authentication)
    if ($username === 'admin' && $password === 'admin123') {
        $_SESSION['admin_logged_in'] = true;
        header('Location: /dashboard');
        exit;
    } else {
        $error = 'Invalid username or password';
    }
}

// Redirect if already logged in
if ($_SESSION['admin_logged_in'] ?? false) {
    header('Location: /dashboard');
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Apelatech Fitness Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@200;300;400;500;600;700;800&family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --jet-black: #0A0A0A;
            --fire-orange: #FF5722;
            --sky-blue: #2196F3;
            --jet-black-light: #1A1A1A;
            --fire-orange-light: #FF6D3A;
            --sky-blue-light: #42A5F5;
        }
        
        * {
            font-family: 'Inter', sans-serif;
        }
        
        h1, h2, h3, h4, h5, h6, .manrope {
            font-family: 'Manrope', sans-serif !important;
        }
        
        body {
            background: linear-gradient(135deg, var(--jet-black) 0%, var(--jet-black-light) 50%, var(--sky-blue) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.25);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
            border: 1px solid rgba(255, 87, 34, 0.1);
        }
        
        .login-header {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            color: white;
            text-align: center;
            padding: 3rem 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: shimmer 3s ease-in-out infinite;
        }
        
        @keyframes shimmer {
            0%, 100% { transform: rotate(0deg); }
            50% { transform: rotate(180deg); }
        }
        
        .brand-logo {
            font-family: 'Manrope', sans-serif;
            font-weight: 800;
            font-size: 2.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 600;
            font-family: 'Manrope', sans-serif;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255, 87, 34, 0.4);
        }
        
        .form-control {
            border-radius: 12px;
            border: 2px solid #f1f3f4;
            padding: 14px 16px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--fire-orange);
            box-shadow: 0 0 0 0.2rem rgba(255, 87, 34, 0.25);
        }
        
        .form-label {
            font-weight: 600;
            color: var(--jet-black);
            font-family: 'Manrope', sans-serif;
        }
        
        .demo-card {
            background: linear-gradient(135deg, rgba(255, 87, 34, 0.1), rgba(33, 150, 243, 0.1));
            border: 2px solid rgba(255, 87, 34, 0.2);
            border-radius: 12px;
        }
        
        .demo-card .card-title {
            color: var(--fire-orange);
            font-family: 'Manrope', sans-serif;
            font-weight: 700;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, rgba(244, 67, 54, 0.1), rgba(255, 87, 34, 0.1));
            border: 1px solid var(--fire-orange);
            color: var(--fire-orange);
            border-radius: 12px;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <i class="fas fa-dumbbell fa-3x mb-3"></i>
            <div class="brand-logo">Apelatech</div>
            <p class="mb-0 mt-2" style="font-family: 'Inter', sans-serif; font-weight: 300;">Fitness Dashboard Admin</p>
        </div>
        <div class="p-4">
            <?php if ($error): ?>
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <?= htmlspecialchars($error) ?>
                </div>
            <?php endif; ?>
            
            <form method="POST">
                <div class="mb-3">
                    <label for="username" class="form-label">
                        <i class="fas fa-user me-2"></i>Username
                    </label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="mb-4">
                    <label for="password" class="form-label">
                        <i class="fas fa-lock me-2"></i>Password
                    </label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-sign-in-alt me-2"></i>Login
                </button>
            </form>
            
            <div class="text-center mt-4">
                <div class="card demo-card">
                    <div class="card-body">
                        <h6 class="card-title">Demo Credentials</h6>
                        <p class="card-text small">
                            <strong>Username:</strong> admin<br>
                            <strong>Password:</strong> admin123
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
