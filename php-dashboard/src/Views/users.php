<?php
$currentPage = 'users';
$pageTitle = 'Users Management';
$title = 'Users - Fitness App Dashboard';

ob_start();
?>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary">
                    <i class="fas fa-users me-2"></i>All Users
                </h6>
                <div class="btn-group">
                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="exportUsers()">
                        <i class="fas fa-download me-1"></i>Export
                    </button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="location.reload()">
                        <i class="fas fa-sync-alt me-1"></i>Refresh
                    </button>
                </div>
            </div>
            <div class="card-body">
                <?php if (!empty($users)): ?>
                    <!-- Search and Filter -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control" id="searchUsers" placeholder="Search users by name or email...">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <select class="form-select" id="filterVerification">
                                <option value="">All Users</option>
                                <option value="verified">Verified Only</option>
                                <option value="unverified">Unverified Only</option>
                            </select>
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="table-responsive">
                        <table class="table table-hover" id="usersTable">
                            <thead class="table-light">
                                <tr>
                                    <th>User</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Joined</th>
                                    <th>Last Sign In</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($users as $user): ?>
                                    <tr data-user-id="<?= htmlspecialchars($user['uid'] ?? '') ?>">
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar me-3">
                                                    <?php if (!empty($user['photoURL'])): ?>
                                                        <img src="<?= htmlspecialchars($user['photoURL']) ?>" class="rounded-circle" width="40" height="40">
                                                    <?php else: ?>
                                                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                            <?= strtoupper(substr($user['displayName'] ?? $user['email'] ?? 'U', 0, 1)) ?>
                                                        </div>
                                                    <?php endif; ?>
                                                </div>
                                                <div>
                                                    <div class="font-weight-bold"><?= htmlspecialchars($user['displayName'] ?? 'Unknown User') ?></div>
                                                    <small class="text-muted"><?= htmlspecialchars($user['uid'] ?? '') ?></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="user-email"><?= htmlspecialchars($user['email'] ?? 'N/A') ?></span>
                                        </td>
                                        <td>
                                            <?php if ($user['isEmailVerified'] ?? false): ?>
                                                <span class="badge bg-success user-verification" data-verified="true">
                                                    <i class="fas fa-check-circle me-1"></i>Verified
                                                </span>
                                            <?php else: ?>
                                                <span class="badge bg-warning user-verification" data-verified="false">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>Unverified
                                                </span>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <?php 
                                            if (isset($user['createdAt'])) {
                                                echo date('M j, Y', $user['createdAt']->get()->getTimestamp());
                                            } else {
                                                echo 'N/A';
                                            }
                                            ?>
                                        </td>
                                        <td>
                                            <?php 
                                            if (isset($user['lastSignIn'])) {
                                                echo date('M j, Y H:i', $user['lastSignIn']->get()->getTimestamp());
                                            } else {
                                                echo 'Never';
                                            }
                                            ?>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button type="button" class="btn btn-sm btn-outline-info" onclick="viewUserTracking('<?= htmlspecialchars($user['uid'] ?? '') ?>')">
                                                    <i class="fas fa-chart-line"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-outline-success" onclick="viewUserWorkouts('<?= htmlspecialchars($user['uid'] ?? '') ?>')">
                                                    <i class="fas fa-dumbbell"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="viewUserDetails('<?= htmlspecialchars($user['uid'] ?? '') ?>')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- User Statistics -->
                    <div class="row mt-4">
                        <div class="col-md-4">
                            <div class="card bg-light">
                                <div class="card-body text-center">
                                    <h5><?= count($users) ?></h5>
                                    <p class="mb-0">Total Users</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <h5><?= count(array_filter($users, fn($u) => $u['isEmailVerified'] ?? false)) ?></h5>
                                    <p class="mb-0">Verified Users</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <h5><?= count(array_filter($users, fn($u) => !($u['isEmailVerified'] ?? false))) ?></h5>
                                    <p class="mb-0">Unverified Users</p>
                                </div>
                            </div>
                        </div>
                    </div>

                <?php else: ?>
                    <div class="text-center py-5">
                        <i class="fas fa-users fa-4x text-muted mb-3"></i>
                        <h5 class="text-muted">No users found</h5>
                        <p class="text-muted">Users will appear here once they start using the app.</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<!-- User Details Modal -->
<div class="modal fade" id="userDetailsModal" tabindex="-1" aria-labelledby="userDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="userDetailsModalLabel">User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="userDetailsContent">
                <!-- User details will be loaded here -->
            </div>
        </div>
    </div>
</div>

<script>
// Search functionality
document.getElementById('searchUsers').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#usersTable tbody tr');
    
    rows.forEach(row => {
        const name = row.querySelector('.font-weight-bold').textContent.toLowerCase();
        const email = row.querySelector('.user-email').textContent.toLowerCase();
        
        if (name.includes(searchTerm) || email.includes(searchTerm)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// Filter by verification status
document.getElementById('filterVerification').addEventListener('change', function(e) {
    const filterValue = e.target.value;
    const rows = document.querySelectorAll('#usersTable tbody tr');
    
    rows.forEach(row => {
        if (!filterValue) {
            row.style.display = '';
            return;
        }
        
        const isVerified = row.querySelector('.user-verification').getAttribute('data-verified') === 'true';
        
        if ((filterValue === 'verified' && isVerified) || (filterValue === 'unverified' && !isVerified)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});

// View user tracking
function viewUserTracking(userId) {
    window.location.href = `/tracking?userId=${userId}`;
}

// View user workouts
function viewUserWorkouts(userId) {
    window.location.href = `/workouts?userId=${userId}`;
}

// View user details
function viewUserDetails(userId) {
    // This would typically make an AJAX request to get detailed user info
    document.getElementById('userDetailsContent').innerHTML = `
        <div class="text-center">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Loading user details...</p>
        </div>
    `;
    
    const modal = new bootstrap.Modal(document.getElementById('userDetailsModal'));
    modal.show();
    
    // Simulate API call
    setTimeout(() => {
        document.getElementById('userDetailsContent').innerHTML = `
            <div class="alert alert-info">
                <h6>User ID: ${userId}</h6>
                <p>Detailed user information would be displayed here.</p>
                <p>This would include profile details, activity history, preferences, etc.</p>
            </div>
        `;
    }, 1000);
}

// Export users
function exportUsers() {
    alert('Export functionality would be implemented here');
}
</script>

<?php
$content = ob_get_clean();
include __DIR__ . '/layout.php';
?>
