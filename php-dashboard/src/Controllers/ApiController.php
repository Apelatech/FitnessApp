<?php

namespace App\Controllers;

use App\Services\FirestoreService;

class ApiController
{
    private $firestoreService;

    public function __construct()
    {
        $this->firestoreService = new FirestoreService();
        header('Content-Type: application/json');
    }

    public function getUsers()
    {
        try {
            $limit = $_GET['limit'] ?? 100;
            $users = $this->firestoreService->getUsers((int)$limit);
            echo json_encode(['success' => true, 'data' => $users]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }

    public function getTracking()
    {
        try {
            $limit = $_GET['limit'] ?? 100;
            $userId = $_GET['userId'] ?? null;
            $tracking = $this->firestoreService->getDailyTracking((int)$limit, $userId);
            echo json_encode(['success' => true, 'data' => $tracking]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }

    public function getWorkouts()
    {
        try {
            $limit = $_GET['limit'] ?? 100;
            $userId = $_GET['userId'] ?? null;
            $workouts = $this->firestoreService->getWorkoutSessions((int)$limit, $userId);
            echo json_encode(['success' => true, 'data' => $workouts]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }
}
