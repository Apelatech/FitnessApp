import '../../../shared/models/app_user.dart';

class DemoAuthService {
  // Demo users for testing
  static const Map<String, Map<String, String>> _demoUsers = {
    'admin@apelatech.com': {
      'password': 'Admin123!',
      'name': 'Admin User',
      'id': 'demo_admin_123'
    },
    'john.doe@apelatech.com': {
      'password': 'Fitness123!',
      'name': 'John Doe',
      'id': 'demo_john_456'
    },
    'sarah.smith@apelatech.com': {
      'password': 'Health123!',
      'name': 'Sarah Smith',
      'id': 'demo_sarah_789'
    },
    'jana@gmail.com': {
      'password': 'Password123!',
      'name': 'Jana Wilson',
      'id': 'demo_jana_101'
    },
    'kalu@gmail.com': {
      'password': 'Kalu123',
      'name': 'Demo User',
      'id': 'demo_user_202'
    },
  };

  // Current authenticated user
  static AppUser? _currentUser;

  // Get current user
  static AppUser? get currentUser => _currentUser;

  // Authenticate with demo credentials
  static Future<AppUser?> signInWithEmailPassword(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final userEmail = email.toLowerCase().trim();
    final userData = _demoUsers[userEmail];
    
    if (userData != null && userData['password'] == password) {
      _currentUser = AppUser(
        uid: userData['id']!,
        email: userEmail,
        displayName: userData['name'],
        photoURL: null,
        isEmailVerified: true,
        createdAt: DateTime.now(),
        lastSignIn: DateTime.now(),
      );
      return _currentUser;
    }
    
    return null;
  }

  // Sign out
  static Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  // Check if user is authenticated
  static bool get isAuthenticated => _currentUser != null;

  // Get demo users list for reference
  static List<String> get availableEmails => _demoUsers.keys.toList();
}
