<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once 'config/env.php';
require_once 'firebase-simple.php';

echo "<h1>Firebase Simple Client Test</h1>";

try {
    $client = new FirebaseSimpleClient();
    
    echo "<h2>Debug Information:</h2>";
    $debugInfo = $client->getDebugInfo();
    foreach ($debugInfo as $key => $value) {
        echo "<p><strong>$key:</strong> $value</p>";
    }
    
    echo "<h2>Authentication Test:</h2>";
    if ($client->testConnection()) {
        echo "<p style='color: green; font-size: 18px;'>✅ Firebase authentication successful!</p>";
        
        echo "<h2>Data Fetch Test:</h2>";
        
        // Test fetching users
        echo "<h3>Users Collection:</h3>";
        $users = $client->getCollection('users');
        if (!empty($users)) {
            echo "<p style='color: green;'>✅ Found " . count($users) . " users</p>";
            echo "<details><summary>View Users Data</summary>";
            echo "<pre>" . json_encode($users, JSON_PRETTY_PRINT) . "</pre>";
            echo "</details>";
        } else {
            echo "<p style='color: orange;'>⚠️ No users found or collection is empty</p>";
        }
        
        // Test fetching daily tracking
        echo "<h3>Daily Tracking Collection:</h3>";
        $tracking = $client->getCollection('daily_tracking');
        if (!empty($tracking)) {
            echo "<p style='color: green;'>✅ Found " . count($tracking) . " tracking records</p>";
            echo "<details><summary>View Tracking Data</summary>";
            echo "<pre>" . json_encode($tracking, JSON_PRETTY_PRINT) . "</pre>";
            echo "</details>";
        } else {
            echo "<p style='color: orange;'>⚠️ No tracking data found or collection is empty</p>";
        }
        
        // Test fetching workout sessions
        echo "<h3>Workout Sessions Collection:</h3>";
        $workouts = $client->getCollection('workout_sessions');
        if (!empty($workouts)) {
            echo "<p style='color: green;'>✅ Found " . count($workouts) . " workout sessions</p>";
            echo "<details><summary>View Workouts Data</summary>";
            echo "<pre>" . json_encode($workouts, JSON_PRETTY_PRINT) . "</pre>";
            echo "</details>";
        } else {
            echo "<p style='color: orange;'>⚠️ No workout sessions found or collection is empty</p>";
        }
        
    } else {
        echo "<p style='color: red; font-size: 18px;'>❌ Firebase authentication failed</p>";
        echo "<p>Check the debug information above for details.</p>";
    }
    
} catch (Exception $e) {
    echo "<p style='color: red;'>❌ Error: " . htmlspecialchars($e->getMessage()) . "</p>";
}

echo "<br><br>";
echo "<a href='/dashboard'>← Back to Dashboard</a> | ";
echo "<a href='/error-check'>Environment Check</a>";
?>
