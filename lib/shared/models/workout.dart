class Workout {
  final String id;
  final String name;
  final String category;
  final int duration; // minutes
  final int calories;
  final String difficulty;
  final List<Exercise> exercises;
  final DateTime? scheduledDate;
  final bool isCompleted;
  final String? description;
  final String? imageUrl;

  const Workout({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.calories,
    required this.difficulty,
    required this.exercises,
    this.scheduledDate,
    this.isCompleted = false,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'duration': duration,
      'calories': calories,
      'difficulty': difficulty,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'scheduledDate': scheduledDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      duration: json['duration'],
      calories: json['calories'],
      difficulty: json['difficulty'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Workout copyWith({
    String? id,
    String? name,
    String? category,
    int? duration,
    int? calories,
    String? difficulty,
    List<Exercise>? exercises,
    DateTime? scheduledDate,
    bool? isCompleted,
    String? description,
    String? imageUrl,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      difficulty: difficulty ?? this.difficulty,
      exercises: exercises ?? this.exercises,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isCompleted: isCompleted ?? this.isCompleted,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String type; // strength, cardio, stretching
  final int sets;
  final int reps;
  final int? duration; // seconds for time-based exercises
  final int? restTime; // seconds
  final String? instructions;
  final String? videoUrl;
  final String? imageUrl;
  final List<String> muscleGroups;

  const Exercise({
    required this.id,
    required this.name,
    required this.type,
    this.sets = 1,
    this.reps = 1,
    this.duration,
    this.restTime,
    this.instructions,
    this.videoUrl,
    this.imageUrl,
    this.muscleGroups = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'restTime': restTime,
      'instructions': instructions,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'muscleGroups': muscleGroups,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      sets: json['sets'] ?? 1,
      reps: json['reps'] ?? 1,
      duration: json['duration'],
      restTime: json['restTime'],
      instructions: json['instructions'],
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'],
      muscleGroups: List<String>.from(json['muscleGroups'] ?? []),
    );
  }
}
