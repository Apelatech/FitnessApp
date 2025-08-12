<?php

namespace App\Controllers;

use App\Config\Config;

class AuthController
{
    private $config;

    public function __construct()
    {
        $this->config = Config::getInstance();
    }

    public function showLogin()
    {
        if (self::isAuthenticated()) {
            header('Location: /dashboard');
            exit;
        }

        include __DIR__ . '/../Views/login.php';
    }

    public function login()
    {
        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';

        if ($this->validateCredentials($username, $password)) {
            $_SESSION['authenticated'] = true;
            $_SESSION['user'] = $username;
            header('Location: /dashboard');
            exit;
        } else {
            $_SESSION['error'] = 'Invalid username or password';
            header('Location: /login');
            exit;
        }
    }

    public function logout()
    {
        session_destroy();
        header('Location: /login');
        exit;
    }

    public static function isAuthenticated()
    {
        return isset($_SESSION['authenticated']) && $_SESSION['authenticated'] === true;
    }

    private function validateCredentials($username, $password)
    {
        $adminUsername = $this->config->get('ADMIN_USERNAME', 'admin');
        $adminPassword = $this->config->get('ADMIN_PASSWORD', 'password');

        return $username === $adminUsername && $password === $adminPassword;
    }
}
