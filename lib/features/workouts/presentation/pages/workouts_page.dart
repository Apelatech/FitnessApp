import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/workout_tracking_service.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/models/workout.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedGoalIndex = 0;
  final WorkoutTrackingService _workoutService = WorkoutTrackingService();
  
  final List<String> _fitnessGoals = [
    'All',
    'Fat Loss',
    'Muscle Gain',
    'Strength',
    'Endurance',
    'Flexibility',
  ];

  // Fat Loss Workouts (10 workouts)
  final List<Workout> _fatLossWorkouts = [
    Workout(
      id: 'fl1',
      name: 'HIIT Fat Burner',
      category: 'Fat Loss',
      duration: 20,
      calories: 280,
      difficulty: 'Intermediate',
      description: 'High-intensity interval training designed to maximize calorie burn and boost metabolism for hours after your workout.',
      exercises: [
        Exercise(id: '1', name: 'Jumping Jacks', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Full Body']),
        Exercise(id: '2', name: 'Burpees', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Full Body']),
        Exercise(id: '3', name: 'Mountain Climbers', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Core', 'Arms']),
      ],
    ),
    Workout(
      id: 'fl2',
      name: 'Cardio Blast',
      category: 'Fat Loss',
      duration: 20,
      calories: 250,
      difficulty: 'Beginner',
      description: 'A dynamic cardio workout that combines fun movements to keep your heart rate elevated and burn maximum calories.',
      exercises: [
        Exercise(id: '4', name: 'High Knees', type: 'cardio', duration: 30, restTime: 15, muscleGroups: ['Legs', 'Core']),
        Exercise(id: '5', name: 'Butt Kicks', type: 'cardio', duration: 30, restTime: 15, muscleGroups: ['Legs']),
        Exercise(id: '6', name: 'Side Steps', type: 'cardio', duration: 30, restTime: 15, muscleGroups: ['Legs', 'Glutes']),
      ],
    ),
    Workout(
      id: 'fl3',
      name: 'Tabata Torch',
      category: 'Fat Loss',
      duration: 20,
      calories: 320,
      difficulty: 'Advanced',
      description: 'Intense 4-minute Tabata rounds that will torch calories and improve your anaerobic capacity in a short time.',
      exercises: [
        Exercise(id: '7', name: 'Squat Jumps', type: 'cardio', duration: 20, restTime: 10, muscleGroups: ['Legs', 'Glutes']),
        Exercise(id: '8', name: 'Push-up Burpees', type: 'cardio', duration: 20, restTime: 10, muscleGroups: ['Full Body']),
        Exercise(id: '9', name: 'Plank Jacks', type: 'cardio', duration: 20, restTime: 10, muscleGroups: ['Core', 'Shoulders']),
      ],
    ),
    Workout(
      id: 'fl4',
      name: 'Circuit Shred',
      category: 'Fat Loss',
      duration: 20,
      calories: 275,
      difficulty: 'Intermediate',
      description: 'A fast-paced circuit combining strength and cardio movements to maximize fat burning in minimal time.',
      exercises: [
        Exercise(id: '10', name: 'Thrusters', type: 'cardio', duration: 40, restTime: 20, muscleGroups: ['Full Body']),
        Exercise(id: '11', name: 'Bear Crawls', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Full Body']),
        Exercise(id: '12', name: 'Star Jumps', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Full Body']),
      ],
    ),
    Workout(
      id: 'fl5',
      name: 'Metabolic Meltdown',
      category: 'Fat Loss',
      duration: 20,
      calories: 300,
      difficulty: 'Advanced',
      description: 'A metabolic conditioning workout that combines compound movements to maximize calorie burn and afterburn effect.',
      exercises: [
        Exercise(id: '13', name: 'Kettlebell Swings', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Full Body']),
        Exercise(id: '14', name: 'Box Jumps', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Legs', 'Glutes']),
        Exercise(id: '15', name: 'Battle Ropes', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Arms', 'Core']),
      ],
    ),
    Workout(
      id: 'fl6',
      name: 'Dance Cardio',
      category: 'Fat Loss',
      duration: 20,
      calories: 220,
      difficulty: 'Beginner',
      description: 'Fun, dance-inspired movements that make cardio enjoyable while burning calories and improving coordination.',
      exercises: [
        Exercise(id: '16', name: 'Grapevines', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Legs', 'Core']),
        Exercise(id: '17', name: 'Hip Circles', type: 'cardio', duration: 30, restTime: 15, muscleGroups: ['Core', 'Hips']),
        Exercise(id: '18', name: 'Arm Waves', type: 'cardio', duration: 30, restTime: 15, muscleGroups: ['Arms', 'Core']),
      ],
    ),
    Workout(
      id: 'fl7',
      name: 'Sprint Intervals',
      category: 'Fat Loss',
      duration: 20,
      calories: 340,
      difficulty: 'Advanced',
      description: 'High-intensity sprint intervals that rapidly increase heart rate and maximize fat oxidation in a short timeframe.',
      exercises: [
        Exercise(id: '19', name: 'Running in Place', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Legs', 'Core']),
        Exercise(id: '20', name: 'Fast Feet', type: 'cardio', duration: 20, restTime: 40, muscleGroups: ['Legs']),
        Exercise(id: '21', name: 'Lateral Shuffles', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Legs', 'Glutes']),
      ],
    ),
    Workout(
      id: 'fl8',
      name: 'Core Cardio Fusion',
      category: 'Fat Loss',
      duration: 20,
      calories: 260,
      difficulty: 'Intermediate',
      description: 'A unique blend of core strengthening and cardio exercises that target your midsection while burning calories.',
      exercises: [
        Exercise(id: '22', name: 'Russian Twists', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Core']),
        Exercise(id: '23', name: 'Bicycle Crunches', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Core']),
        Exercise(id: '24', name: 'Plank Up-Downs', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Core', 'Arms']),
      ],
    ),
    Workout(
      id: 'fl9',
      name: 'Plyometric Power',
      category: 'Fat Loss',
      duration: 20,
      calories: 310,
      difficulty: 'Advanced',
      description: 'Explosive plyometric exercises that build power while creating a massive caloric demand on your body.',
      exercises: [
        Exercise(id: '25', name: 'Jump Squats', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Legs', 'Glutes']),
        Exercise(id: '26', name: 'Tuck Jumps', type: 'cardio', duration: 20, restTime: 40, muscleGroups: ['Legs', 'Core']),
        Exercise(id: '27', name: 'Lateral Bounds', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Legs', 'Glutes']),
      ],
    ),
    Workout(
      id: 'fl10',
      name: 'Bodyweight Burn',
      category: 'Fat Loss',
      duration: 20,
      calories: 240,
      difficulty: 'Beginner',
      description: 'Accessible bodyweight movements that anyone can do to start their fat loss journey effectively.',
      exercises: [
        Exercise(id: '28', name: 'Wall Sits', type: 'cardio', duration: 30, restTime: 30, muscleGroups: ['Legs', 'Glutes']),
        Exercise(id: '29', name: 'Arm Circles', type: 'cardio', duration: 30, restTime: 15, muscleGroups: ['Arms', 'Shoulders']),
        Exercise(id: '30', name: 'Marching in Place', type: 'cardio', duration: 45, restTime: 15, muscleGroups: ['Legs', 'Core']),
      ],
    ),
  ];

  // Muscle Gain Workouts (10 workouts)
  final List<Workout> _muscleGainWorkouts = [
    Workout(
      id: 'mg1',
      name: 'Upper Body Builder',
      category: 'Muscle Gain',
      duration: 20,
      calories: 180,
      difficulty: 'Intermediate',
      description: 'Comprehensive upper body workout targeting chest, shoulders, and arms for maximum muscle development.',
      exercises: [
        Exercise(id: '31', name: 'Push-ups', type: 'strength', sets: 3, reps: 12, restTime: 60, muscleGroups: ['Chest', 'Arms']),
        Exercise(id: '32', name: 'Pike Push-ups', type: 'strength', sets: 3, reps: 10, restTime: 60, muscleGroups: ['Shoulders']),
        Exercise(id: '33', name: 'Tricep Dips', type: 'strength', sets: 3, reps: 8, restTime: 60, muscleGroups: ['Arms']),
      ],
    ),
    Workout(
      id: 'mg2',
      name: 'Lower Power',
      category: 'Muscle Gain',
      duration: 20,
      calories: 200,
      difficulty: 'Intermediate',
      description: 'Intense lower body focused routine designed to build powerful legs and glutes through progressive overload.',
      exercises: [
        Exercise(id: '34', name: 'Squats', type: 'strength', sets: 4, reps: 15, restTime: 90, muscleGroups: ['Legs', 'Glutes']),
        Exercise(id: '35', name: 'Lunges', type: 'strength', sets: 3, reps: 12, restTime: 60, muscleGroups: ['Legs', 'Glutes']),
        Exercise(id: '36', name: 'Calf Raises', type: 'strength', sets: 3, reps: 20, restTime: 45, muscleGroups: ['Calves']),
      ],
    ),
    Workout(
      id: 'mg3',
      name: 'Core Constructor',
      category: 'Muscle Gain',
      duration: 20,
      calories: 160,
      difficulty: 'Beginner',
      description: 'Core-focused workout that builds a strong foundation and develops visible abdominal muscles.',
      exercises: [
        Exercise(id: '37', name: 'Planks', type: 'strength', duration: 60, restTime: 60, muscleGroups: ['Core']),
        Exercise(id: '38', name: 'Crunches', type: 'strength', sets: 3, reps: 20, restTime: 45, muscleGroups: ['Core']),
        Exercise(id: '39', name: 'Dead Bug', type: 'strength', sets: 3, reps: 10, restTime: 45, muscleGroups: ['Core']),
      ],
    ),
    Workout(
      id: 'mg4',
      name: 'Full Body Mass',
      category: 'Muscle Gain',
      duration: 20,
      calories: 220,
      difficulty: 'Advanced',
      description: 'Complete full-body routine utilizing compound movements to stimulate maximum muscle growth.',
      exercises: [
        Exercise(id: '40', name: 'Burpees', type: 'strength', sets: 3, reps: 8, restTime: 90, muscleGroups: ['Full Body']),
        Exercise(id: '41', name: 'Pull-ups', type: 'strength', sets: 3, reps: 6, restTime: 120, muscleGroups: ['Back', 'Arms']),
        Exercise(id: '42', name: 'Jump Squats', type: 'strength', sets: 3, reps: 10, restTime: 60, muscleGroups: ['Legs']),
      ],
    ),
    Workout(
      id: 'mg5',
      name: 'Back & Biceps',
      category: 'Muscle Gain',
      duration: 20,
      calories: 170,
      difficulty: 'Intermediate',
      description: 'Targeted back and bicep workout to build a wide, strong back and sculpted arms.',
      exercises: [
        Exercise(id: '43', name: 'Reverse Fly', type: 'strength', sets: 3, reps: 12, restTime: 60, muscleGroups: ['Back']),
        Exercise(id: '44', name: 'Superman', type: 'strength', sets: 3, reps: 15, restTime: 45, muscleGroups: ['Back']),
        Exercise(id: '45', name: 'Wall Handstand', type: 'strength', duration: 30, restTime: 90, muscleGroups: ['Shoulders', 'Arms']),
      ],
    ),
    Workout(
      id: 'mg6',
      name: 'Chest Sculptor',
      category: 'Muscle Gain',
      duration: 20,
      calories: 190,
      difficulty: 'Intermediate',
      description: 'Chest-focused routine with various push-up variations to build a powerful and defined chest.',
      exercises: [
        Exercise(id: '46', name: 'Wide Push-ups', type: 'strength', sets: 3, reps: 10, restTime: 60, muscleGroups: ['Chest']),
        Exercise(id: '47', name: 'Diamond Push-ups', type: 'strength', sets: 3, reps: 8, restTime: 90, muscleGroups: ['Chest', 'Arms']),
        Exercise(id: '48', name: 'Incline Push-ups', type: 'strength', sets: 3, reps: 12, restTime: 60, muscleGroups: ['Chest']),
      ],
    ),
    Workout(
      id: 'mg7',
      name: 'Shoulder Shaper',
      category: 'Muscle Gain',
      duration: 20,
      calories: 175,
      difficulty: 'Beginner',
      description: 'Comprehensive shoulder workout to build rounded, defined deltoids and improve upper body aesthetics.',
      exercises: [
        Exercise(id: '49', name: 'Shoulder Shrugs', type: 'strength', sets: 3, reps: 15, restTime: 45, muscleGroups: ['Shoulders']),
        Exercise(id: '50', name: 'Arm Raises', type: 'strength', sets: 3, reps: 12, restTime: 45, muscleGroups: ['Shoulders']),
        Exercise(id: '51', name: 'Wall Angels', type: 'strength', sets: 3, reps: 15, restTime: 45, muscleGroups: ['Shoulders']),
      ],
    ),
    Workout(
      id: 'mg8',
      name: 'Glute Gains',
      category: 'Muscle Gain',
      duration: 20,
      calories: 185,
      difficulty: 'Intermediate',
      description: 'Glute-focused workout designed to build strong, shapely glutes through targeted exercises.',
      exercises: [
        Exercise(id: '52', name: 'Glute Bridges', type: 'strength', sets: 3, reps: 15, restTime: 60, muscleGroups: ['Glutes']),
        Exercise(id: '53', name: 'Single Leg Glute Bridge', type: 'strength', sets: 3, reps: 10, restTime: 60, muscleGroups: ['Glutes']),
        Exercise(id: '54', name: 'Fire Hydrants', type: 'strength', sets: 3, reps: 12, restTime: 45, muscleGroups: ['Glutes']),
      ],
    ),
    Workout(
      id: 'mg9',
      name: 'Arm Amplifier',
      category: 'Muscle Gain',
      duration: 20,
      calories: 165,
      difficulty: 'Beginner',
      description: 'Focused arm workout targeting biceps and triceps for improved arm definition and strength.',
      exercises: [
        Exercise(id: '55', name: 'Wall Push-ups', type: 'strength', sets: 3, reps: 15, restTime: 45, muscleGroups: ['Arms']),
        Exercise(id: '56', name: 'Arm Circles', type: 'strength', sets: 3, reps: 20, restTime: 30, muscleGroups: ['Arms']),
        Exercise(id: '57', name: 'Isometric Holds', type: 'strength', duration: 30, restTime: 60, muscleGroups: ['Arms']),
      ],
    ),
    Workout(
      id: 'mg10',
      name: 'Foundation Builder',
      category: 'Muscle Gain',
      duration: 20,
      calories: 210,
      difficulty: 'Advanced',
      description: 'Advanced compound movement workout that builds overall muscle mass and functional strength.',
      exercises: [
        Exercise(id: '58', name: 'Hindu Push-ups', type: 'strength', sets: 3, reps: 8, restTime: 90, muscleGroups: ['Full Body']),
        Exercise(id: '59', name: 'Pistol Squats', type: 'strength', sets: 3, reps: 5, restTime: 120, muscleGroups: ['Legs']),
        Exercise(id: '60', name: 'L-Sits', type: 'strength', duration: 20, restTime: 90, muscleGroups: ['Core', 'Arms']),
      ],
    ),
  ];

  // Strength Workouts (10 workouts)
  final List<Workout> _strengthWorkouts = [
    Workout(
      id: 'st1',
      name: 'Power Foundation',
      category: 'Strength',
      duration: 20,
      calories: 190,
      difficulty: 'Beginner',
      description: 'Essential strength-building exercises that form the foundation for all advanced strength training.',
      exercises: [
        Exercise(id: '61', name: 'Bodyweight Squats', type: 'strength', sets: 4, reps: 12, restTime: 90, muscleGroups: ['Legs']),
        Exercise(id: '62', name: 'Push-ups', type: 'strength', sets: 3, reps: 10, restTime: 60, muscleGroups: ['Chest', 'Arms']),
        Exercise(id: '63', name: 'Planks', type: 'strength', duration: 45, restTime: 60, muscleGroups: ['Core']),
      ],
    ),
    Workout(
      id: 'st2',
      name: 'Iron Core',
      category: 'Strength',
      duration: 20,
      calories: 170,
      difficulty: 'Intermediate',
      description: 'Intense core strengthening routine that builds bulletproof abdominals and spine stability.',
      exercises: [
        Exercise(id: '64', name: 'Hollow Body Hold', type: 'strength', duration: 30, restTime: 60, muscleGroups: ['Core']),
        Exercise(id: '65', name: 'V-Ups', type: 'strength', sets: 3, reps: 12, restTime: 60, muscleGroups: ['Core']),
        Exercise(id: '66', name: 'Side Planks', type: 'strength', duration: 30, restTime: 45, muscleGroups: ['Core']),
      ],
    ),
    Workout(
      id: 'st3',
      name: 'Upper Domination',
      category: 'Strength',
      duration: 20,
      calories: 200,
      difficulty: 'Advanced',
      description: 'Advanced upper body strength workout focusing on maximum force production and muscle recruitment.',
      exercises: [
        Exercise(id: '67', name: 'Archer Push-ups', type: 'strength', sets: 3, reps: 6, restTime: 120, muscleGroups: ['Chest', 'Arms']),
        Exercise(id: '68', name: 'Handstand Hold', type: 'strength', duration: 15, restTime: 120, muscleGroups: ['Shoulders', 'Arms']),
        Exercise(id: '69', name: 'Pseudo Planche', type: 'strength', duration: 20, restTime: 90, muscleGroups: ['Shoulders', 'Core']),
      ],
    ),
    Workout(
      id: 'st4',
      name: 'Leg Fortress',
      category: 'Strength',
      duration: 20,
      calories: 210,
      difficulty: 'Intermediate',
      description: 'Lower body strength routine designed to build powerful legs and unshakeable stability.',
      exercises: [
        Exercise(id: '70', name: 'Single Leg Squats', type: 'strength', sets: 3, reps: 8, restTime: 90, muscleGroups: ['Legs']),
        Exercise(id: '71', name: 'Bulgarian Split Squats', type: 'strength', sets: 3, reps: 10, restTime: 90, muscleGroups: ['Legs']),
        Exercise(id: '72', name: 'Wall Sit', type: 'strength', duration: 60, restTime: 90, muscleGroups: ['Legs']),
      ],
    ),
    Workout(
      id: 'st5',
      name: 'Functional Power',
      category: 'Strength',
      duration: 20,
      calories: 220,
      difficulty: 'Advanced',
      description: 'Functional strength movements that translate directly to real-world power and athletic performance.',
      exercises: [
        Exercise(id: '73', name: 'Burpee Variations', type: 'strength', sets: 3, reps: 6, restTime: 120, muscleGroups: ['Full Body']),
        Exercise(id: '74', name: 'Turkish Get-ups', type: 'strength', sets: 2, reps: 4, restTime: 150, muscleGroups: ['Full Body']),
        Exercise(id: '75', name: 'Bear Crawls', type: 'strength', duration: 30, restTime: 90, muscleGroups: ['Full Body']),
      ],
    ),
    Workout(
      id: 'st6',
      name: 'Back Fortress',
      category: 'Strength',
      duration: 20,
      calories: 185,
      difficulty: 'Intermediate',
      description: 'Back-strengthening routine to build a strong posterior chain and improve posture.',
      exercises: [
        Exercise(id: '76', name: 'Superman Holds', type: 'strength', duration: 30, restTime: 60, muscleGroups: ['Back']),
        Exercise(id: '77', name: 'Reverse Snow Angels', type: 'strength', sets: 3, reps: 15, restTime: 60, muscleGroups: ['Back']),
        Exercise(id: '78', name: 'Good Mornings', type: 'strength', sets: 3, reps: 12, restTime: 60, muscleGroups: ['Back', 'Glutes']),
      ],
    ),
    Workout(
      id: 'st7',
      name: 'Grip & Carry',
      category: 'Strength',
      duration: 20,
      calories: 175,
      difficulty: 'Beginner',
      description: 'Grip and carrying strength workout that builds practical, everyday functional strength.',
      exercises: [
        Exercise(id: '79', name: 'Farmer Walks', type: 'strength', duration: 45, restTime: 60, muscleGroups: ['Full Body']),
        Exercise(id: '80', name: 'Dead Hangs', type: 'strength', duration: 20, restTime: 90, muscleGroups: ['Arms', 'Back']),
        Exercise(id: '81', name: 'Suitcase Carry', type: 'strength', duration: 30, restTime: 60, muscleGroups: ['Core', 'Arms']),
      ],
    ),
    Workout(
      id: 'st8',
      name: 'Unilateral Force',
      category: 'Strength',
      duration: 20,
      calories: 195,
      difficulty: 'Advanced',
      description: 'Single-limb strength exercises that eliminate imbalances and build true functional power.',
      exercises: [
        Exercise(id: '82', name: 'Single Arm Push-ups', type: 'strength', sets: 2, reps: 4, restTime: 150, muscleGroups: ['Chest', 'Arms']),
        Exercise(id: '83', name: 'Shrimp Squats', type: 'strength', sets: 2, reps: 3, restTime: 120, muscleGroups: ['Legs']),
        Exercise(id: '84', name: 'Single Leg RDL', type: 'strength', sets: 3, reps: 8, restTime: 90, muscleGroups: ['Legs', 'Glutes']),
      ],
    ),
    Workout(
      id: 'st9',
      name: 'Isometric Iron',
      category: 'Strength',
      duration: 20,
      calories: 160,
      difficulty: 'Intermediate',
      description: 'Isometric holds that build incredible strength and muscular endurance through static contractions.',
      exercises: [
        Exercise(id: '85', name: 'Plank Variations', type: 'strength', duration: 45, restTime: 60, muscleGroups: ['Core']),
        Exercise(id: '86', name: 'Wall Sit Hold', type: 'strength', duration: 60, restTime: 90, muscleGroups: ['Legs']),
        Exercise(id: '87', name: 'Glute Bridge Hold', type: 'strength', duration: 45, restTime: 60, muscleGroups: ['Glutes']),
      ],
    ),
    Workout(
      id: 'st10',
      name: 'Compound King',
      category: 'Strength',
      duration: 20,
      calories: 240,
      difficulty: 'Advanced',
      description: 'The ultimate compound movement workout that builds total-body strength and coordination.',
      exercises: [
        Exercise(id: '88', name: 'Muscle-ups', type: 'strength', sets: 2, reps: 3, restTime: 180, muscleGroups: ['Full Body']),
        Exercise(id: '89', name: 'Human Flag Progression', type: 'strength', duration: 10, restTime: 120, muscleGroups: ['Core', 'Arms']),
        Exercise(id: '90', name: 'One Arm Handstand', type: 'strength', duration: 5, restTime: 180, muscleGroups: ['Shoulders', 'Core']),
      ],
    ),
  ];

  // Combined workout list based on selected category
  List<Workout> get _filteredWorkouts {
    if (_selectedGoalIndex == 0) {
      // All workouts
      return [..._fatLossWorkouts, ..._muscleGainWorkouts, ..._strengthWorkouts];
    } else if (_selectedGoalIndex == 1) {
      // Fat Loss
      return _fatLossWorkouts;
    } else if (_selectedGoalIndex == 2) {
      // Muscle Gain
      return _muscleGainWorkouts;
    } else if (_selectedGoalIndex == 3) {
      // Strength
      return _strengthWorkouts;
    } else {
      // For other categories, return featured workouts for now
      return _fatLossWorkouts.take(3).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _showWorkoutCalendar,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Featured'),
            Tab(text: 'My Plans'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeaturedTab(),
          _buildMyPlansTab(),
          _buildHistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startQuickWorkout,
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Quick Start'),
      ),
    );
  }

  Widget _buildFeaturedTab() {
    return Column(
      children: [
        _buildGoalSelector(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayWorkout(),
                const SizedBox(height: 24),
                _buildFeaturedWorkouts(),
                const SizedBox(height: 24),
                _buildWorkoutCategories(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _fitnessGoals.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedGoalIndex;
          return FadeInLeft(
            duration: Duration(milliseconds: 300 + (index * 100)),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGoalIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  _fitnessGoals[index],
                  style: TextStyle(
                    color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayWorkout() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: CustomCard(
        gradient: AppColors.blueGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.today,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Workout',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Full Body Circuit',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                GradientButton(
                  text: 'Start',
                  gradient: LinearGradient(
                    colors: [AppColors.textWhite.withOpacity(0.2), AppColors.textWhite.withOpacity(0.3)],
                  ),
                  width: 80,
                  height: 36,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildWorkoutStat('35 min', 'Duration'),
                _buildWorkoutStat('280 cal', 'Calories'),
                _buildWorkoutStat('8 exercises', 'Exercises'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutStat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textWhite.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedWorkouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Workouts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredWorkouts.length,
          itemBuilder: (context, index) {
            final workout = _filteredWorkouts[index];
            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: _buildWorkoutCard(workout),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return CustomCard(
      onTap: () => _showWorkoutDetails(workout),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getCategoryColor(workout.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(workout.category),
              color: _getCategoryColor(workout.category),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workout.description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      '${workout.duration} min',
                      Icons.timer,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      '${workout.calories} cal',
                      Icons.local_fire_department,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      workout.difficulty,
                      Icons.signal_cellular_alt,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textLight,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCategories() {
    final categories = [
      {'name': 'Strength', 'icon': Icons.fitness_center, 'color': AppColors.accent},
      {'name': 'Cardio', 'icon': Icons.directions_run, 'color': AppColors.secondary},
      {'name': 'Yoga', 'icon': Icons.self_improvement, 'color': AppColors.success},
      {'name': 'HIIT', 'icon': Icons.flash_on, 'color': AppColors.warning},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: CustomCard(
                onTap: () => _showCategoryWorkouts(category['name'] as String),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          category['name'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMyPlansTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'No custom plans yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first workout plan',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'No workout history',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete your first workout to see history',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'strength':
        return AppColors.accent;
      case 'cardio':
        return AppColors.secondary;
      case 'yoga':
        return AppColors.success;
      case 'hiit':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'yoga':
        return Icons.self_improvement;
      case 'hiit':
        return Icons.flash_on;
      default:
        return Icons.fitness_center;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Workouts'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter workout name or category...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showWorkoutCalendar() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Workout Calendar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('Coming soon! Schedule your workouts in advance.'),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuickWorkout() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Start',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.flash_on, color: AppColors.accent),
              title: const Text('5-Min Energy Boost'),
              subtitle: const Text('Quick cardio session'),
              onTap: () {
                Navigator.pop(context);
                _startQuickCardioWorkout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.secondary),
              title: const Text('10-Min Strength'),
              subtitle: const Text('Bodyweight exercises'),
              onTap: () {
                Navigator.pop(context);
                _startQuickStrengthWorkout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.self_improvement, color: AppColors.success),
              title: const Text('15-Min Stretch'),
              subtitle: const Text('Flexibility and relaxation'),
              onTap: () {
                Navigator.pop(context);
                _startQuickStretchWorkout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutDetails(Workout workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      workout.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip('${workout.duration} min', Icons.timer),
                  const SizedBox(width: 8),
                  _buildInfoChip('${workout.calories} cal', Icons.local_fire_department),
                  const SizedBox(width: 8),
                  _buildInfoChip(workout.difficulty, Icons.signal_cellular_alt),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                workout.description ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Exercises (${workout.exercises.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: workout.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = workout.exercises[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent.withOpacity(0.1),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(exercise.name),
                      subtitle: Text(
                        exercise.duration != null
                            ? '${exercise.duration}s'
                            : '${exercise.sets} sets × ${exercise.reps} reps',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                text: 'Start Workout',
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(context);
                  _startWorkout(workout);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryWorkouts(String category) {
    // Implementation for showing category-specific workouts
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Showing $category workouts')),
    );
  }

  // Quick workout methods that integrate with Firebase
  Future<void> _startQuickCardioWorkout() async {
    final quickCardio = Workout(
      id: 'quick_cardio',
      name: '5-Min Energy Boost',
      category: 'Fat Loss',
      duration: 5,
      calories: 50,
      difficulty: 'Beginner',
      description: 'Quick cardio session to boost energy',
      exercises: [
        Exercise(id: 'qc1', name: 'Jumping Jacks', type: 'cardio', duration: 60, restTime: 30, muscleGroups: ['Full Body']),
        Exercise(id: 'qc2', name: 'High Knees', type: 'cardio', duration: 60, restTime: 30, muscleGroups: ['Legs']),
        Exercise(id: 'qc3', name: 'Butt Kicks', type: 'cardio', duration: 60, restTime: 30, muscleGroups: ['Legs']),
      ],
    );
    await _startWorkout(quickCardio);
  }

  Future<void> _startQuickStrengthWorkout() async {
    final quickStrength = Workout(
      id: 'quick_strength',
      name: '10-Min Strength',
      category: 'Muscle Gain',
      duration: 10,
      calories: 80,
      difficulty: 'Intermediate',
      description: 'Bodyweight strength exercises',
      exercises: [
        Exercise(id: 'qs1', name: 'Push-ups', type: 'strength', sets: 2, reps: 10, restTime: 60, muscleGroups: ['Chest', 'Arms']),
        Exercise(id: 'qs2', name: 'Squats', type: 'strength', sets: 2, reps: 15, restTime: 60, muscleGroups: ['Legs']),
        Exercise(id: 'qs3', name: 'Planks', type: 'strength', duration: 30, restTime: 60, muscleGroups: ['Core']),
      ],
    );
    await _startWorkout(quickStrength);
  }

  Future<void> _startQuickStretchWorkout() async {
    final quickStretch = Workout(
      id: 'quick_stretch',
      name: '15-Min Stretch',
      category: 'Flexibility',
      duration: 15,
      calories: 40,
      difficulty: 'Beginner',
      description: 'Flexibility and relaxation routine',
      exercises: [
        Exercise(id: 'qst1', name: 'Cat-Cow Stretch', type: 'stretching', duration: 60, restTime: 15, muscleGroups: ['Back']),
        Exercise(id: 'qst2', name: 'Child\'s Pose', type: 'stretching', duration: 90, restTime: 15, muscleGroups: ['Back', 'Shoulders']),
        Exercise(id: 'qst3', name: 'Forward Fold', type: 'stretching', duration: 60, restTime: 15, muscleGroups: ['Back', 'Legs']),
      ],
    );
    await _startWorkout(quickStretch);
  }

  // Main method to start any workout using Firebase
  Future<void> _startWorkout(Workout workout) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Start workout session in Firebase
      final session = await _workoutService.startWorkout(workout);
      
      // Close loading indicator
      Navigator.pop(context);

      if (session != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Started workout: ${workout.name}'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to workout session page (you can implement this)
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (context) => WorkoutSessionPage(session: session),
        // ));
      }
    } catch (e) {
      // Close loading indicator if still showing
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start workout: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
