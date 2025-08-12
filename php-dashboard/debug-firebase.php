<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h2>Firebase Connection Debug</h2>";

// Load environment variables
if (file_exists('.env')) {
    $env = file_get_contents('.env');
    $lines = explode("\n", $env);
    foreach ($lines as $line) {
        if (strpos($line, '=') !== false && strpos($line, '#') !== 0) {
            list($key, $value) = explode('=', $line, 2);
            $_ENV[trim($key)] = trim($value, '"');
        }
    }
    echo "✅ .env file loaded<br>";
} else {
    echo "❌ .env file not found<br>";
}

// Check environment variables
echo "<h3>Environment Variables:</h3>";
echo "PROJECT_ID: " . ($_ENV['FIREBASE_PROJECT_ID'] ?? 'NOT SET') . "<br>";
echo "CREDENTIALS PATH: " . ($_ENV['GOOGLE_APPLICATION_CREDENTIALS'] ?? 'NOT SET') . "<br>";

// Check if credentials file exists
$credentialsPath = $_ENV['GOOGLE_APPLICATION_CREDENTIALS'] ?? '';
if (file_exists($credentialsPath)) {
    echo "✅ Credentials file exists<br>";
    $fileSize = filesize($credentialsPath);
    echo "File size: " . $fileSize . " bytes<br>";
} else {
    echo "❌ Credentials file not found at: " . $credentialsPath . "<br>";
}

// Check if vendor directory exists
if (file_exists('vendor/autoload.php')) {
    echo "✅ Composer vendor directory exists<br>";
    require_once 'vendor/autoload.php';
} else {
    echo "❌ Composer vendor directory not found<br>";
    echo "Please run: composer install<br>";
    exit;
}

// Test Firebase SDK loading
try {
    echo "✅ Firestore SDK class loaded<br>";
} catch (Exception $e) {
    echo "❌ Error loading Firestore SDK: " . $e->getMessage() . "<br>";
}

use Google\Cloud\Firestore\FirestoreClient;

// Test Firebase connection
try {
    // Set environment variable for credentials
    if (!empty($credentialsPath)) {
        putenv("GOOGLE_APPLICATION_CREDENTIALS=" . $credentialsPath);
    }
    
    $firestore = new FirestoreClient([
        'projectId' => $_ENV['FIREBASE_PROJECT_ID'] ?? ''
    ]);
    
    echo "✅ Firestore client created<br>";
    
    // Test a simple query
    $collections = $firestore->collections();
    $collectionNames = [];
    foreach ($collections as $collection) {
        $collectionNames[] = $collection->id();
    }
    
    echo "✅ Successfully connected to Firestore!<br>";
    echo "Available collections: " . implode(', ', $collectionNames) . "<br>";
    
} catch (Exception $e) {
    echo "❌ Firebase connection failed: " . $e->getMessage() . "<br>";
    echo "Error details: " . $e->getTraceAsString() . "<br>";
}

echo "<br><a href='/firebase-dashboard'>← Back to Dashboard</a>";
?>
