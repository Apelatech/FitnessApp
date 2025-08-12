import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apelatech_fitness/shared/models/daily_tracking.dart';

class DailyTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference get _trackingCollection => _firestore.collection('daily_tracking');

  // Create or update daily tracking for a user
  Future<void> updateDailyTracking(DailyTracking tracking) async {
    try {
      final docId = '${tracking.userId}_${DailyTracking.getDateKey(tracking.date)}';
      final now = DateTime.now();
      
      final trackingData = tracking.copyWith(
        id: docId,
        updatedAt: now,
      ).toJson();

      await _trackingCollection.doc(docId).set(trackingData, SetOptions(merge: true));
      print('Daily tracking updated: $docId');
    } catch (e) {
      print('Error updating daily tracking: $e');
      throw Exception('Failed to update daily tracking');
    }
  }

  // Get daily tracking for a specific user and date
  Future<DailyTracking?> getDailyTracking(String userId, DateTime date) async {
    try {
      final docId = '${userId}_${DailyTracking.getDateKey(date)}';
      final doc = await _trackingCollection.doc(docId).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return DailyTracking.fromFirestore(data);
      }
      
      // Return default tracking for the date if none exists
      return DailyTracking(
        id: docId,
        userId: userId,
        date: date,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error getting daily tracking: $e');
      return null;
    }
  }

  // Get today's tracking for a user
  Future<DailyTracking?> getTodayTracking(String userId) async {
    return await getDailyTracking(userId, DateTime.now());
  }

  // Update water intake
  Future<void> updateWaterIntake(String userId, int waterIntake, {DateTime? date}) async {
    try {
      final trackingDate = date ?? DateTime.now();
      final current = await getDailyTracking(userId, trackingDate);
      
      if (current != null) {
        final updated = current.copyWith(
          waterIntake: waterIntake,
          updatedAt: DateTime.now(),
        );
        await updateDailyTracking(updated);
      }
    } catch (e) {
      print('Error updating water intake: $e');
      throw Exception('Failed to update water intake');
    }
  }

  // Update step count
  Future<void> updateStepCount(String userId, int stepCount, {DateTime? date}) async {
    try {
      final trackingDate = date ?? DateTime.now();
      final current = await getDailyTracking(userId, trackingDate);
      
      if (current != null) {
        final updated = current.copyWith(
          stepCount: stepCount,
          updatedAt: DateTime.now(),
        );
        await updateDailyTracking(updated);
      }
    } catch (e) {
      print('Error updating step count: $e');
      throw Exception('Failed to update step count');
    }
  }

  // Add calories burned
  Future<void> addCaloriesBurned(String userId, int calories, {DateTime? date}) async {
    try {
      final trackingDate = date ?? DateTime.now();
      final current = await getDailyTracking(userId, trackingDate);
      
      if (current != null) {
        final updated = current.copyWith(
          caloriesBurned: current.caloriesBurned + calories,
          updatedAt: DateTime.now(),
        );
        await updateDailyTracking(updated);
      }
    } catch (e) {
      print('Error adding calories burned: $e');
      throw Exception('Failed to add calories burned');
    }
  }

  // Update weight
  Future<void> updateWeight(String userId, double weight, {DateTime? date}) async {
    try {
      final trackingDate = date ?? DateTime.now();
      final current = await getDailyTracking(userId, trackingDate);
      
      if (current != null) {
        final updated = current.copyWith(
          weight: weight,
          updatedAt: DateTime.now(),
        );
        await updateDailyTracking(updated);
      }
    } catch (e) {
      print('Error updating weight: $e');
      throw Exception('Failed to update weight');
    }
  }

  // Get tracking history for a user (last 30 days)
  Future<List<DailyTracking>> getTrackingHistory(String userId, {int days = 30}) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));
      
      final query = await _trackingCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get();
      
      return query.docs
          .map((doc) => DailyTracking.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting tracking history: $e');
      return [];
    }
  }

  // Get weekly summary
  Future<Map<String, dynamic>> getWeeklySummary(String userId) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 7));
      
      final trackingData = await _trackingCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
      
      int totalWater = 0;
      int totalSteps = 0;
      int totalCalories = 0;
      double avgWeight = 0;
      int weightEntries = 0;
      
      for (var doc in trackingData.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalWater += (data['waterIntake'] as int? ?? 0);
        totalSteps += (data['stepCount'] as int? ?? 0);
        totalCalories += (data['caloriesBurned'] as int? ?? 0);
        
        final weight = data['weight'] as double? ?? 0;
        if (weight > 0) {
          avgWeight += weight;
          weightEntries++;
        }
      }
      
      return {
        'totalWater': totalWater,
        'totalSteps': totalSteps,
        'totalCalories': totalCalories,
        'avgWeight': weightEntries > 0 ? avgWeight / weightEntries : 0,
        'daysTracked': trackingData.docs.length,
      };
    } catch (e) {
      print('Error getting weekly summary: $e');
      return {};
    }
  }
}
