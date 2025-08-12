<?php
$currentPage = 'workouts';
$pageTitle = 'Workout Sessions';
$title = 'Workouts - Fitness App Dashboard';

ob_start();
?>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-success">
                    <i class="fas fa-dumbbell me-2"></i>Workout Sessions
                </h6>
                <div class="btn-group">
                    <button type="button" class="btn btn-sm btn-outline-success" onclick="exportWorkouts()">
                        <i class="fas fa-download me-1"></i>Export
                    </button>
                    <button type="button" class="btn btn-sm btn-success" onclick="location.reload()">
                        <i class="fas fa-sync-alt me-1"></i>Refresh
                    </button>
                </div>
            </div>
            <div class="card-body">
                <?php if (!empty($workouts)): ?>
                    <!-- Filters -->
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="userFilter" placeholder="Filter by user">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="categoryFilter">
                                <option value="">All Categories</option>
                                <option value="strength">Strength</option>
                                <option value="cardio">Cardio</option>
                                <option value="flexibility">Flexibility</option>
                                <option value="sports">Sports</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">All Status</option>
                                <option value="completed">Completed</option>
                                <option value="paused">Paused</option>
                                <option value="cancelled">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                <input type="date" class="form-control" id="dateFilter">
                            </div>
                        </div>
                    </div>

                    <!-- Workout Statistics -->
                    <div class="row mb-4">
                        <?php
                        $totalWorkouts = count($workouts);
                        $completedWorkouts = array_filter($workouts, fn($w) => $w['status'] === 'completed');
                        $totalDuration = array_sum(array_column($completedWorkouts, 'actualDuration'));
                        $totalCalories = array_sum(array_column($completedWorkouts, 'actualCalories'));
                        ?>
                        <div class="col-md-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <h5><?= $totalWorkouts ?></h5>
                                    <p class="mb-0">Total Workouts</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body text-center">
                                    <h5><?= count($completedWorkouts) ?></h5>
                                    <p class="mb-0">Completed</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <h5><?= round($totalDuration / 60) ?> hrs</h5>
                                    <p class="mb-0">Total Duration</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <h5><?= number_format($totalCalories) ?></h5>
                                    <p class="mb-0">Total Calories</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Workouts Table -->
                    <div class="table-responsive">
                        <table class="table table-hover" id="workoutTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Workout</th>
                                    <th>User</th>
                                    <th>Category</th>
                                    <th>Date/Time</th>
                                    <th>Duration</th>
                                    <th>Calories</th>
                                    <th>Exercises</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($workouts as $workout): ?>
                                    <tr data-user="<?= htmlspecialchars($workout['userId']) ?>" 
                                        data-category="<?= htmlspecialchars($workout['category']) ?>"
                                        data-status="<?= htmlspecialchars($workout['status']) ?>"
                                        data-date="<?= date('Y-m-d', strtotime($workout['startTime'])) ?>">
                                        <td>
                                            <div>
                                                <strong><?= htmlspecialchars($workout['workoutName']) ?></strong>
                                                <?php if (!empty($workout['workoutDescription'])): ?>
                                                    <br><small class="text-muted"><?= htmlspecialchars(substr($workout['workoutDescription'], 0, 50)) ?>...</small>
                                                <?php endif; ?>
                                            </div>
                                        </td>
                                        <td>
                                            <code class="small"><?= htmlspecialchars(substr($workout['userId'], 0, 8)) ?>...</code>
                                        </td>
                                        <td>
                                            <?php
                                            $categoryColors = [
                                                'strength' => 'bg-danger',
                                                'cardio' => 'bg-warning',
                                                'flexibility' => 'bg-info',
                                                'sports' => 'bg-success',
                                                'other' => 'bg-secondary'
                                            ];
                                            $colorClass = $categoryColors[$workout['category']] ?? 'bg-secondary';
                                            ?>
                                            <span class="badge <?= $colorClass ?>"><?= ucfirst($workout['category']) ?></span>
                                        </td>
                                        <td>
                                            <div>
                                                <strong><?= date('M j, Y', strtotime($workout['startTime'])) ?></strong>
                                                <br><small class="text-muted"><?= date('H:i', strtotime($workout['startTime'])) ?></small>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <?php if ($workout['actualDuration'] > 0): ?>
                                                    <strong class="text-success"><?= round($workout['actualDuration'] / 60) ?>m</strong>
                                                    <?php if ($workout['estimatedDuration'] > 0): ?>
                                                        <br><small class="text-muted">Est: <?= round($workout['estimatedDuration'] / 60) ?>m</small>
                                                    <?php endif; ?>
                                                <?php else: ?>
                                                    <span class="text-muted">-</span>
                                                <?php endif; ?>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <?php if ($workout['actualCalories'] > 0): ?>
                                                    <strong class="text-warning"><?= $workout['actualCalories'] ?></strong>
                                                    <?php if ($workout['estimatedCalories'] > 0): ?>
                                                        <br><small class="text-muted">Est: <?= $workout['estimatedCalories'] ?></small>
                                                    <?php endif; ?>
                                                <?php else: ?>
                                                    <span class="text-muted">-</span>
                                                <?php endif; ?>
                                            </div>
                                        </td>
                                        <td>
                                            <?php if (!empty($workout['completedExercises'])): ?>
                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                        onclick="showExercises('<?= htmlspecialchars(json_encode($workout['completedExercises'])) ?>')">
                                                    <i class="fas fa-list me-1"></i><?= count($workout['completedExercises']) ?> exercises
                                                </button>
                                            <?php else: ?>
                                                <span class="text-muted">No exercises</span>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <?php
                                            $statusColors = [
                                                'completed' => 'bg-success',
                                                'paused' => 'bg-warning',
                                                'cancelled' => 'bg-danger'
                                            ];
                                            $statusClass = $statusColors[$workout['status']] ?? 'bg-secondary';
                                            ?>
                                            <span class="badge <?= $statusClass ?>"><?= ucfirst($workout['status']) ?></span>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-outline-info" 
                                                        onclick="viewWorkoutDetails('<?= $workout['id'] ?>')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <?php if ($workout['status'] === 'completed'): ?>
                                                    <button type="button" class="btn btn-outline-success" 
                                                            onclick="exportWorkout('<?= $workout['id'] ?>')">
                                                        <i class="fas fa-download"></i>
                                                    </button>
                                                <?php endif; ?>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div>
                            <small class="text-muted">Showing <?= count($workouts) ?> workouts</small>
                        </div>
                        <div>
                            <nav aria-label="Workouts pagination">
                                <ul class="pagination pagination-sm">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                                    </li>
                                    <li class="page-item active">
                                        <a class="page-link" href="#">1</a>
                                    </li>
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>

                <?php else: ?>
                    <div class="text-center py-5">
                        <i class="fas fa-dumbbell fa-4x text-muted mb-3"></i>
                        <h5 class="text-muted">No workout sessions found</h5>
                        <p class="text-muted">Workout sessions will appear here once users start working out.</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<!-- Exercise Details Modal -->
