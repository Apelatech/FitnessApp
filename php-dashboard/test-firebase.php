<?php
// Firebase Connection Test
require_once 'vendor/autoload.php';

echo "<h1>🔥 Firebase Connection Test</h1>";
echo "<p>Testing your Firebase configuration...</p>";

// Load environment
try {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
    $dotenv->load();
    echo "✅ Environment variables loaded<br>";
} catch (Exception $e) {
    echo "❌ Failed to load .env file: " . $e->getMessage() . "<br>";
}

// Check environment variables
$projectId = $_ENV['FIREBASE_PROJECT_ID'] ?? 'NOT_SET';
$credentialsPath = $_ENV['GOOGLE_APPLICATION_CREDENTIALS'] ?? 'NOT_SET';

echo "<h3>Configuration Check:</h3>";
echo "Project ID: <strong>" . htmlspecialchars($projectId) . "</strong><br>";
echo "Credentials Path: <strong>" . htmlspecialchars($credentialsPath) . "</strong><br>";

// Check if credentials file exists
if ($credentialsPath !== 'NOT_SET') {
    if (file_exists($credentialsPath)) {
        echo "✅ Credentials file exists<br>";
        $credentialsContent = file_get_contents($credentialsPath);
        $credentialsJson = json_decode($credentialsContent, true);
        if ($credentialsJson) {
            echo "✅ Credentials file is valid JSON<br>";
            echo "Service Account Email: <strong>" . htmlspecialchars($credentialsJson['client_email'] ?? 'Not found') . "</strong><br>";
        } else {
            echo "❌ Credentials file is not valid JSON<br>";
        }
    } else {
        echo "❌ Credentials file does not exist at: " . htmlspecialchars($credentialsPath) . "<br>";
    }
} else {
    echo "❌ GOOGLE_APPLICATION_CREDENTIALS not set<br>";
}

// Test Firestore connection
echo "<h3>Firestore Connection Test:</h3>";

try {
    require_once 'src/Config/Config.php';
    require_once 'src/Services/FirestoreService.php';
    
    $config = App\Config\Config::getInstance();
    echo "✅ Config instance created<br>";
    
    $firestoreService = new App\Services\FirestoreService();
    echo "✅ FirestoreService instance created<br>";
    
    // Test reading collections
    echo "<h4>Collection Tests:</h4>";
    
    $users = $firestoreService->getAllUsers();
    echo "Users collection: <strong>" . count($users) . " records</strong><br>";
    
    $tracking = $firestoreService->getAllDailyTracking();
    echo "Daily tracking collection: <strong>" . count($tracking) . " records</strong><br>";
    
    $workouts = $firestoreService->getAllWorkoutSessions();
    echo "Workout sessions collection: <strong>" . count($workouts) . " records</strong><br>";
    
    echo "<h3>🎉 Firebase Connection Successful!</h3>";
    echo "<p><a href='/'>Go to Dashboard</a></p>";
    
} catch (Exception $e) {
    echo "❌ Firebase connection failed: <strong>" . htmlspecialchars($e->getMessage()) . "</strong><br>";
    echo "<h3>Common Solutions:</h3>";
    echo "<ul>";
    echo "<li>Check your Firebase project ID in .env file</li>";
    echo "<li>Verify the path to your service account key file</li>";
    echo "<li>Ensure Firestore is enabled in Firebase Console</li>";
    echo "<li>Check that your service account has Firestore permissions</li>";
    echo "</ul>";
    
    echo "<h3>Sample .env Configuration:</h3>";
    echo "<pre>";
    echo "FIREBASE_PROJECT_ID=your-actual-project-id\n";
    echo "GOOGLE_APPLICATION_CREDENTIALS=C:/path/to/your/firebase-key.json\n";
    echo "</pre>";
}

echo "<style>";
echo "body { font-family: Arial, sans-serif; margin: 20px; }";
echo "h1 { color: #FF5722; }";
echo "h3 { color: #2196F3; }";
echo "pre { background: #f5f5f5; padding: 15px; border-radius: 5px; }";
echo "</style>";
?>
