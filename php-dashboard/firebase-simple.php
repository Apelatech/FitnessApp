<?php
require_once 'config/env.php';

class FirebaseSimpleClient {
    private $projectId;
    private $serviceAccount;
    private $accessToken;
    
    public function __construct() {
        $this->projectId = $_ENV['FIREBASE_PROJECT_ID'];
        $this->loadServiceAccount();
        $this->accessToken = $this->getAccessToken();
    }
    
    private function loadServiceAccount() {
        try {
            $credentialsFile = $_ENV['GOOGLE_APPLICATION_CREDENTIALS'];
            if (!file_exists($credentialsFile)) {
                throw new Exception("Credentials file not found: $credentialsFile");
            }
            
            $this->serviceAccount = json_decode(file_get_contents($credentialsFile), true);
            if (!$this->serviceAccount) {
                throw new Exception("Invalid JSON in credentials file");
            }
            
        } catch (Exception $e) {
            error_log("Service Account Error: " . $e->getMessage());
            $this->serviceAccount = null;
        }
    }
    
    private function getAccessToken() {
        if (!$this->serviceAccount) {
            return null;
        }
        
        try {
            // Create JWT manually with simpler approach
            $header = [
                'alg' => 'RS256',
                'typ' => 'JWT'
            ];
            
            $now = time();
            $payload = [
                'iss' => $this->serviceAccount['client_email'],
                'scope' => 'https://www.googleapis.com/auth/cloud-platform',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600
            ];
            
            // Encode header and payload
            $encodedHeader = $this->base64UrlEncode(json_encode($header));
            $encodedPayload = $this->base64UrlEncode(json_encode($payload));
            
            // Create signature
            $signature = '';
            $signatureInput = $encodedHeader . '.' . $encodedPayload;
            
            // Fix private key format
            $privateKey = $this->serviceAccount['private_key'];
            if (strpos($privateKey, '-----BEGIN PRIVATE KEY-----') === false) {
                $privateKey = "-----BEGIN PRIVATE KEY-----\n" . chunk_split($privateKey, 64, "\n") . "-----END PRIVATE KEY-----\n";
            }
            
            if (!openssl_sign($signatureInput, $signature, $privateKey, 'SHA256')) {
                throw new Exception("Failed to sign JWT");
            }
            
            $encodedSignature = $this->base64UrlEncode($signature);
            $jwt = $signatureInput . '.' . $encodedSignature;
            
            // Exchange JWT for access token
            $postData = [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt
            ];
            
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://oauth2.googleapis.com/token');
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/x-www-form-urlencoded'
            ]);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // For Windows compatibility
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);
            
            if ($curlError) {
                throw new Exception("cURL Error: $curlError");
            }
            
            if ($httpCode !== 200) {
                throw new Exception("HTTP Error $httpCode: $response");
            }
            
            $tokenData = json_decode($response, true);
            if (!isset($tokenData['access_token'])) {
                throw new Exception("No access token in response: $response");
            }
            
            return $tokenData['access_token'];
            
        } catch (Exception $e) {
            error_log("Firebase Auth Error: " . $e->getMessage());
            return null;
        }
    }
    
    private function base64UrlEncode($data) {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }
    
    public function testConnection() {
        return $this->accessToken !== null;
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
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // For Windows compatibility
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);
            
            if ($curlError) {
                error_log("Firestore cURL Error: $curlError");
                return [];
            }
            
            if ($httpCode === 200) {
                $data = json_decode($response, true);
                return $this->parseFirestoreResponse($data);
            } else {
                error_log("Firestore HTTP Error $httpCode: $response");
                return [];
            }
            
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
            
            // Add document ID
            if (isset($doc['name'])) {
                $pathParts = explode('/', $doc['name']);
                $docData['id'] = end($pathParts);
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
        if (isset($field['nullValue'])) return null;
        
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
    
    public function getDebugInfo() {
        return [
            'projectId' => $this->projectId,
            'hasServiceAccount' => $this->serviceAccount !== null,
            'serviceAccountEmail' => $this->serviceAccount['client_email'] ?? 'N/A',
            'hasAccessToken' => $this->accessToken !== null,
            'accessTokenPreview' => $this->accessToken ? substr($this->accessToken, 0, 20) . '...' : 'None'
        ];
    }
}
