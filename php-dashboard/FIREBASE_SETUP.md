# Apelatech Firebase Dashboard Setup

## 🔥 Connect to Your Firebase Data

Your dashboard is now ready to display real Firebase Firestore data! Follow these steps to connect:

### Step 1: Get Your Firebase Service Account Key

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Project Settings** → **Service Accounts**
4. Click **"Generate new private key"**
5. Download the JSON file
6. Save it somewhere secure (e.g., `C:\firebase\apelatech-firebase-key.json`)

### Step 2: Configure Environment Variables

Edit your `.env` file and update these values:

```bash
# Replace with your actual Firebase project ID
FIREBASE_PROJECT_ID=your-actual-project-id

# Replace with the full path to your downloaded JSON key file
GOOGLE_APPLICATION_CREDENTIALS=C:/path/to/your/firebase-service-account-key.json
```

**Example:**
```bash
FIREBASE_PROJECT_ID=apelatech-fitness-app
GOOGLE_APPLICATION_CREDENTIALS=C:/firebase/apelatech-firebase-key.json
```

### Step 3: Test the Connection

1. Restart your PHP server:
   ```bash
   php -S localhost:8000 server.php
   ```

2. Visit [http://localhost:8000](http://localhost:8000)

3. Login with:
   - Username: `admin`
   - Password: `admin123`

### Step 4: Verify Data Display

The dashboard will show:

✅ **Green Badge**: "Firebase Firestore" - Successfully connected  
❌ **Orange Badge**: "Sample Data" - Connection failed, showing fallback data

### Firebase Collections Expected

Your Firestore should have these collections:

#### `users` collection:
```json
{
  "uid": "string",
  "email": "string", 
  "displayName": "string",
  "photoURL": "string",
  "isEmailVerified": "boolean",
  "createdAt": "timestamp",
  "lastSignIn": "timestamp"
}
```

#### `daily_tracking` collection:
```json
{
  "userId": "string",
  "date": "string", 
  "waterIntake": "number",
  "stepCount": "number",
  "caloriesBurned": "number",
  "weight": "number",
  "sleepHours": "number",
  "updatedAt": "timestamp"
}
```

#### `workout_sessions` collection:
```json
{
  "userId": "string",
  "workoutName": "string",
  "category": "string",
  "startTime": "timestamp",
  "endTime": "timestamp", 
  "actualDuration": "number",
  "actualCalories": "number",
  "status": "string",
  "completedExercises": "array"
}
```

### Troubleshooting

**Issue**: "Firebase connection failed" message  
**Solutions**:
1. Check file path in `GOOGLE_APPLICATION_CREDENTIALS`
2. Verify Firebase project ID is correct
3. Ensure service account has Firestore permissions
4. Check that Firestore is enabled in Firebase Console

**Issue**: "No data found" in sections  
**Solutions**:
1. Verify your Flutter app is writing to Firestore
2. Check collection names match exactly
3. Ensure Firestore security rules allow read access

### Security Notes

⚠️ **Important**:
- Never commit your Firebase service account key to version control
- Store the key file in a secure location
- Use environment variables for configuration
- Restrict Firestore security rules in production

### Next Steps

Once connected, you can:
- View real-time user data
- Monitor daily fitness tracking
- Analyze workout sessions  
- Export data for reports
- Scale to handle more users

Your Apelatech Fitness Dashboard is now ready to display your live Firebase data! 🚀
