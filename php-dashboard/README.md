# Apelatech Fitness Dashboard

A comprehensive PHP dashboard for displaying Firebase Firestore data from your Apelatech fitness tracking app.

## 🎨 Brand Identity

**Apelatech** - Where fitness meets technology

### Color Palette
- **Jet Black:** `#0A0A0A` (Primary dark)
- **Fire Orange:** `#FF5722` (Brand accent)  
- **Sky Blue:** `#2196F3` (Secondary accent)

### Typography
- **Primary Font:** Manrope (Headers, brands, important text)
- **Secondary Font:** Inter (Body text, UI elements)

### Design Philosophy
Modern fitness tech aesthetic with gradient elements, combining the power of jet black with the energy of fire orange and the trust of sky blue.

## Features

- **User Management**: View all registered users with their profile information
- **Daily Tracking**: Monitor water intake, steps, calories, weight, and sleep data
- **Workout Sessions**: Track workout sessions with detailed exercise information
- **Authentication**: Simple admin login system with session management
- **Responsive Design**: Mobile-friendly interface using Bootstrap 5
- **Real-time Data**: Direct integration with Firebase Firestore
- **Export Functionality**: Export data for analysis (ready for implementation)

## Requirements

- PHP 7.4 or higher
- Composer
- Firebase project with Firestore enabled
- Firebase service account key

## Installation

1. **Clone or download the project**
   ```bash
   cd php-dashboard
   ```

2. **Install dependencies**
   ```bash
   composer install
   ```

3. **Configure environment**
   ```bash
   copy .env.example .env
   ```

4. **Update .env file with your Firebase configuration**
   ```bash
   # Firebase Admin SDK Configuration
   GOOGLE_APPLICATION_CREDENTIALS=path/to/your/service-account-key.json
   FIREBASE_PROJECT_ID=your-firebase-project-id

   # Dashboard Admin Credentials
   ADMIN_USERNAME=admin
   ADMIN_PASSWORD=your-secure-password
   ```

5. **Set up Firebase Service Account**
   - Go to Firebase Console → Project Settings → Service Accounts
   - Click "Generate new private key"
   - Download the JSON file and save it to your server
   - Update `GOOGLE_APPLICATION_CREDENTIALS` in `.env` with the path to this file

6. **Configure web server**
   - Point your web server document root to the `public` folder
   - For Apache, ensure mod_rewrite is enabled
   - For Nginx, configure URL rewriting to `index.php`

## Usage

1. **Access the dashboard**
   - Navigate to your domain (e.g., `http://localhost/php-dashboard`)
   - Login with the credentials set in your `.env` file

2. **View data**
   - **Dashboard**: Overview with statistics and recent activity
   - **Users**: All registered users with profile information
   - **Tracking**: Daily fitness tracking data with filters
   - **Workouts**: Workout sessions with exercise details

## Firebase Data Structure

The dashboard expects the following Firestore collections:

### Users Collection
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

### Daily Tracking Collection
```json
{
  "userId": "string",
  "date": "string",
  "waterIntake": "number",
  "stepCount": "number",
  "caloriesBurned": "number",
  "weight": "number",
  "sleepHours": "number",
  "notes": "object",
  "updatedAt": "timestamp"
}
```

### Workout Sessions Collection
```json
{
  "userId": "string",
  "workoutName": "string",
  "category": "string",
  "startTime": "timestamp",
  "endTime": "timestamp",
  "actualDuration": "number",
  "estimatedDuration": "number",
  "actualCalories": "number",
  "estimatedCalories": "number",
  "completedExercises": "array",
  "status": "string"
}
```

## Security Considerations

1. **Environment Variables**: Never commit your `.env` file to version control
2. **Service Account Key**: Keep your Firebase service account key secure
3. **Admin Credentials**: Use strong passwords for admin access
4. **HTTPS**: Always use HTTPS in production
5. **File Permissions**: Ensure proper file permissions on your server

## Customization

### Adding New Views
1. Create a new PHP file in `src/Views/`
2. Add a route in `src/Controllers/DashboardController.php`
3. Update the navigation in `src/Views/layout.php`

### Styling
- Edit `public/assets/css/custom.css` for custom styles
- The dashboard uses Bootstrap 5 for responsive design

### API Endpoints
- Add new endpoints in `src/Controllers/ApiController.php`
- Extend `src/Services/FirestoreService.php` for new data operations

## Troubleshooting

### Common Issues

1. **"Class 'Google\Cloud\Firestore\FirestoreClient' not found"**
   - Run `composer install` to install dependencies

2. **"Unable to locate credentials"**
   - Check that `GOOGLE_APPLICATION_CREDENTIALS` path is correct
   - Ensure the service account key file exists and is readable

3. **"Permission denied to access Firestore"**
   - Verify your service account has Firestore permissions
   - Check that your Firebase project ID is correct

4. **"Session not starting"**
   - Ensure your web server has write permissions to the session directory
   - Check PHP session configuration

### Debugging

Enable debug mode in `.env`:
```bash
APP_DEBUG=true
```

Check PHP error logs for detailed error information.

## Development

### File Structure
```
php-dashboard/
├── public/
│   ├── index.php          # Entry point
│   └── assets/            # CSS, JS, images
├── src/
│   ├── Config/            # Configuration classes
│   ├── Controllers/       # Request handlers
│   ├── Services/          # Business logic
│   └── Views/             # HTML templates
├── vendor/                # Composer dependencies
├── .env.example           # Environment template
├── .gitignore            # Git ignore rules
├── composer.json         # PHP dependencies
└── README.md             # This file
```

### Adding Features

1. **New Data Sources**: Extend `FirestoreService.php`
2. **New Pages**: Add controllers and views
3. **Authentication**: Modify `AuthController.php`
4. **API Endpoints**: Extend `ApiController.php`

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Firebase documentation
3. Check PHP error logs
4. Ensure all dependencies are installed correctly

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

**Note**: This dashboard is designed for administrative purposes. Ensure proper security measures are in place before deploying to production.
