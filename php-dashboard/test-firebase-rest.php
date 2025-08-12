<?php
require_once 'config/env.php';
require_once 'firebase-rest.php';

echo "<h1>Firebase REST Connection Test</h1>";

try {
    $client = new FirebaseRestClient();
    
    echo "<h2>Authentication Test</h2>";
    if ($client->testConnection()) {
        echo "<p style='color: green;'>✅ Firebase authentication successful!</p>";
        
        echo "<h2>Data Fetch Test</h2>";
        
        // Test fetching users
        echo "<h3>Users Collection:</h3>";
        $users = $client->getCollection('users');
        if (!empty($users)) {
            echo "<p style='color: green;'>✅ Found " . count($users) . " users</p>";
            echo "<pre>" . json_encode($users, JSON_PRETTY_PRINT) . "</pre>";
        } else {
            echo "<p style='color: orange;'>⚠️ No users found or collection is empty</p>";
        }
        
        // Test fetching daily tracking
        echo "<h3>Daily Tracking Collection:</h3>";
        $tracking = $client->getCollection('daily_tracking');
        if (!empty($tracking)) {
            echo "<p style='color: green;'>✅ Found " . count($tracking) . " tracking records</p>";
            echo "<pre>" . json_encode($tracking, JSON_PRETTY_PRINT) . "</pre>";
        } else {
            echo "<p style='color: orange;'>⚠️ No tracking data found or collection is empty</p>";
        }
        
        // Test fetching workout sessions
        echo "<h3>Workout Sessions Collection:</h3>";
        $workouts = $client->getCollection('workout_sessions');
        if (!empty($workouts)) {
            echo "<p style='color: green;'>✅ Found " . count($workouts) . " workout sessions</p>";
            echo "<pre>" . json_encode($workouts, JSON_PRETTY_PRINT) . "</pre>";
        } else {
            echo "<p style='color: orange;'>⚠️ No workout sessions found or collection is empty</p>";
        }
        
    } else {
        echo "<p style='color: red;'>❌ Firebase authentication failed</p>";
        echo "<p>Please check your service account JSON file and credentials.</p>";
    }
    
} catch (Exception $e) {
    echo "<p style='color: red;'>❌ Error: " . htmlspecialchars($e->getMessage()) . "</p>";
}

echo "<br><a href='/firebase-dashboard'>← Back to Dashboard</a>";
?>
