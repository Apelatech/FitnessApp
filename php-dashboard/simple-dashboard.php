<?php
// Simple Dashboard Test
error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

// Check if user is logged in
if (!isset($_SESSION['admin_logged_in'])) {
    header('Location: /login');
    exit;
}

echo "<h1>Dashboard Test</h1>";
echo "<p>✅ You are successfully logged in!</p>";
echo "<p>Session data: " . print_r($_SESSION, true) . "</p>";

echo "<br><a href='/dashboard'>Try Firebase Dashboard</a>";
echo "<br><a href='/logout'>Logout</a>";
?>
