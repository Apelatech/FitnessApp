<?php
session_start();

// Check if user is logged in
if (!isset($_SESSION['admin_logged_in'])) {
    header('Location: /login');
    exit;
}

// Sample data for testing
$sampleUsers = [
    ['uid' => 'user123', 'email' => 'john@example.com', 'displayName' => 'John Doe', 'createdAt' => '2024-01-15', 'lastSignIn' => '2024-08-10'],
    ['uid' => 'user456', 'email' => 'jane@example.com', 'displayName' => 'Jane Smith', 'createdAt' => '2024-02-20', 'lastSignIn' => '2024-08-11'],
    ['uid' => 'user789', 'email' => 'mike@example.com', 'displayName' => 'Mike Johnson', 'createdAt' => '2024-03-10', 'lastSignIn' => '2024-08-12'],
];

$sampleTracking = [
    ['date' => '2024-08-12', 'userId' => 'user123', 'waterIntake' => 2500, 'stepCount' => 8500, 'caloriesBurned' => 420, 'weight' => 75, 'sleepHours' => 7.5, 'updatedAt' => '2024-08-12 14:30:00'],
    ['date' => '2024-08-11', 'userId' => 'user456', 'waterIntake' => 3000, 'stepCount' => 12000, 'caloriesBurned' => 560, 'weight' => 68, 'sleepHours' => 8, 'updatedAt' => '2024-08-11 16:45:00'],
    ['date' => '2024-08-10', 'userId' => 'user789', 'waterIntake' => 2200, 'stepCount' => 6500, 'caloriesBurned' => 380, 'weight' => 82, 'sleepHours' => 6.5, 'updatedAt' => '2024-08-10 18:20:00'],
];

$sampleWorkouts = [
    [
        'id' => 'workout1',
        'userId' => 'user123',
        'workoutName' => 'Morning Cardio',
        'category' => 'cardio',
        'startTime' => '2024-08-12 07:00:00',
        'endTime' => '2024-08-12 07:45:00',
        'actualDuration' => 2700, // 45 minutes
        'estimatedDuration' => 2400, // 40 minutes
        'actualCalories' => 420,
        'estimatedCalories' => 380,
        'status' => 'completed',
        'completedExercises' => [
            ['exerciseName' => 'Running', 'duration' => 1800, 'caloriesBurned' => 280],
            ['exerciseName' => 'Cool Down', 'duration' => 900, 'caloriesBurned' => 140]
        ]
    ],
    [
        'id' => 'workout2',
        'userId' => 'user456',
        'workoutName' => 'Strength Training',
        'category' => 'strength',
        'startTime' => '2024-08-11 18:00:00',
        'endTime' => '2024-08-11 19:30:00',
        'actualDuration' => 5400, // 90 minutes
        'estimatedDuration' => 5400,
        'actualCalories' => 560,
        'estimatedCalories' => 520,
        'status' => 'completed',
        'completedExercises' => [
            ['exerciseName' => 'Squats', 'sets' => 3, 'repetitions' => 12, 'weight' => 60, 'caloriesBurned' => 180],
            ['exerciseName' => 'Bench Press', 'sets' => 3, 'repetitions' => 10, 'weight' => 80, 'caloriesBurned' => 200],
            ['exerciseName' => 'Deadlifts', 'sets' => 3, 'repetitions' => 8, 'weight' => 100, 'caloriesBurned' => 180]
        ]
    ]
];

