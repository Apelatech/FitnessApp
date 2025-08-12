<?php

namespace App\Services;

use App\Config\Config;
use Google\Cloud\Firestore\FirestoreClient;

class FirestoreService
{
    private $firestore;

    public function __construct()
    {
        $config = Config::getInstance();
        $this->firestore = $config->getFirestore();
    }

    public function getUsers($limit = 100)
    {
        try {
            $usersRef = $this->firestore->collection('users');
            $query = $usersRef->limit($limit)->orderBy('createdAt', 'DESC');
            $documents = $query->documents();

            $users = [];
            foreach ($documents as $document) {
                if ($document->exists()) {
                    $data = $document->data();
                    $data['id'] = $document->id();
                    $users[] = $data;
                }
            }

            return $users;
        } catch (Exception $e) {
            throw new Exception('Error fetching users: ' . $e->getMessage());
        }
    }

    public function getUserById($userId)
    {
        try {
            $docRef = $this->firestore->collection('users')->document($userId);
            $snapshot = $docRef->snapshot();

            if ($snapshot->exists()) {
                $data = $snapshot->data();
                $data['id'] = $snapshot->id();
                return $data;
            }

            return null;
        } catch (Exception $e) {
            throw new Exception('Error fetching user: ' . $e->getMessage());
        }
    }

    public function getDailyTracking($limit = 100, $userId = null)
    {
        try {
            $trackingRef = $this->firestore->collection('daily_tracking');
            
            if ($userId) {
                $query = $trackingRef->where('userId', '=', $userId)
                                   ->limit($limit)
                                   ->orderBy('date', 'DESC');
            } else {
                $query = $trackingRef->limit($limit)->orderBy('date', 'DESC');
            }

            $documents = $query->documents();

            $tracking = [];
            foreach ($documents as $document) {
                if ($document->exists()) {
                    $data = $document->data();
                    $data['id'] = $document->id();
                    
                    // Convert Firestore timestamp to readable date
                    if (isset($data['date'])) {
                        $data['date'] = $data['date']->get()->format('Y-m-d H:i:s');
                    }
                    if (isset($data['createdAt'])) {
                        $data['createdAt'] = $data['createdAt']->get()->format('Y-m-d H:i:s');
                    }
                    if (isset($data['updatedAt'])) {
                        $data['updatedAt'] = $data['updatedAt']->get()->format('Y-m-d H:i:s');
                    }
                    
                    $tracking[] = $data;
                }
            }

            return $tracking;
        } catch (Exception $e) {
            throw new Exception('Error fetching daily tracking: ' . $e->getMessage());
        }
    }

    public function getWorkoutSessions($limit = 100, $userId = null)
    {
        try {
            $sessionsRef = $this->firestore->collection('workout_sessions');
            
            if ($userId) {
                $query = $sessionsRef->where('userId', '=', $userId)
                                   ->limit($limit)
                                   ->orderBy('startTime', 'DESC');
            } else {
                $query = $sessionsRef->limit($limit)->orderBy('startTime', 'DESC');
            }

            $documents = $query->documents();

            $sessions = [];
            foreach ($documents as $document) {
                if ($document->exists()) {
                    $data = $document->data();
                    $data['id'] = $document->id();
                    
                    // Convert Firestore timestamps to readable dates
                    if (isset($data['startTime'])) {
                        $data['startTime'] = $data['startTime']->get()->format('Y-m-d H:i:s');
                    }
                    if (isset($data['endTime'])) {
                        $data['endTime'] = $data['endTime']->get()->format('Y-m-d H:i:s');
                    }
                    if (isset($data['createdAt'])) {
                        $data['createdAt'] = $data['createdAt']->get()->format('Y-m-d H:i:s');
                    }
                    if (isset($data['updatedAt'])) {
                        $data['updatedAt'] = $data['updatedAt']->get()->format('Y-m-d H:i:s');
                    }
                    
                    $sessions[] = $data;
                }
            }

            return $sessions;
        } catch (Exception $e) {
            throw new Exception('Error fetching workout sessions: ' . $e->getMessage());
        }
    }

    public function getStats()
    {
        try {
            // Get user count
            $usersRef = $this->firestore->collection('users');
            $userCount = 0;
            foreach ($usersRef->documents() as $document) {
                $userCount++;
            }

            // Get workout session count
            $sessionsRef = $this->firestore->collection('workout_sessions');
            $sessionCount = 0;
            $completedWorkouts = 0;
            foreach ($sessionsRef->documents() as $document) {
                $sessionCount++;
                $data = $document->data();
                if (isset($data['status']) && $data['status'] === 'completed') {
                    $completedWorkouts++;
                }
            }

            // Get daily tracking count
            $trackingRef = $this->firestore->collection('daily_tracking');
            $trackingCount = 0;
            foreach ($trackingRef->documents() as $document) {
                $trackingCount++;
            }

            return [
                'totalUsers' => $userCount,
                'totalWorkoutSessions' => $sessionCount,
                'completedWorkouts' => $completedWorkouts,
                'totalTrackingEntries' => $trackingCount
            ];
        } catch (Exception $e) {
            throw new Exception('Error fetching stats: ' . $e->getMessage());
        }
    }
}
