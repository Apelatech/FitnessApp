<?php

session_start();

require_once __DIR__ . '/vendor/autoload.php';

use App\Config\Config;
use App\Controllers\AuthController;
use App\Controllers\DashboardController;
use App\Controllers\ApiController;

// Initialize configuration
$config = Config::getInstance();

// Simple routing
$request = $_SERVER['REQUEST_URI'];
$path = parse_url($request, PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

// Remove base path if needed
$basePath = '/php-dashboard';
if (strpos($path, $basePath) === 0) {
    $path = substr($path, strlen($basePath));
}

try {
    switch ($path) {
        case '/':
        case '/dashboard':
            if (!AuthController::isAuthenticated()) {
                header('Location: /login');
                exit;
            }
            $controller = new DashboardController();
            $controller->index();
            break;

        case '/login':
            if ($method === 'POST') {
                $controller = new AuthController();
                $controller->login();
            } else {
                $controller = new AuthController();
                $controller->showLogin();
            }
            break;

        case '/logout':
            $controller = new AuthController();
            $controller->logout();
            break;

        case '/users':
            if (!AuthController::isAuthenticated()) {
                header('Location: /login');
                exit;
            }
            $controller = new DashboardController();
            $controller->users();
            break;

        case '/tracking':
            if (!AuthController::isAuthenticated()) {
                header('Location: /login');
                exit;
            }
            $controller = new DashboardController();
            $controller->tracking();
            break;

        case '/workouts':
            if (!AuthController::isAuthenticated()) {
                header('Location: /login');
                exit;
            }
            $controller = new DashboardController();
            $controller->workouts();
            break;

        case '/api/users':
            if (!AuthController::isAuthenticated()) {
                http_response_code(401);
                echo json_encode(['error' => 'Unauthorized']);
                exit;
            }
            $controller = new ApiController();
            $controller->getUsers();
            break;

        case '/api/tracking':
            if (!AuthController::isAuthenticated()) {
                http_response_code(401);
                echo json_encode(['error' => 'Unauthorized']);
                exit;
            }
            $controller = new ApiController();
            $controller->getTracking();
            break;

        case '/api/workouts':
            if (!AuthController::isAuthenticated()) {
                http_response_code(401);
                echo json_encode(['error' => 'Unauthorized']);
                exit;
            }
            $controller = new ApiController();
            $controller->getWorkouts();
            break;

        default:
            http_response_code(404);
            echo '404 - Page Not Found';
            break;
    }
} catch (Exception $e) {
    if ($config->isDebug()) {
        echo 'Error: ' . $e->getMessage();
    } else {
        echo '500 - Internal Server Error';
    }
}
