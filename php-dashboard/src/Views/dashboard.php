<?php
$currentPage = 'dashboard';
$pageTitle = 'Dashboard Overview';
$title = 'Dashboard - Fitness App';

ob_start();
?>

<!-- Stats Cards -->
<div class="row mb-4">
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stats-card h-100">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Total Users</div>
                        <div class="h5 mb-0 font-weight-bold"><?= $stats['totalUsers'] ?? 0 ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-users fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stats-card success h-100">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Completed Workouts</div>
                        <div class="h5 mb-0 font-weight-bold"><?= $stats['completedWorkouts'] ?? 0 ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-dumbbell fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stats-card warning h-100">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Total Sessions</div>
                        <div class="h5 mb-0 font-weight-bold"><?= $stats['totalWorkoutSessions'] ?? 0 ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-play-circle fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stats-card danger h-100">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Tracking Entries</div>
                        <div class="h5 mb-0 font-weight-bold"><?= $stats['totalTrackingEntries'] ?? 0 ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-chart-line fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Recent Activity -->
<div class="row">
    <!-- Recent Users -->
    <div class="col-lg-6 mb-4">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary">
                    <i class="fas fa-users me-2"></i>Recent Users
                </h6>
                <a href="/users" class="btn btn-sm btn-primary">View All</a>
            </div>
            <div class="card-body">
                <?php if (!empty($recentUsers)): ?>
                    <div class="table-responsive">
                        <table class="table table-borderless">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Joined</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($recentUsers as $user): ?>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar me-2">
                                                    <?php if (!empty($user['photoURL'])): ?>
                                                        <img src="<?= htmlspecialchars($user['photoURL']) ?>" class="rounded-circle" width="32" height="32">
                                                    <?php else: ?>
                                                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 14px;">
                                                            <?= strtoupper(substr($user['displayName'] ?? $user['email'] ?? 'U', 0, 1)) ?>
                                                        </div>
                                                    <?php endif; ?>
                                                </div>
                                                <span><?= htmlspecialchars($user['displayName'] ?? 'Unknown') ?></span>
                                            </div>
                                        </td>
                                        <td><?= htmlspecialchars($user['email'] ?? 'N/A') ?></td>
                                        <td>
                                            <?php 
                                            if (isset($user['createdAt'])) {
                                                echo date('M j, Y', $user['createdAt']->get()->getTimestamp());
                                            } else {
                                                echo 'N/A';
                                            }
                                            ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else: ?>
                    <p class="text-muted text-center">No users found</p>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Recent Workouts -->
    <div class="col-lg-6 mb-4">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-success">
                    <i class="fas fa-dumbbell me-2"></i>Recent Workouts
                </h6>
                <a href="/workouts" class="btn btn-sm btn-success">View All</a>
            </div>
            <div class="card-body">
                <?php if (!empty($recentWorkouts)): ?>
                    <div class="table-responsive">
                        <table class="table table-borderless">
                            <thead>
                                <tr>
                                    <th>Workout</th>
                                    <th>Status</th>
                                    <th>Duration</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($recentWorkouts as $workout): ?>
                                    <tr>
                                        <td>
                                            <div>
                                                <div class="font-weight-bold"><?= htmlspecialchars($workout['workoutName'] ?? 'Unknown') ?></div>
                                                <small class="text-muted"><?= htmlspecialchars($workout['category'] ?? 'N/A') ?></small>
                                            </div>
                                        </td>
                                        <td>
                                            <?php
                                            $status = $workout['status'] ?? 'unknown';
                                            $badgeClass = match($status) {
                                                'completed' => 'success',
                                                'in_progress' => 'primary',
                                                'paused' => 'warning',
                                                'cancelled' => 'danger',
                                                default => 'secondary'
                                            };
                                            ?>
                                            <span class="badge bg-<?= $badgeClass ?>"><?= ucfirst($status) ?></span>
                                        </td>
                                        <td><?= $workout['actualDuration'] ?? $workout['estimatedDuration'] ?? 0 ?> min</td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else: ?>
                    <p class="text-muted text-center">No recent workouts</p>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<!-- Recent Tracking -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-info">
                    <i class="fas fa-chart-line me-2"></i>Recent Daily Tracking
                </h6>
                <a href="/tracking" class="btn btn-sm btn-info">View All</a>
            </div>
            <div class="card-body">
                <?php if (!empty($recentTracking)): ?>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Water (ml)</th>
                                    <th>Steps</th>
                                    <th>Calories Burned</th>
                                    <th>Weight (kg)</th>
                                    <th>Sleep (hrs)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($recentTracking as $tracking): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($tracking['date']) ?></td>
                                        <td>
                                            <span class="badge bg-info"><?= $tracking['waterIntake'] ?? 0 ?></span>
                                        </td>
                                        <td>
                                            <span class="badge bg-success"><?= number_format($tracking['stepCount'] ?? 0) ?></span>
                                        </td>
                                        <td>
                                            <span class="badge bg-warning"><?= $tracking['caloriesBurned'] ?? 0 ?></span>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary"><?= $tracking['weight'] ?? 0 ?></span>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary"><?= $tracking['sleepHours'] ?? 0 ?></span>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else: ?>
                    <p class="text-muted text-center">No tracking data available</p>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<?php
$content = ob_get_clean();
include __DIR__ . '/layout.php';
?>
