import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutSession {
  final String id;
  final String userId;
  final String workoutId;
  final String workoutName;
  final String category;
  final DateTime startTime;
  final DateTime? endTime;
  final int? actualDuration; // in minutes
  final int estimatedCalories;
  final int? actualCalories;
  final List<CompletedExercise> completedExercises;
  final String status; // 'in_progress', 'completed', 'paused', 'cancelled'
  final Map<String, dynamic> notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutSession({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.workoutName,
    required this.category,
    required this.startTime,
    this.endTime,
    this.actualDuration,
    required this.estimatedCalories,
    this.actualCalories,
    this.completedExercises = const [],
    this.status = 'in_progress',
    this.notes = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'category': category,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'actualDuration': actualDuration,
      'estimatedCalories': estimatedCalories,
      'actualCalories': actualCalories,
      'completedExercises': completedExercises.map((e) => e.toJson()).toList(),
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory WorkoutSession.fromFirestore(Map<String, dynamic> data) {
    return WorkoutSession(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      workoutId: data['workoutId'] ?? '',
      workoutName: data['workoutName'] ?? '',
      category: data['category'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null ? (data['endTime'] as Timestamp).toDate() : null,
      actualDuration: data['actualDuration'],
      estimatedCalories: data['estimatedCalories'] ?? 0,
      actualCalories: data['actualCalories'],
      completedExercises: (data['completedExercises'] as List<dynamic>? ?? [])
          .map((e) => CompletedExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: data['status'] ?? 'in_progress',
      notes: Map<String, dynamic>.from(data['notes'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  WorkoutSession copyWith({
    String? id,
    String? userId,
    String? workoutId,
    String? workoutName,
    String? category,
    DateTime? startTime,
    DateTime? endTime,
    int? actualDuration,
    int? estimatedCalories,
    int? actualCalories,
    List<CompletedExercise>? completedExercises,
    String? status,
    Map<String, dynamic>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workoutId: workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      actualDuration: actualDuration ?? this.actualDuration,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      actualCalories: actualCalories ?? this.actualCalories,
      completedExercises: completedExercises ?? this.completedExercises,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CompletedExercise {
  final String exerciseId;
  final String exerciseName;
  final String type;
  final List<CompletedSet> completedSets;
  final int? duration; // for cardio exercises
  final int caloriesBurned;
  final Map<String, dynamic> notes;

  const CompletedExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.type,
    this.completedSets = const [],
    this.duration,
    this.caloriesBurned = 0,
    this.notes = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'type': type,
      'completedSets': completedSets.map((s) => s.toJson()).toList(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
    };
  }

  factory CompletedExercise.fromJson(Map<String, dynamic> data) {
    return CompletedExercise(
      exerciseId: data['exerciseId'] ?? '',
      exerciseName: data['exerciseName'] ?? '',
      type: data['type'] ?? '',
      completedSets: (data['completedSets'] as List<dynamic>? ?? [])
          .map((s) => CompletedSet.fromJson(s as Map<String, dynamic>))
          .toList(),
      duration: data['duration'],
      caloriesBurned: data['caloriesBurned'] ?? 0,
      notes: Map<String, dynamic>.from(data['notes'] ?? {}),
    );
  }
}

class CompletedSet {
  final int setNumber;
  final int? reps;
  final double? weight; // in kg
  final int? duration; // in seconds
  final bool completed;

  const CompletedSet({
    required this.setNumber,
    this.reps,
    this.weight,
    this.duration,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'completed': completed,
    };
  }

  factory CompletedSet.fromJson(Map<String, dynamic> data) {
    return CompletedSet(
      setNumber: data['setNumber'] ?? 0,
      reps: data['reps'],
      weight: data['weight']?.toDouble(),
      duration: data['duration'],
      completed: data['completed'] ?? false,
    );
  }
}
