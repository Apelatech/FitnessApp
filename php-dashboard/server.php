<?php
// Simple PHP server for testing the dashboard
// Run with: php -S localhost:8000

// Simple routing
$request = $_SERVER['REQUEST_URI'];
$path = parse_url($request, PHP_URL_PATH);

// Remove query parameters
$path = strtok($path, '?');

// Basic routing
switch ($path) {
    case '/':
    case '/dashboard':
        include 'firebase-dashboard.php';
        break;
    case '/login':
        include 'login.php';
        break;
    case '/setup-firebase':
        include 'setup-firebase.php';
        break;
    case '/test-firebase':
        include 'test-firebase.php';
        break;
    case '/test-firebase-rest':
        include 'test-firebase-rest.php';
        break;
    case '/test-firebase-simple':
        include 'test-firebase-simple.php';
        break;
    case '/debug-firebase':
        include 'debug-firebase.php';
        break;
    case '/error-check':
        include 'error-check.php';
        break;
    case '/simple-dashboard':
        include 'simple-dashboard.php';
        break;
    case '/logout':
        session_start();
        session_destroy();
        header('Location: /login');
        exit;
        break;
    default:
        http_response_code(404);
        echo "<h1>404 - Page Not Found</h1>";
        echo "<p>Path: " . htmlspecialchars($path) . "</p>";
        echo "<a href='/'>Go to Dashboard</a> | <a href='/setup-firebase'>Setup Firebase</a>";
        break;
}
?>