$stats = [
    'totalUsers' => count($sampleUsers),
    'totalTracking' => count($sampleTracking),
    'totalWorkouts' => count($sampleWorkouts),
    'completedWorkouts' => count(array_filter($sampleWorkouts, fn($w) => $w['status'] === 'completed'))
];
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
                            <div class="text-muted">
                                <i class="fas fa-calendar me-1"></i>
                                <?= date('M j, Y') ?>
                            </div>
                        </div>
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
                                        <?php foreach (array_slice($sampleUsers, 0, 3) as $user): ?>
                                            <div class="d-flex align-items-center mb-2">
                                                <div class="me-3">
                                                    <i class="fas fa-user-circle fa-2x text-primary"></i>
                                                </div>
                                                <div>
                                                    <strong><?= htmlspecialchars($user['displayName']) ?></strong><br>
                                                    <small class="text-muted"><?= htmlspecialchars($user['email']) ?></small>
                                                </div>
                                            </div>
                                        <?php endforeach; ?>
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
                                        <?php foreach ($sampleWorkouts as $workout): ?>
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <div>
                                                    <strong><?= htmlspecialchars($workout['workoutName']) ?></strong><br>
                                                    <small class="text-muted"><?= ucfirst($workout['category']) ?> • <?= round($workout['actualDuration'] / 60) ?> min</small>
                                                </div>
                                                <span class="badge bg-success"><?= ucfirst($workout['status']) ?></span>
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Users Section -->
                    <div id="users" class="content-section" style="display: none;">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0">User Management</h6>
                            </div>
                            <div class="card-body">
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
                                            <?php foreach ($sampleUsers as $user): ?>
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-user-circle fa-2x text-primary me-3"></i>
                                                            <div>
                                                                <strong><?= htmlspecialchars($user['displayName']) ?></strong><br>
                                                                <small class="text-muted"><?= htmlspecialchars(substr($user['uid'], 0, 8)) ?>...</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><?= htmlspecialchars($user['email']) ?></td>
                                                    <td><?= date('M j, Y', strtotime($user['createdAt'])) ?></td>
                                                    <td><?= date('M j, Y', strtotime($user['lastSignIn'])) ?></td>
                                                    <td><span class="badge bg-success">Active</span></td>
                                                </tr>
                                            <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tracking Section -->
                    <div id="tracking" class="content-section" style="display: none;">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0">Daily Tracking Data</h6>
                            </div>
                            <div class="card-body">
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
                                            <?php foreach ($sampleTracking as $entry): ?>
                                                <tr>
                                                    <td><?= date('M j, Y', strtotime($entry['date'])) ?></td>
                                                    <td><code class="small"><?= htmlspecialchars(substr($entry['userId'], 0, 8)) ?>...</code></td>
                                                    <td><span class="badge bg-info"><?= number_format($entry['waterIntake']) ?></span></td>
                                                    <td><span class="badge bg-success"><?= number_format($entry['stepCount']) ?></span></td>
                                                    <td><span class="badge bg-warning"><?= $entry['caloriesBurned'] ?></span></td>
                                                    <td><span class="badge bg-primary"><?= $entry['weight'] ?></span></td>
                                                    <td><span class="badge bg-secondary"><?= $entry['sleepHours'] ?></span></td>
                                                </tr>
                                            <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Workouts Section -->
                    <div id="workouts" class="content-section" style="display: none;">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0">Workout Sessions</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Workout</th>
                                                <th>User</th>
                                                <th>Category</th>
                                                <th>Duration</th>
                                                <th>Calories</th>
                                                <th>Exercises</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach ($sampleWorkouts as $workout): ?>
                                                <tr>
                                                    <td>
                                                        <strong><?= htmlspecialchars($workout['workoutName']) ?></strong><br>
                                                        <small class="text-muted"><?= date('M j, Y H:i', strtotime($workout['startTime'])) ?></small>
                                                    </td>
                                                    <td><code class="small"><?= htmlspecialchars(substr($workout['userId'], 0, 8)) ?>...</code></td>
                                                    <td><span class="badge bg-primary"><?= ucfirst($workout['category']) ?></span></td>
                                                    <td><?= round($workout['actualDuration'] / 60) ?> min</td>
                                                    <td><?= $workout['actualCalories'] ?></td>
                                                    <td><?= count($workout['completedExercises']) ?> exercises</td>
                                                    <td><span class="badge bg-success"><?= ucfirst($workout['status']) ?></span></td>
                                                </tr>
                                            <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>
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
