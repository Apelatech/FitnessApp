<?php

namespace App\Controllers;

use App\Services\FirestoreService;

class DashboardController
{
    private $firestoreService;

    public function __construct()
    {
        $this->firestoreService = new FirestoreService();
    }

    public function index()
    {
        try {
            $stats = $this->firestoreService->getStats();
            $recentUsers = $this->firestoreService->getUsers(5);
            $recentWorkouts = $this->firestoreService->getWorkoutSessions(5);
            $recentTracking = $this->firestoreService->getDailyTracking(5);

            include __DIR__ . '/../Views/dashboard.php';
        } catch (Exception $e) {
            $_SESSION['error'] = 'Error loading dashboard: ' . $e->getMessage();
            include __DIR__ . '/../Views/dashboard.php';
        }
    }

    public function users()
    {
        try {
            $users = $this->firestoreService->getUsers(50);
            include __DIR__ . '/../Views/users.php';
        } catch (Exception $e) {
            $_SESSION['error'] = 'Error loading users: ' . $e->getMessage();
            $users = [];
            include __DIR__ . '/../Views/users.php';
        }
    }

    public function tracking()
    {
        try {
            $userId = $_GET['userId'] ?? null;
            $tracking = $this->firestoreService->getDailyTracking(100, $userId);
            include __DIR__ . '/../Views/tracking.php';
        } catch (Exception $e) {
            $_SESSION['error'] = 'Error loading tracking data: ' . $e->getMessage();
            $tracking = [];
            include __DIR__ . '/../Views/tracking.php';
        }
    }

    public function workouts()
    {
        try {
            $userId = $_GET['userId'] ?? null;
            $workouts = $this->firestoreService->getWorkoutSessions(100, $userId);
            include __DIR__ . '/../Views/workouts.php';
        } catch (Exception $e) {
            $_SESSION['error'] = 'Error loading workout sessions: ' . $e->getMessage();
            $workouts = [];
            include __DIR__ . '/../Views/workouts.php';
        }
    }
}
