<?php

namespace App\Config;

use Dotenv\Dotenv;
use Google\Cloud\Firestore\FirestoreClient;

class Config
{
    private static $instance = null;
    private $firestore;
    private $env;

    private function __construct()
    {
        // Load environment variables
        $dotenv = Dotenv::createImmutable(__DIR__ . '/../../');
        $dotenv->load();

        $this->env = $_ENV;

        // Initialize Firestore
        $this->initializeFirestore();
    }

    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function initializeFirestore()
    {
        try {
            $this->firestore = new FirestoreClient([
                'projectId' => $this->env['FIREBASE_PROJECT_ID'],
                'keyFilePath' => $this->env['GOOGLE_APPLICATION_CREDENTIALS']
            ]);
        } catch (Exception $e) {
            throw new Exception('Failed to initialize Firestore: ' . $e->getMessage());
        }
    }

    public function getFirestore()
    {
        return $this->firestore;
    }

    public function get($key, $default = null)
    {
        return $this->env[$key] ?? $default;
    }

    public function isDebug()
    {
        return $this->env['APP_DEBUG'] === 'true';
    }
}
