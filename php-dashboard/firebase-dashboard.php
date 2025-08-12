<?php
// Firebase Dashboard with Real Data
error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

// Check if user is logged in
if (!isset($_SESSION['admin_logged_in'])) {
    header('Location: /login');
    exit;
}

// Load environment variables and Firebase REST client
require_once 'config/env.php';
require_once 'firebase-simple.php';

try {
    // Initialize Firebase REST connection
    $firebaseClient = new FirebaseSimpleClient();
    
    // Test connection first
    if (!$firebaseClient->testConnection()) {
        throw new Exception("Failed to authenticate with Firebase");
    }
    
    // Fetch real data from Firestore
    $users = $firebaseClient->getCollection('users');
    $tracking = $firebaseClient->getCollection('daily_tracking');
    $workouts = $firebaseClient->getCollection('workout_sessions');
    
    // Calculate statistics
    $stats = [
        'totalUsers' => count($users),
        'totalTracking' => count($tracking),
        'totalWorkouts' => count($workouts),
        'completedWorkouts' => count(array_filter($workouts, fn($w) => ($w['status'] ?? '') === 'completed'))
    ];
    
    $dataSource = "Firebase Firestore";
    $hasFirebaseData = true;
    
} catch (Exception $e) {
    // Fallback to sample data if Firebase connection fails
    error_log("Firebase connection failed: " . $e->getMessage());
    
    // Sample data as fallback
    $users = [
        ['uid' => 'sample_user_1', 'email' => 'demo@apelatech.com', 'displayName' => 'Demo User', 'createdAt' => '2024-01-15', 'lastSignIn' => '2024-08-10'],
        ['uid' => 'sample_user_2', 'email' => 'test@apelatech.com', 'displayName' => 'Test User', 'createdAt' => '2024-02-20', 'lastSignIn' => '2024-08-11'],
    ];
    
    $tracking = [
        ['date' => '2024-08-12', 'userId' => 'sample_user_1', 'waterIntake' => 2500, 'stepCount' => 8500, 'caloriesBurned' => 420, 'weight' => 75, 'sleepHours' => 7.5],
    ];
    
    $workouts = [
        ['id' => 'sample_workout', 'userId' => 'sample_user_1', 'workoutName' => 'Sample Workout', 'category' => 'cardio', 'status' => 'completed', 'actualDuration' => 2700, 'actualCalories' => 420],
    ];
    
    $stats = [
        'totalUsers' => count($users),
        'totalTracking' => count($tracking),
        'totalWorkouts' => count($workouts),
        'completedWorkouts' => count(array_filter($workouts, fn($w) => ($w['status'] ?? '') === 'completed'))
    ];
    
    $dataSource = "Sample Data (Firebase connection failed)";
    $hasFirebaseData = false;
    $errorMessage = $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apelatech Fitness Dashboard</title>
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
        
        .sidebar {
            background: linear-gradient(135deg, var(--jet-black) 0%, var(--jet-black-light) 50%, var(--sky-blue) 100%);
            min-height: 100vh;
            border-right: 3px solid var(--fire-orange);
        }
        
        .brand-logo {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-family: 'Manrope', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            text-decoration: none;
        }
        
        .nav-link {
            color: white !important;
            border-radius: 12px;
            margin: 4px 0;
            font-weight: 500;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }
        
        .nav-link:hover {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(255, 87, 34, 0.3);
        }
        
        .nav-link.active {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            box-shadow: 0 4px 15px rgba(255, 87, 34, 0.4);
        }
        
        .card {
            border: none;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            border-radius: 16px;
            border-left: 4px solid var(--fire-orange);
            transition: all 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-family: 'Manrope', sans-serif;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 87, 34, 0.4);
        }
        
        .bg-primary {
            background: linear-gradient(135deg, var(--sky-blue), var(--sky-blue-light)) !important;
        }
        
        .bg-success {
            background: linear-gradient(135deg, #4CAF50, #66BB6A) !important;
        }
        
        .bg-info {
            background: linear-gradient(135deg, var(--sky-blue), #29B6F6) !important;
        }
        
        .bg-warning {
            background: linear-gradient(135deg, var(--fire-orange), var(--fire-orange-light)) !important;
        }
        
        .text-primary {
            color: var(--sky-blue) !important;
        }
        
        .text-danger {
            color: var(--fire-orange) !important;
        }
        
        .badge {
            border-radius: 8px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
        }
        
        .table th {
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            color: var(--jet-black);
            border-bottom: 2px solid var(--fire-orange);
        }
        
        .main-header {
            background: linear-gradient(135deg, rgba(255, 87, 34, 0.1), rgba(33, 150, 243, 0.1));
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 5px solid var(--fire-orange);
        }
        
        .stat-card {
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: scale(1.05);
        }
        
        .apelatech-gradient {
            background: linear-gradient(135deg, var(--fire-orange), var(--sky-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .data-source-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
            border-radius: 12px;
        }
        
        .firebase-connected {
            background: linear-gradient(135deg, #4CAF50, #66BB6A);
            color: white;
        }
        
        .firebase-error {
            background: linear-gradient(135deg, var(--fire-orange), #FF6B3A);
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <div class="text-center mb-4">
                        <div class="brand-logo mb-2">
                            <i class="fas fa-dumbbell me-2"></i>
                            Apelatech
                        </div>
                        <small class="text-white-50 manrope">Fitness Dashboard</small>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a class="nav-link" href="#users">
                            <i class="fas fa-users me-2"></i>Users
                        </a>
                        <a class="nav-link" href="#tracking">
                            <i class="fas fa-chart-line me-2"></i>Daily Tracking
                        </a>
                        <a class="nav-link" href="#workouts">
                            <i class="fas fa-dumbbell me-2"></i>Workouts
                        </a>
                        <hr class="text-white-50">
                        <a class="nav-link" href="/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="p-4">
                    <!-- Header -->
                    <div class="main-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h2 class="manrope mb-1 apelatech-gradient">Dashboard Overview</h2>
                                <p class="text-muted mb-0">Monitor your fitness app performance</p>
                            </div>
                            <div class="d-flex align-items-center gap-3">
                                <span class="data-source-badge <?= $hasFirebaseData ? 'firebase-connected' : 'firebase-error' ?>">
                                    <i class="fas fa-database me-1"></i>
                                    <?= $dataSource ?>
                                </span>
                                <div class="text-muted">
                                    <i class="fas fa-calendar me-1"></i>
                                    <?= date('M j, Y') ?>
                                </div>
                            </div>
                        </div>
                        <?php if (!$hasFirebaseData): ?>
                            <div class="alert alert-warning mt-3 mb-0" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Firebase Connection Issue:</strong> <?= htmlspecialchars($errorMessage ?? 'Unknown error') ?>
                                <br><small>Displaying sample data. Please check your Firebase configuration in .env file.</small>
                            </div>
                        <?php endif; ?>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card bg-primary text-white stat-card">
                                <div class="card-body text-center">
                                    <i class="fas fa-users fa-2x mb-2"></i>
                                    <h4 class="manrope"><?= $stats['totalUsers'] ?></h4>
                                    <p class="mb-0">Total Users</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-success text-white stat-card">
                                <div class="card-body text-center">
                                    <i class="fas fa-chart-line fa-2x mb-2"></i>
                                    <h4 class="manrope"><?= $stats['totalTracking'] ?></h4>
                                    <p class="mb-0">Tracking Records</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-info text-white stat-card">
                                <div class="card-body text-center">
                                    <i class="fas fa-dumbbell fa-2x mb-2"></i>
                                    <h4 class="manrope"><?= $stats['totalWorkouts'] ?></h4>
                                    <p class="mb-0">Total Workouts</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-warning text-white stat-card">
                                <div class="card-body text-center">
                                    <i class="fas fa-check-circle fa-2x mb-2"></i>
                                    <h4 class="manrope"><?= $stats['completedWorkouts'] ?></h4>
                                    <p class="mb-0">Completed</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Content Sections -->
                    <div id="dashboard" class="content-section">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h6 class="m-0 manrope text-primary">
                                            <i class="fas fa-user-friends me-2"></i>Recent Users
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <?php if (empty($users)): ?>
                                            <p class="text-muted text-center">No users found</p>
                                        <?php else: ?>
                                            <?php foreach (array_slice($users, 0, 5) as $user): ?>
                                                <div class="d-flex align-items-center mb-2">
                                                    <div class="me-3">
                                                        <i class="fas fa-user-circle fa-2x text-primary"></i>
                                                    </div>
                                                    <div>
                                                        <strong><?= htmlspecialchars($user['displayName'] ?? 'Unknown') ?></strong><br>
                                                        <small class="text-muted"><?= htmlspecialchars($user['email'] ?? 'No email') ?></small>
                                                    </div>
                                                </div>
                                            <?php endforeach; ?>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h6 class="m-0 manrope text-primary">
                                            <i class="fas fa-dumbbell me-2"></i>Recent Workouts
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <?php if (empty($workouts)): ?>
                                            <p class="text-muted text-center">No workouts found</p>
                                        <?php else: ?>
                                            <?php foreach (array_slice($workouts, 0, 5) as $workout): ?>
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div>
                                                        <strong><?= htmlspecialchars($workout['workoutName'] ?? 'Unknown Workout') ?></strong><br>
                                                        <small class="text-muted">
                                                            <?= ucfirst($workout['category'] ?? 'unknown') ?> • 
                                                            <?= isset($workout['actualDuration']) ? round($workout['actualDuration'] / 60) . ' min' : 'Duration unknown' ?>
                                                        </small>
                                                    </div>
                                                    <span class="badge bg-success"><?= ucfirst($workout['status'] ?? 'unknown') ?></span>
                                                </div>
                                            <?php endforeach; ?>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Users Section -->
                    <div id="users" class="content-section" style="display: none;">
                        <div class="card">
                            <div class="card-header bg-light">
                                <h6 class="m-0 manrope text-primary">
                                    <i class="fas fa-users me-2"></i>User Management
                                </h6>
                            </div>
                            <div class="card-body">
                                <?php if (empty($users)): ?>
                                    <div class="text-center py-5">
                                        <i class="fas fa-users fa-4x text-muted mb-3"></i>
                                        <h5 class="text-muted">No users found</h5>
                                        <p class="text-muted">Users will appear here once they register in your app.</p>
                                    </div>
                                <?php else: ?>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>User</th>
                                                    <th>Email</th>
                                                    <th>Created</th>
                                                    <th>Last Sign In</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach ($users as $user): ?>
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <i class="fas fa-user-circle fa-2x text-primary me-3"></i>
                                                                <div>
                                                                    <strong><?= htmlspecialchars($user['displayName'] ?? 'Unknown') ?></strong><br>
                                                                    <small class="text-muted"><?= htmlspecialchars(substr($user['uid'] ?? '', 0, 8)) ?>...</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><?= htmlspecialchars($user['email'] ?? 'No email') ?></td>
                                                        <td>
                                                            <?php 
                                                            $createdAt = $user['createdAt'] ?? null;
                                                            if ($createdAt) {
                                                                if (is_object($createdAt) && method_exists($createdAt, 'toDateTime')) {
                                                                    echo $createdAt->toDateTime()->format('M j, Y');
                                                                } else {
                                                                    echo date('M j, Y', strtotime($createdAt));
                                                                }
                                                            } else {
                                                                echo 'Unknown';
                                                            }
                                                            ?>
                                                        </td>
                                                        <td>
                                                            <?php 
                                                            $lastSignIn = $user['lastSignIn'] ?? null;
                                                            if ($lastSignIn) {
                                                                if (is_object($lastSignIn) && method_exists($lastSignIn, 'toDateTime')) {
                                                                    echo $lastSignIn->toDateTime()->format('M j, Y');
                                                                } else {
                                                                    echo date('M j, Y', strtotime($lastSignIn));
                                                                }
                                                            } else {
                                                                echo 'Never';
                                                            }
                                                            ?>
                                                        </td>
                                                        <td>
                                                            <?php 
                                                            $isEmailVerified = $user['isEmailVerified'] ?? false;
                                                            if ($isEmailVerified) {
                                                                echo '<span class="badge bg-success">Verified</span>';
                                                            } else {
                                                                echo '<span class="badge bg-warning">Unverified</span>';
                                                            }
                                                            ?>
                                                        </td>
                                                    </tr>
                                                <?php endforeach; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>

                    <!-- Tracking Section -->
                    <div id="tracking" class="content-section" style="display: none;">
                        <div class="card">
                            <div class="card-header bg-light">
                                <h6 class="m-0 manrope text-primary">
                                    <i class="fas fa-chart-line me-2"></i>Daily Tracking Data
                                </h6>
                            </div>
                            <div class="card-body">
                                <?php if (empty($tracking)): ?>
                                    <div class="text-center py-5">
                                        <i class="fas fa-chart-line fa-4x text-muted mb-3"></i>
                                        <h5 class="text-muted">No tracking data found</h5>
                                        <p class="text-muted">Daily tracking data will appear here once users start logging activities.</p>
                                    </div>
                                <?php else: ?>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Date</th>
                                                    <th>User</th>
                                                    <th>Water (ml)</th>
                                                    <th>Steps</th>
                                                    <th>Calories</th>
                                                    <th>Weight (kg)</th>
                                                    <th>Sleep (hrs)</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach ($tracking as $entry): ?>
                                                    <tr>
                                                        <td><?= htmlspecialchars($entry['date'] ?? 'Unknown') ?></td>
                                                        <td><code class="small"><?= htmlspecialchars(substr($entry['userId'] ?? '', 0, 8)) ?>...</code></td>
                                                        <td><span class="badge bg-info"><?= number_format($entry['waterIntake'] ?? 0) ?></span></td>
                                                        <td><span class="badge bg-success"><?= number_format($entry['stepCount'] ?? 0) ?></span></td>
                                                        <td><span class="badge bg-warning"><?= $entry['caloriesBurned'] ?? 0 ?></span></td>
                                                        <td><span class="badge bg-primary"><?= $entry['weight'] ?? 0 ?></span></td>
                                                        <td><span class="badge bg-secondary"><?= $entry['sleepHours'] ?? 0 ?></span></td>
                                                    </tr>
                                                <?php endforeach; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>

                    <!-- Workouts Section -->
                    <div id="workouts" class="content-section" style="display: none;">
                        <div class="card">
                            <div class="card-header bg-light">
                                <h6 class="m-0 manrope text-primary">
                                    <i class="fas fa-dumbbell me-2"></i>Workout Sessions
                                </h6>
                            </div>
                            <div class="card-body">
                                <?php if (empty($workouts)): ?>
                                    <div class="text-center py-5">
                                        <i class="fas fa-dumbbell fa-4x text-muted mb-3"></i>
                                        <h5 class="text-muted">No workout sessions found</h5>
                                        <p class="text-muted">Workout sessions will appear here once users start working out.</p>
                                    </div>
                                <?php else: ?>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Workout</th>
                                                    <th>User</th>
                                                    <th>Category</th>
                                                    <th>Duration</th>
                                                    <th>Calories</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach ($workouts as $workout): ?>
                                                    <tr>
                                                        <td>
                                                            <strong><?= htmlspecialchars($workout['workoutName'] ?? 'Unknown Workout') ?></strong><br>
                                                            <?php if (isset($workout['startTime'])): ?>
                                                                <small class="text-muted">
                                                                    <?php 
                                                                    if (is_object($workout['startTime']) && method_exists($workout['startTime'], 'toDateTime')) {
                                                                        echo $workout['startTime']->toDateTime()->format('M j, Y H:i');
                                                                    } else {
                                                                        echo date('M j, Y H:i', strtotime($workout['startTime']));
                                                                    }
                                                                    ?>
                                                                </small>
                                                            <?php endif; ?>
                                                        </td>
                                                        <td><code class="small"><?= htmlspecialchars(substr($workout['userId'] ?? '', 0, 8)) ?>...</code></td>
                                                        <td><span class="badge bg-primary"><?= ucfirst($workout['category'] ?? 'unknown') ?></span></td>
                                                        <td><?= isset($workout['actualDuration']) ? round($workout['actualDuration'] / 60) . ' min' : 'Unknown' ?></td>
                                                        <td><?= $workout['actualCalories'] ?? 0 ?></td>
                                                        <td><span class="badge bg-success"><?= ucfirst($workout['status'] ?? 'unknown') ?></span></td>
                                                    </tr>
                                                <?php endforeach; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Simple tab switching
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', function(e) {
                if (this.getAttribute('href').startsWith('#')) {
                    e.preventDefault();
                    
                    // Remove active class from all nav links
                    document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
                    this.classList.add('active');
                    
                    // Hide all content sections
                    document.querySelectorAll('.content-section').forEach(section => {
                        section.style.display = 'none';
                    });
                    
                    // Show selected section
                    const targetId = this.getAttribute('href').substring(1);
                    const targetSection = document.getElementById(targetId);
                    if (targetSection) {
                        targetSection.style.display = 'block';
                    }
                }
            });
        });
    </script>
</body>
</html>
