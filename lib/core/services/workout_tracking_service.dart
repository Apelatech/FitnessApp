import 'package:apelatech_fitness/core/services/workout_session_service.dart';
import 'package:apelatech_fitness/core/services/daily_tracking_service.dart';
import 'package:apelatech_fitness/shared/models/workout.dart';
import 'package:apelatech_fitness/shared/models/workout_session.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutTrackingService {
  final WorkoutSessionService _sessionService = WorkoutSessionService();
  final DailyTrackingService _trackingService = DailyTrackingService();

  // Start a workout and track it
  Future<WorkoutSession?> startWorkout(Workout workout) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check if user has an active workout session
      final activeSession = await _sessionService.getActiveWorkoutSession(user.uid);
      if (activeSession != null) {
        throw Exception('You already have an active workout session. Please complete or cancel it first.');
      }

      // Start new workout session
      final session = await _sessionService.startWorkoutSession(
        userId: user.uid,
        workout: workout,
      );

      return session;
    } catch (e) {
      print('Error starting workout: $e');
      rethrow;
    }
  }

  // Complete a workout and update daily tracking
  Future<void> completeWorkout({
    required String sessionId,
    required List<CompletedExercise> completedExercises,
    int? actualCalories,
    Map<String, dynamic>? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Complete the workout session
      await _sessionService.completeWorkoutSession(
        sessionId: sessionId,
        completedExercises: completedExercises,
        actualCalories: actualCalories,
        notes: notes,
      );

      // Update daily tracking with calories burned
      if (actualCalories != null && actualCalories > 0) {
        await _trackingService.addCaloriesBurned(user.uid, actualCalories);
      }
    } catch (e) {
      print('Error completing workout: $e');
      rethrow;
    }
  }

  // Pause a workout
  Future<void> pauseWorkout(String sessionId) async {
    try {
      await _sessionService.pauseWorkoutSession(sessionId);
    } catch (e) {
      print('Error pausing workout: $e');
      rethrow;
    }
  }

  // Resume a workout
  Future<void> resumeWorkout(String sessionId) async {
    try {
      await _sessionService.resumeWorkoutSession(sessionId);
    } catch (e) {
      print('Error resuming workout: $e');
      rethrow;
    }
  }

  // Cancel a workout
  Future<void> cancelWorkout(String sessionId) async {
    try {
      await _sessionService.cancelWorkoutSession(sessionId);
    } catch (e) {
      print('Error cancelling workout: $e');
      rethrow;
    }
  }

  // Get active workout session
  Future<WorkoutSession?> getActiveWorkout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      return await _sessionService.getActiveWorkoutSession(user.uid);
    } catch (e) {
      print('Error getting active workout: $e');
      return null;
    }
  }

  // Get workout history
  Future<List<WorkoutSession>> getWorkoutHistory({int limit = 20}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      return await _sessionService.getUserWorkoutSessions(user.uid, limit: limit);
    } catch (e) {
      print('Error getting workout history: $e');
      return [];
    }
  }

  // Get workout statistics
  Future<Map<String, dynamic>> getWorkoutStats({int days = 30}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    try {
      return await _sessionService.getWorkoutStats(user.uid, days: days);
    } catch (e) {
      print('Error getting workout stats: $e');
      return {};
    }
  }

  // Get recent workouts
  Future<List<WorkoutSession>> getRecentWorkouts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      return await _sessionService.getRecentWorkouts(user.uid);
    } catch (e) {
      print('Error getting recent workouts: $e');
      return [];
    }
  }

  // Update exercise progress during workout
  Future<void> updateExerciseProgress({
    required String sessionId,
    required String exerciseId,
    required CompletedSet completedSet,
  }) async {
    try {
      final session = await _sessionService.getWorkoutSession(sessionId);
      if (session == null) {
        throw Exception('Workout session not found');
      }

      // Find the exercise in completed exercises
      final exerciseIndex = session.completedExercises
          .indexWhere((exercise) => exercise.exerciseId == exerciseId);

      List<CompletedExercise> updatedExercises = List.from(session.completedExercises);

      if (exerciseIndex >= 0) {
        // Update existing exercise
        final exercise = updatedExercises[exerciseIndex];
        final updatedSets = List<CompletedSet>.from(exercise.completedSets);
        
        // Add or update the set
        final setIndex = updatedSets.indexWhere((set) => set.setNumber == completedSet.setNumber);
        if (setIndex >= 0) {
          updatedSets[setIndex] = completedSet;
        } else {
          updatedSets.add(completedSet);
        }

        updatedExercises[exerciseIndex] = CompletedExercise(
          exerciseId: exercise.exerciseId,
          exerciseName: exercise.exerciseName,
          type: exercise.type,
          completedSets: updatedSets,
          duration: exercise.duration,
          caloriesBurned: exercise.caloriesBurned,
          notes: exercise.notes,
        );
      }

      // Update the session with new exercise data
      final updatedSession = session.copyWith(
        completedExercises: updatedExercises,
      );

      await _sessionService.updateWorkoutSession(updatedSession);
    } catch (e) {
      print('Error updating exercise progress: $e');
      rethrow;
    }
  }
}
