import 'package:cloud_firestore/cloud_firestore.dart';

class DailyTracking {
  final String id;
  final String userId;
  final DateTime date;
  final int waterIntake; // in ml
  final int stepCount;
  final int caloriesBurned;
  final double weight; // in kg
  final int sleepHours;
  final Map<String, dynamic> notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyTracking({
    required this.id,
    required this.userId,
    required this.date,
    this.waterIntake = 0,
    this.stepCount = 0,
    this.caloriesBurned = 0,
    this.weight = 0.0,
    this.sleepHours = 0,
    this.notes = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'waterIntake': waterIntake,
      'stepCount': stepCount,
      'caloriesBurned': caloriesBurned,
      'weight': weight,
      'sleepHours': sleepHours,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory DailyTracking.fromFirestore(Map<String, dynamic> data) {
    return DailyTracking(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      waterIntake: data['waterIntake'] ?? 0,
      stepCount: data['stepCount'] ?? 0,
      caloriesBurned: data['caloriesBurned'] ?? 0,
      weight: (data['weight'] ?? 0.0).toDouble(),
      sleepHours: data['sleepHours'] ?? 0,
      notes: Map<String, dynamic>.from(data['notes'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  DailyTracking copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? waterIntake,
    int? stepCount,
    int? caloriesBurned,
    double? weight,
    int? sleepHours,
    Map<String, dynamic>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyTracking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      waterIntake: waterIntake ?? this.waterIntake,
      stepCount: stepCount ?? this.stepCount,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      weight: weight ?? this.weight,
      sleepHours: sleepHours ?? this.sleepHours,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to get today's date key
  static String getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Helper method to generate date key
  static String getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
