import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
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
  
  final List<String> _fitnessGoals = [
    'All',
    'Fat Loss',
    'Muscle Gain',
    'Strength',
    'Endurance',
    'Flexibility',
  ];

  final List<Workout> _featuredWorkouts = [
    Workout(
      id: '1',
      name: 'HIIT Fat Burner',
      category: 'Cardio',
      duration: 25,
      calories: 300,
      difficulty: 'Intermediate',
      description: 'High-intensity interval training to burn calories fast',
      exercises: [
        Exercise(
          id: '1',
          name: 'Jumping Jacks',
          type: 'cardio',
          duration: 30,
          restTime: 10,
          muscleGroups: ['Full Body'],
        ),
        Exercise(
          id: '2',
          name: 'Burpees',
          type: 'cardio',
          duration: 30,
          restTime: 15,
          muscleGroups: ['Full Body'],
        ),
        Exercise(
          id: '3',
          name: 'Mountain Climbers',
          type: 'cardio',
          duration: 30,
          restTime: 10,
          muscleGroups: ['Core', 'Arms'],
        ),
      ],
    ),
    Workout(
      id: '2',
      name: 'Upper Body Strength',
      category: 'Strength',
      duration: 45,
      calories: 250,
      difficulty: 'Beginner',
      description: 'Build upper body strength with bodyweight exercises',
      exercises: [
        Exercise(
          id: '4',
          name: 'Push-ups',
          type: 'strength',
          sets: 3,
          reps: 12,
          restTime: 60,
          muscleGroups: ['Chest', 'Arms', 'Shoulders'],
        ),
        Exercise(
          id: '5',
          name: 'Pike Push-ups',
          type: 'strength',
          sets: 3,
          reps: 8,
          restTime: 60,
          muscleGroups: ['Shoulders', 'Arms'],
        ),
        Exercise(
          id: '6',
          name: 'Tricep Dips',
          type: 'strength',
          sets: 3,
          reps: 10,
          restTime: 60,
          muscleGroups: ['Arms'],
        ),
      ],
    ),
  ];

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
          itemCount: _featuredWorkouts.length,
          itemBuilder: (context, index) {
            final workout = _featuredWorkouts[index];
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
                // Start quick workout
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.secondary),
              title: const Text('10-Min Strength'),
              subtitle: const Text('Bodyweight exercises'),
              onTap: () {
                Navigator.pop(context);
                // Start strength workout
              },
            ),
            ListTile(
              leading: const Icon(Icons.self_improvement, color: AppColors.success),
              title: const Text('15-Min Stretch'),
              subtitle: const Text('Flexibility and relaxation'),
              onTap: () {
                Navigator.pop(context);
                // Start stretch routine
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
                  // Start workout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryWorkouts(String category) {
    // Navigate to category-specific workouts
  }
}
