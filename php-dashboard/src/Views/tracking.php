<?php
$currentPage = 'tracking';
$pageTitle = 'Daily Tracking Data';
$title = 'Daily Tracking - Fitness App Dashboard';

ob_start();
?>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-info">
                    <i class="fas fa-chart-line me-2"></i>Daily Tracking Data
                </h6>
                <div class="btn-group">
                    <button type="button" class="btn btn-sm btn-outline-info" onclick="exportTracking()">
                        <i class="fas fa-download me-1"></i>Export
                    </button>
                    <button type="button" class="btn btn-sm btn-info" onclick="location.reload()">
                        <i class="fas fa-sync-alt me-1"></i>Refresh
                    </button>
                </div>
            </div>
            <div class="card-body">
                <?php if (!empty($tracking)): ?>
                    <!-- Filters -->
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                <input type="date" class="form-control" id="dateFilter" placeholder="Filter by date">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="userFilter" placeholder="Filter by user ID">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="metricFilter">
                                <option value="">All Metrics</option>
                                <option value="water">Water Intake</option>
                                <option value="steps">Step Count</option>
                                <option value="calories">Calories Burned</option>
                                <option value="weight">Weight</option>
                                <option value="sleep">Sleep Hours</option>
                            </select>
                        </div>
                    </div>

                    <!-- Summary Statistics -->
                    <div class="row mb-4">
                        <?php
                        $totalWater = array_sum(array_column($tracking, 'waterIntake'));
                        $totalSteps = array_sum(array_column($tracking, 'stepCount'));
                        $totalCalories = array_sum(array_column($tracking, 'caloriesBurned'));
                        $avgWeight = count($tracking) > 0 ? array_sum(array_column($tracking, 'weight')) / count($tracking) : 0;
                        ?>
                        <div class="col-md-3">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <h5><?= number_format($totalWater) ?> ml</h5>
                                    <p class="mb-0">Total Water</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <h5><?= number_format($totalSteps) ?></h5>
                                    <p class="mb-0">Total Steps</p>
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
                        <div class="col-md-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body text-center">
                                    <h5><?= number_format($avgWeight, 1) ?> kg</h5>
                                    <p class="mb-0">Avg Weight</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tracking Data Table -->
                    <div class="table-responsive">
                        <table class="table table-hover" id="trackingTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Date</th>
                                    <th>User ID</th>
                                    <th>Water (ml)</th>
                                    <th>Steps</th>
                                    <th>Calories</th>
                                    <th>Weight (kg)</th>
                                    <th>Sleep (hrs)</th>
                                    <th>Notes</th>
                                    <th>Last Updated</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($tracking as $entry): ?>
                                    <tr data-date="<?= htmlspecialchars($entry['date']) ?>" data-user="<?= htmlspecialchars($entry['userId']) ?>">
                                        <td>
                                            <strong><?= date('M j, Y', strtotime($entry['date'])) ?></strong>
                                        </td>
                                        <td>
                                            <code class="small"><?= htmlspecialchars(substr($entry['userId'], 0, 8)) ?>...</code>
                                        </td>
                                        <td data-metric="water">
                                            <div class="d-flex align-items-center">
                                                <div class="progress me-2" style="width: 60px; height: 8px;">
                                                    <div class="progress-bar bg-info" style="width: <?= min(100, ($entry['waterIntake'] / 3000) * 100) ?>%"></div>
                                                </div>
                                                <span class="badge bg-info"><?= $entry['waterIntake'] ?? 0 ?></span>
                                            </div>
                                        </td>
                                        <td data-metric="steps">
                                            <div class="d-flex align-items-center">
                                                <div class="progress me-2" style="width: 60px; height: 8px;">
                                                    <div class="progress-bar bg-success" style="width: <?= min(100, ($entry['stepCount'] / 10000) * 100) ?>%"></div>
                                                </div>
                                                <span class="badge bg-success"><?= number_format($entry['stepCount'] ?? 0) ?></span>
                                            </div>
                                        </td>
                                        <td data-metric="calories">
                                            <div class="d-flex align-items-center">
                                                <div class="progress me-2" style="width: 60px; height: 8px;">
                                                    <div class="progress-bar bg-warning" style="width: <?= min(100, ($entry['caloriesBurned'] / 500) * 100) ?>%"></div>
                                                </div>
                                                <span class="badge bg-warning"><?= $entry['caloriesBurned'] ?? 0 ?></span>
                                            </div>
                                        </td>
                                        <td data-metric="weight">
                                            <?php if ($entry['weight'] > 0): ?>
                                                <span class="badge bg-primary"><?= $entry['weight'] ?></span>
                                            <?php else: ?>
                                                <span class="text-muted">-</span>
                                            <?php endif; ?>
                                        </td>
                                        <td data-metric="sleep">
                                            <?php if ($entry['sleepHours'] > 0): ?>
                                                <div class="d-flex align-items-center">
                                                    <div class="progress me-2" style="width: 40px; height: 8px;">
                                                        <div class="progress-bar bg-secondary" style="width: <?= min(100, ($entry['sleepHours'] / 8) * 100) ?>%"></div>
                                                    </div>
                                                    <span class="badge bg-secondary"><?= $entry['sleepHours'] ?></span>
                                                </div>
                                            <?php else: ?>
                                                <span class="text-muted">-</span>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <?php if (!empty($entry['notes'])): ?>
                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                        data-bs-toggle="tooltip" 
                                                        title="<?= htmlspecialchars(json_encode($entry['notes'])) ?>">
                                                    <i class="fas fa-sticky-note"></i>
                                                </button>
                                            <?php else: ?>
                                                <span class="text-muted">-</span>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <?= date('M j, H:i', strtotime($entry['updatedAt'])) ?>
                                            </small>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination would go here -->
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div>
                            <small class="text-muted">Showing <?= count($tracking) ?> entries</small>
                        </div>
                        <div>
                            <nav aria-label="Tracking pagination">
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
                        <i class="fas fa-chart-line fa-4x text-muted mb-3"></i>
                        <h5 class="text-muted">No tracking data found</h5>
                        <p class="text-muted">Daily tracking data will appear here once users start logging their activities.</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<script>
