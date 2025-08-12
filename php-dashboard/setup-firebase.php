<?php
// Simple Firebase Setup Checker
echo "<h1>🔥 Apelatech Firebase Setup</h1>";
echo "<style>body{font-family:Arial;margin:20px;} .step{background:#f5f5f5;padding:15px;margin:10px 0;border-radius:5px;} .error{color:#FF5722;} .success{color:#4CAF50;}</style>";

echo "<div class='step'>";
echo "<h2>Step 1: Check .env file</h2>";

if (file_exists('.env')) {
    echo "<span class='success'>✅ .env file exists</span><br>";
    $envContent = file_get_contents('.env');
    echo "<pre>" . htmlspecialchars($envContent) . "</pre>";
    
    // Parse .env manually
    $lines = explode("\n", $envContent);
    $envVars = [];
    foreach ($lines as $line) {
        if (strpos($line, '=') !== false && !str_starts_with($line, '#')) {
            list($key, $value) = explode('=', $line, 2);
            $envVars[trim($key)] = trim($value);
        }
    }
    
    echo "<h3>Current Configuration:</h3>";
    echo "Project ID: <strong>" . htmlspecialchars($envVars['FIREBASE_PROJECT_ID'] ?? 'NOT_SET') . "</strong><br>";
    echo "Credentials Path: <strong>" . htmlspecialchars($envVars['GOOGLE_APPLICATION_CREDENTIALS'] ?? 'NOT_SET') . "</strong><br>";
    
} else {
    echo "<span class='error'>❌ .env file not found</span><br>";
}
echo "</div>";

echo "<div class='step'>";
echo "<h2>Step 2: What you need to do</h2>";
echo "<ol>";
echo "<li><strong>Get your Firebase Project ID</strong><br>";
echo "   - Go to Firebase Console → Project Settings<br>";
echo "   - Copy the Project ID (usually like 'your-app-name-12345')</li>";
echo "<li><strong>Download Service Account Key</strong><br>";
echo "   - Firebase Console → Project Settings → Service Accounts<br>";
echo "   - Click 'Generate new private key'<br>";
echo "   - Save the JSON file to your computer</li>";
echo "<li><strong>Update .env file</strong><br>";
echo "   - Replace 'your-actual-firebase-project-id' with your real project ID<br>";
echo "   - Replace the credentials path with your JSON file path</li>";
echo "</ol>";
echo "</div>";

echo "<div class='step'>";
echo "<h2>Step 3: Example .env configuration</h2>";
echo "<pre>";
echo "# Example - replace with your actual values:\n";
echo "FIREBASE_PROJECT_ID=apelatech-fitness-app-12345\n";
echo "GOOGLE_APPLICATION_CREDENTIALS=C:/Users/vihan/Desktop/firebase-key.json\n";
echo "</pre>";
echo "</div>";

echo "<div class='step'>";
echo "<h2>Step 4: Test when ready</h2>";
echo "<p>After updating .env file, visit <a href='/test-firebase'>Firebase Connection Test</a></p>";
echo "<p>Or go back to <a href='/'>Dashboard</a></p>";
echo "</div>";

echo "<div class='step'>";
echo "<h2>Need Help?</h2>";
echo "<p>Tell me:</p>";
echo "<ul>";
echo "<li>What is your Firebase project ID?</li>";
echo "<li>Where did you save your Firebase service account JSON file?</li>";
echo "</ul>";
echo "<p>I can help you update the .env file with the correct values.</p>";
echo "</div>";
?>
