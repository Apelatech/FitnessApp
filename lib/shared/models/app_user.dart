import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignIn;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.isEmailVerified = false,
    this.createdAt,
    this.lastSignIn,
  });

  // Create AppUser from Firebase User
  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      isEmailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignIn: user.metadata.lastSignInTime,
    );
  }

  // Get initials for avatar
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final nameParts = displayName!.split(' ');
      if (nameParts.length >= 2) {
        return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        return displayName![0].toUpperCase();
      }
    } else if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return 'U'; // Default
  }

  // Get display name or fallback
  String get displayNameOrEmail {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    } else if (email != null && email!.isNotEmpty) {
      return email!.split('@')[0]; // Use email username part
    }
    return 'User';
  }

  // Get first name
  String get firstName {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!.split(' ')[0];
    } else if (email != null && email!.isNotEmpty) {
      return email!.split('@')[0];
    }
    return 'User';
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignIn': lastSignIn?.toIso8601String(),
    };
  }

  // Create from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      lastSignIn: json['lastSignIn'] != null 
          ? DateTime.parse(json['lastSignIn']) 
          : null,
    );
  }

  // Create from Firestore document
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] is DateTime 
              ? data['createdAt'] 
              : DateTime.parse(data['createdAt'].toString()))
          : null,
      lastSignIn: data['lastSignIn'] != null 
          ? (data['lastSignIn'] is DateTime 
              ? data['lastSignIn'] 
              : DateTime.parse(data['lastSignIn'].toString()))
          : null,
    );
  }

  // Copy with method for updates
  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName)';
  }
}
