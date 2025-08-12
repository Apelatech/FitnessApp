<?php
// Load environment variables from .env file

if (!function_exists('loadEnv')) {
    function loadEnv($filePath) {
        if (!file_exists($filePath)) {
            throw new Exception(".env file not found at: $filePath");
        }
        
        $lines = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) {
                continue; // Skip comments
            }
            
            if (strpos($line, '=') !== false) {
                list($name, $value) = explode('=', $line, 2);
                $name = trim($name);
                $value = trim($value);
                
                // Remove quotes if present
                if (preg_match('/^"(.*)"$/', $value, $matches)) {
                    $value = $matches[1];
                } elseif (preg_match("/^'(.*)'$/", $value, $matches)) {
                    $value = $matches[1];
                }
                
                $_ENV[$name] = $value;
                putenv("$name=$value");
            }
        }
    }
}

// Load the .env file
try {
    loadEnv(__DIR__ . '/../.env');
} catch (Exception $e) {
    error_log("Failed to load .env file: " . $e->getMessage());
}
?>