// Filter by date
document.getElementById('dateFilter').addEventListener('change', function(e) {
    const selectedDate = e.target.value;
    const rows = document.querySelectorAll('#trackingTable tbody tr');
    
    rows.forEach(row => {
        if (!selectedDate) {
            row.style.display = '';
            return;
        }
        
        const rowDate = row.getAttribute('data-date').split(' ')[0]; // Get just the date part
        if (rowDate.includes(selectedDate)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Filter by user
document.getElementById('userFilter').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#trackingTable tbody tr');
    
    rows.forEach(row => {
        const userId = row.getAttribute('data-user').toLowerCase();
        
        if (!searchTerm || userId.includes(searchTerm)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Filter by metric (highlight specific columns)
document.getElementById('metricFilter').addEventListener('change', function(e) {
    const selectedMetric = e.target.value;
    const cells = document.querySelectorAll('#trackingTable td[data-metric]');
    
    // Reset all cells
    cells.forEach(cell => {
        cell.style.backgroundColor = '';
        cell.style.fontWeight = '';
    });
    
    if (selectedMetric) {
        const targetCells = document.querySelectorAll(`#trackingTable td[data-metric="${selectedMetric}"]`);
        targetCells.forEach(cell => {
            cell.style.backgroundColor = '#e3f2fd';
            cell.style.fontWeight = 'bold';
        });
    }
});

// Export tracking data
function exportTracking() {
    alert('Export functionality would be implemented here');
}

// Initialize tooltips
var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
});
</script>

<?php
$content = ob_get_clean();
include __DIR__ . '/layout.php';
?>
