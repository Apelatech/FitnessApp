import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apelatech_fitness/shared/models/app_user.dart';

class UserDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Create or update user in Firestore
  Future<void> createUser(AppUser user) async {
    try {
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'isEmailVerified': user.isEmailVerified,
        'createdAt': user.createdAt ?? FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // Additional user profile fields
        'firstName': _extractFirstName(user.displayName),
        'lastName': _extractLastName(user.displayName),
        'dateOfBirth': null,
        'gender': null,
        'height': null,
        'weight': null,
        'fitnessLevel': 'beginner',
        'goals': <String>[],
        'preferences': <String, dynamic>{},
        'profileComplete': false,
      };

      await _usersCollection.doc(user.uid).set(userData, SetOptions(merge: true));
      print('User created/updated in Firestore: ${user.uid}');
    } catch (e) {
      print('Error creating user in Firestore: $e');
      throw Exception('Failed to create user profile');
    }
  }

  // Get user from Firestore
  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return AppUser.fromFirestore(data);
      }
      
      return null;
    } catch (e) {
      print('Error getting user from Firestore: $e');
      return null;
    }
  }

  // Get user by email
  Future<AppUser?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return AppUser.fromFirestore(data);
      }
      
      return null;
    } catch (e) {
      print('Error getting user by email from Firestore: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _usersCollection.doc(uid).update(updates);
      print('User profile updated: $uid');
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }

  // Update last sign in
  Future<void> updateLastSignIn(String uid) async {
    try {
      await _usersCollection.doc(uid).update({
        'lastSignIn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last sign in: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
      print('User deleted from Firestore: $uid');
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }

  // Check if user exists
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  // Search users (for admin purposes)
  Future<List<AppUser>> searchUsers(String searchTerm, {int limit = 10}) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isGreaterThanOrEqualTo: searchTerm)
          .where('email', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => AppUser.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats(String uid) async {
    try {
      // This would typically involve multiple collections
      // For now, returning basic stats
      return {
        'totalWorkouts': 0,
        'totalCaloriesBurned': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'joinDate': DateTime.now(),
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {};
    }
  }

  // Helper methods
  String? _extractFirstName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return null;
    final parts = displayName.split(' ');
    return parts.isNotEmpty ? parts.first : null;
  }

  String? _extractLastName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return null;
    final parts = displayName.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : null;
  }

  // Stream user data (for real-time updates)
  Stream<AppUser?> streamUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return AppUser.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
