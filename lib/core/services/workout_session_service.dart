import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apelatech_fitness/shared/models/workout_session.dart';
import 'package:apelatech_fitness/shared/models/workout.dart';

class WorkoutSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference get _sessionsCollection => _firestore.collection('workout_sessions');

  // Start a new workout session
  Future<WorkoutSession> startWorkoutSession({
    required String userId,
    required Workout workout,
  }) async {
    try {
      final sessionId = _firestore.collection('workout_sessions').doc().id;
      final now = DateTime.now();
      
      final session = WorkoutSession(
        id: sessionId,
        userId: userId,
        workoutId: workout.id,
        workoutName: workout.name,
        category: workout.category,
        startTime: now,
        estimatedCalories: workout.calories,
        status: 'in_progress',
        createdAt: now,
        updatedAt: now,
      );

      await _sessionsCollection.doc(sessionId).set(session.toJson());
      print('Workout session started: $sessionId');
      
      return session;
    } catch (e) {
      print('Error starting workout session: $e');
      throw Exception('Failed to start workout session');
    }
  }

  // Update workout session
  Future<void> updateWorkoutSession(WorkoutSession session) async {
    try {
      final updatedSession = session.copyWith(updatedAt: DateTime.now());
      await _sessionsCollection.doc(session.id).update(updatedSession.toJson());
      print('Workout session updated: ${session.id}');
    } catch (e) {
      print('Error updating workout session: $e');
      throw Exception('Failed to update workout session');
    }
  }

  // Complete workout session
  Future<void> completeWorkoutSession({
    required String sessionId,
    required List<CompletedExercise> completedExercises,
    int? actualCalories,
    Map<String, dynamic>? notes,
  }) async {
    try {
      final endTime = DateTime.now();
      final session = await getWorkoutSession(sessionId);
      
      if (session != null) {
        final duration = endTime.difference(session.startTime).inMinutes;
        
        final updatedSession = session.copyWith(
          endTime: endTime,
          actualDuration: duration,
          actualCalories: actualCalories ?? session.estimatedCalories,
          completedExercises: completedExercises,
          status: 'completed',
          notes: notes ?? session.notes,
          updatedAt: DateTime.now(),
        );

        await updateWorkoutSession(updatedSession);
        
        // Also update daily tracking with calories burned
        if (actualCalories != null && actualCalories > 0) {
          // You can inject DailyTrackingService here or call it from the UI
          print('Calories to add to daily tracking: $actualCalories');
        }
      }
    } catch (e) {
      print('Error completing workout session: $e');
      throw Exception('Failed to complete workout session');
    }
  }

  // Pause workout session
  Future<void> pauseWorkoutSession(String sessionId) async {
    try {
      await _sessionsCollection.doc(sessionId).update({
        'status': 'paused',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Workout session paused: $sessionId');
    } catch (e) {
      print('Error pausing workout session: $e');
      throw Exception('Failed to pause workout session');
    }
  }

  // Resume workout session
  Future<void> resumeWorkoutSession(String sessionId) async {
    try {
      await _sessionsCollection.doc(sessionId).update({
        'status': 'in_progress',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Workout session resumed: $sessionId');
    } catch (e) {
      print('Error resuming workout session: $e');
      throw Exception('Failed to resume workout session');
    }
  }

  // Cancel workout session
  Future<void> cancelWorkoutSession(String sessionId) async {
    try {
      await _sessionsCollection.doc(sessionId).update({
        'status': 'cancelled',
        'endTime': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Workout session cancelled: $sessionId');
    } catch (e) {
      print('Error cancelling workout session: $e');
      throw Exception('Failed to cancel workout session');
    }
  }

  // Get workout session by ID
  Future<WorkoutSession?> getWorkoutSession(String sessionId) async {
    try {
      final doc = await _sessionsCollection.doc(sessionId).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return WorkoutSession.fromFirestore(data);
      }
      
      return null;
    } catch (e) {
      print('Error getting workout session: $e');
      return null;
    }
  }

  // Get user's workout sessions
  Future<List<WorkoutSession>> getUserWorkoutSessions(String userId, {int limit = 20}) async {
    try {
      final query = await _sessionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true)
          .limit(limit)
          .get();
      
      return query.docs
          .map((doc) => WorkoutSession.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user workout sessions: $e');
      return [];
    }
  }

  // Get active workout session for user
  Future<WorkoutSession?> getActiveWorkoutSession(String userId) async {
    try {
      final query = await _sessionsCollection
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['in_progress', 'paused'])
          .orderBy('startTime', descending: true)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data() as Map<String, dynamic>;
        return WorkoutSession.fromFirestore(data);
      }
      
      return null;
    } catch (e) {
      print('Error getting active workout session: $e');
      return null;
    }
  }

  // Get workout statistics for user
  Future<Map<String, dynamic>> getWorkoutStats(String userId, {int days = 30}) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));
      
      final query = await _sessionsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
      
      int totalWorkouts = query.docs.length;
      int totalMinutes = 0;
      int totalCalories = 0;
      Map<String, int> categoryCount = {};
      
      for (var doc in query.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalMinutes += (data['actualDuration'] as int? ?? 0);
        totalCalories += (data['actualCalories'] as int? ?? 0);
        
        final category = data['category'] as String? ?? 'Unknown';
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
      
      return {
        'totalWorkouts': totalWorkouts,
        'totalMinutes': totalMinutes,
        'totalCalories': totalCalories,
        'avgDuration': totalWorkouts > 0 ? totalMinutes / totalWorkouts : 0,
        'avgCalories': totalWorkouts > 0 ? totalCalories / totalWorkouts : 0,
        'categoryBreakdown': categoryCount,
        'daysTracked': days,
      };
    } catch (e) {
      print('Error getting workout stats: $e');
      return {};
    }
  }

  // Get recent workout sessions (last 7 days)
  Future<List<WorkoutSession>> getRecentWorkouts(String userId) async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      
      final query = await _sessionsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
          .orderBy('startTime', descending: true)
          .get();
      
      return query.docs
          .map((doc) => WorkoutSession.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting recent workouts: $e');
      return [];
    }
  }
}
