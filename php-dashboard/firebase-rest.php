<?php
require_once 'config/env.php';

class FirebaseRestClient {
    private $projectId;
    private $accessToken;
    
    public function __construct() {
        $this->projectId = $_ENV['FIREBASE_PROJECT_ID'];
        $this->accessToken = $this->getAccessToken();
    }
    
    private function getAccessToken() {
        try {
            $credentialsFile = $_ENV['GOOGLE_APPLICATION_CREDENTIALS'];
            if (!file_exists($credentialsFile)) {
                throw new Exception("Credentials file not found");
            }
            
            $credentials = json_decode(file_get_contents($credentialsFile), true);
            
            // Create JWT for service account authentication
            $header = json_encode(['typ' => 'JWT', 'alg' => 'RS256']);
            $now = time();
            $payload = json_encode([
                'iss' => $credentials['client_email'],
                'scope' => 'https://www.googleapis.com/auth/datastore',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600
            ]);
            
            $base64Header = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($header));
            $base64Payload = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($payload));
            
            $signature = '';
            openssl_sign($base64Header . '.' . $base64Payload, $signature, $credentials['private_key'], 'SHA256');
            $base64Signature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
            
            $jwt = $base64Header . '.' . $base64Payload . '.' . $base64Signature;
            
            // Exchange JWT for access token
            $tokenData = [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt
            ];
            
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://oauth2.googleapis.com/token');
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($tokenData));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/x-www-form-urlencoded']);
            
            $response = curl_exec($ch);
            curl_close($ch);
            
            $tokenResponse = json_decode($response, true);
            return $tokenResponse['access_token'] ?? null;
        } catch (Exception $e) {
            error_log("Firebase Auth Error: " . $e->getMessage());
            return null;
        }
    }
    
    public function getCollection($collection) {
        if (!$this->accessToken) {
            return [];
        }
        
        try {
            $url = "https://firestore.googleapis.com/v1/projects/{$this->projectId}/databases/(default)/documents/{$collection}";
            
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Authorization: Bearer ' . $this->accessToken,
                'Content-Type: application/json'
            ]);
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);
            
            if ($httpCode === 200) {
                $data = json_decode($response, true);
                return $this->parseFirestoreResponse($data);
            }
            
            return [];
        } catch (Exception $e) {
            error_log("Firestore Query Error: " . $e->getMessage());
            return [];
        }
    }
    
    private function parseFirestoreResponse($response) {
        $documents = $response['documents'] ?? [];
        $result = [];
        
        foreach ($documents as $doc) {
            $docData = [];
            $fields = $doc['fields'] ?? [];
            
            foreach ($fields as $key => $field) {
                $docData[$key] = $this->parseFieldValue($field);
            }
            
            $result[] = $docData;
        }
        
        return $result;
    }
    
    private function parseFieldValue($field) {
        if (isset($field['stringValue'])) return $field['stringValue'];
        if (isset($field['integerValue'])) return (int)$field['integerValue'];
        if (isset($field['doubleValue'])) return (float)$field['doubleValue'];
        if (isset($field['booleanValue'])) return $field['booleanValue'];
        if (isset($field['timestampValue'])) return $field['timestampValue'];
        if (isset($field['arrayValue'])) {
            $array = [];
            foreach ($field['arrayValue']['values'] ?? [] as $value) {
                $array[] = $this->parseFieldValue($value);
            }
            return $array;
        }
        if (isset($field['mapValue'])) {
            $map = [];
            foreach ($field['mapValue']['fields'] ?? [] as $key => $value) {
                $map[$key] = $this->parseFieldValue($value);
            }
            return $map;
        }
        
        return null;
    }
    
    public function testConnection() {
        return $this->accessToken !== null;
    }
}