<div class="modal fade" id="exerciseModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Workout Exercises</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="exerciseModalBody">
                <!-- Exercise details will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Workout Details Modal -->
<div class="modal fade" id="workoutModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Workout Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="workoutModalBody">
                <!-- Workout details will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
// Filter by user
document.getElementById('userFilter').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#workoutTable tbody tr');
    
    rows.forEach(row => {
        const userId = row.getAttribute('data-user').toLowerCase();
        
        if (!searchTerm || userId.includes(searchTerm)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Filter by category
document.getElementById('categoryFilter').addEventListener('change', function(e) {
    const selectedCategory = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#workoutTable tbody tr');
    
    rows.forEach(row => {
        const category = row.getAttribute('data-category').toLowerCase();
        
        if (!selectedCategory || category === selectedCategory) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Filter by status
document.getElementById('statusFilter').addEventListener('change', function(e) {
    const selectedStatus = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#workoutTable tbody tr');
    
    rows.forEach(row => {
        const status = row.getAttribute('data-status').toLowerCase();
        
        if (!selectedStatus || status === selectedStatus) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Filter by date
document.getElementById('dateFilter').addEventListener('change', function(e) {
    const selectedDate = e.target.value;
    const rows = document.querySelectorAll('#workoutTable tbody tr');
    
    rows.forEach(row => {
        const rowDate = row.getAttribute('data-date');
        
        if (!selectedDate || rowDate === selectedDate) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Show exercise details
function showExercises(exercisesJson) {
    try {
        const exercises = JSON.parse(exercisesJson);
        
        let html = '<div class="table-responsive"><table class="table table-sm">';
        html += '<thead><tr><th>Exercise</th><th>Sets</th><th>Reps</th><th>Weight</th><th>Duration</th><th>Calories</th></tr></thead>';
        html += '<tbody>';
        
        exercises.forEach(exercise => {
            html += '<tr>';
            html += '<td><strong>' + (exercise.exerciseName || 'Unknown') + '</strong>';
            if (exercise.notes) {
                html += '<br><small class="text-muted">' + exercise.notes + '</small>';
            }
            html += '</td>';
            html += '<td>' + (exercise.sets || '-') + '</td>';
            html += '<td>' + (exercise.repetitions || '-') + '</td>';
            html += '<td>' + (exercise.weight ? exercise.weight + ' kg' : '-') + '</td>';
            html += '<td>' + (exercise.duration ? Math.round(exercise.duration / 60) + ' min' : '-') + '</td>';
            html += '<td>' + (exercise.caloriesBurned || '-') + '</td>';
            html += '</tr>';
        });
        
        html += '</tbody></table></div>';
        
        document.getElementById('exerciseModalBody').innerHTML = html;
        new bootstrap.Modal(document.getElementById('exerciseModal')).show();
    } catch (e) {
        alert('Error loading exercise details');
    }
}

// View workout details
function viewWorkoutDetails(workoutId) {
    // In a real implementation, this would make an AJAX call to get full workout details
    document.getElementById('workoutModalBody').innerHTML = '<p>Loading workout details for ID: ' + workoutId + '</p>';
    new bootstrap.Modal(document.getElementById('workoutModal')).show();
}

// Export single workout
function exportWorkout(workoutId) {
    alert('Export workout functionality would be implemented here for workout: ' + workoutId);
}

// Export all workouts
function exportWorkouts() {
    alert('Export all workouts functionality would be implemented here');
}
</script>

<?php
$content = ob_get_clean();
include __DIR__ . '/layout.php';
?>
