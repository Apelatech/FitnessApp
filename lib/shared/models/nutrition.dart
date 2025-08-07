class NutritionEntry {
  final String id;
  final String foodName;
  final String category;
  final int calories;
  final double protein; // grams
  final double carbs; // grams
  final double fat; // grams
  final double fiber; // grams
  final double sugar; // grams
  final double sodium; // mg
  final double servingSize; // grams
  final DateTime consumedAt;
  final String? imageUrl;
  final String? notes;

  const NutritionEntry({
    required this.id,
    required this.foodName,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sugar = 0,
    this.sodium = 0,
    this.servingSize = 100,
    required this.consumedAt,
    this.imageUrl,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodName': foodName,
      'category': category,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'servingSize': servingSize,
      'consumedAt': consumedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'notes': notes,
    };
  }

  factory NutritionEntry.fromJson(Map<String, dynamic> json) {
    return NutritionEntry(
      id: json['id'],
      foodName: json['foodName'],
      category: json['category'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      fiber: json['fiber']?.toDouble() ?? 0,
      sugar: json['sugar']?.toDouble() ?? 0,
      sodium: json['sodium']?.toDouble() ?? 0,
      servingSize: json['servingSize']?.toDouble() ?? 100,
      consumedAt: DateTime.parse(json['consumedAt']),
      imageUrl: json['imageUrl'],
      notes: json['notes'],
    );
  }

  double get totalMacros => protein + carbs + fat;
  
  double get proteinPercent => protein * 4 / calories * 100;
  double get carbsPercent => carbs * 4 / calories * 100;
  double get fatPercent => fat * 9 / calories * 100;
}

class DailyNutritionGoals {
  final int calorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
  final double fiberGoal;
  final double waterGoal; // liters

  const DailyNutritionGoals({
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    this.fiberGoal = 25,
    this.waterGoal = 2.5,
  });

  Map<String, dynamic> toJson() {
    return {
      'calorieGoal': calorieGoal,
      'proteinGoal': proteinGoal,
      'carbsGoal': carbsGoal,
      'fatGoal': fatGoal,
      'fiberGoal': fiberGoal,
      'waterGoal': waterGoal,
    };
  }

  factory DailyNutritionGoals.fromJson(Map<String, dynamic> json) {
    return DailyNutritionGoals(
      calorieGoal: json['calorieGoal'],
      proteinGoal: json['proteinGoal'].toDouble(),
      carbsGoal: json['carbsGoal'].toDouble(),
      fatGoal: json['fatGoal'].toDouble(),
      fiberGoal: json['fiberGoal']?.toDouble() ?? 25,
      waterGoal: json['waterGoal']?.toDouble() ?? 2.5,
    );
  }
}
