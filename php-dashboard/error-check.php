<?php
// Simple error checking
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h1>Error Check</h1>";

echo "<h2>Environment Check:</h2>";

// Check if .env file exists
if (file_exists('config/env.php')) {
    echo "✅ config/env.php exists<br>";
    try {
        require_once 'config/env.php';
        echo "✅ config/env.php loaded<br>";
    } catch (Exception $e) {
        echo "❌ Error loading config/env.php: " . $e->getMessage() . "<br>";
    }
} else {
    echo "❌ config/env.php missing<br>";
}

// Check if firebase-rest.php exists
if (file_exists('firebase-rest.php')) {
    echo "✅ firebase-rest.php exists<br>";
    try {
        require_once 'firebase-rest.php';
        echo "✅ firebase-rest.php loaded<br>";
    } catch (Exception $e) {
        echo "❌ Error loading firebase-rest.php: " . $e->getMessage() . "<br>";
    }
} else {
    echo "❌ firebase-rest.php missing<br>";
}

// Check environment variables
echo "<h2>Environment Variables:</h2>";
echo "FIREBASE_PROJECT_ID: " . ($_ENV['FIREBASE_PROJECT_ID'] ?? 'NOT SET') . "<br>";
echo "GOOGLE_APPLICATION_CREDENTIALS: " . ($_ENV['GOOGLE_APPLICATION_CREDENTIALS'] ?? 'NOT SET') . "<br>";

// Check credentials file
$credFile = $_ENV['GOOGLE_APPLICATION_CREDENTIALS'] ?? '';
if ($credFile && file_exists($credFile)) {
    echo "✅ Credentials file exists<br>";
} else {
    echo "❌ Credentials file missing: $credFile<br>";
}

echo "<br><a href='/login'>← Back to Login</a>";
?>
