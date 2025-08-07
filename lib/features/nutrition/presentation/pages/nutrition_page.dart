import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/models/nutrition.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  final DailyNutritionGoals _goals = const DailyNutritionGoals(
    calorieGoal: 2000,
    proteinGoal: 120,
    carbsGoal: 200,
    fatGoal: 70,
  );

  final List<NutritionEntry> _todayEntries = [
    NutritionEntry(
      id: '1',
      foodName: 'Oatmeal with Berries',
      category: 'Breakfast',
      calories: 350,
      protein: 12,
      carbs: 65,
      fat: 8,
      consumedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NutritionEntry(
      id: '2',
      foodName: 'Grilled Chicken Salad',
      category: 'Lunch',
      calories: 420,
      protein: 35,
      carbs: 25,
      fat: 18,
      consumedAt: DateTime.now().subtract(const Duration(hours: 1)),
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
        title: const Text('Nutrition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _scanFood,
          ),
          IconButton(
            icon: const Icon(Icons.water_drop),
            onPressed: _logWater,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Meal Plans'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildMealPlansTab(),
          _buildHistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFood,
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add),
        label: const Text('Add Food'),
      ),
    );
  }

  Widget _buildTodayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalorieOverview(),
          const SizedBox(height: 24),
          _buildMacroBreakdown(),
          const SizedBox(height: 24),
          _buildTodaysMeals(),
          const SizedBox(height: 24),
          _buildQuickAdd(),
        ],
      ),
    );
  }

  Widget _buildCalorieOverview() {
    final consumedCalories = _todayEntries.fold<int>(
      0, (sum, entry) => sum + entry.calories,
    );
    final remainingCalories = _goals.calorieGoal - consumedCalories;
    final progress = consumedCalories / _goals.calorieGoal;

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: CustomCard(
        gradient: AppColors.primaryGradient,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Today',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$consumedCalories / ${_goals.calorieGoal}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$remainingCalories remaining',
                      style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 8,
                    backgroundColor: AppColors.textWhite.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildCalorieStat('Breakfast', '350', AppColors.accent),
                _buildCalorieStat('Lunch', '420', AppColors.secondary),
                _buildCalorieStat('Dinner', '0', AppColors.success),
                _buildCalorieStat('Snacks', '0', AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieStat(String meal, String calories, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            calories,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            meal,
            style: TextStyle(
              color: AppColors.textWhite.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBreakdown() {
    final totalProtein = _todayEntries.fold<double>(
      0, (sum, entry) => sum + entry.protein,
    );
    final totalCarbs = _todayEntries.fold<double>(
      0, (sum, entry) => sum + entry.carbs,
    );
    final totalFat = _todayEntries.fold<double>(
      0, (sum, entry) => sum + entry.fat,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macronutrients',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 120,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: totalProtein * 4,
                        color: AppColors.accent,
                        title: 'Protein',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                      PieChartSectionData(
                        value: totalCarbs * 4,
                        color: AppColors.secondary,
                        title: 'Carbs',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                      PieChartSectionData(
                        value: totalFat * 9,
                        color: AppColors.success,
                        title: 'Fat',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ],
                    centerSpaceRadius: 0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildMacroRow(
                    'Protein',
                    '${totalProtein.toInt()}g',
                    '${_goals.proteinGoal.toInt()}g',
                    totalProtein / _goals.proteinGoal,
                    AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  _buildMacroRow(
                    'Carbs',
                    '${totalCarbs.toInt()}g',
                    '${_goals.carbsGoal.toInt()}g',
                    totalCarbs / _goals.carbsGoal,
                    AppColors.secondary,
                  ),
                  const SizedBox(height: 12),
                  _buildMacroRow(
                    'Fat',
                    '${totalFat.toInt()}g',
                    '${_goals.fatGoal.toInt()}g',
                    totalFat / _goals.fatGoal,
                    AppColors.success,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroRow(String name, String current, String target, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              '$current / $target',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildTodaysMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Meals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _viewAllMeals,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _todayEntries.length,
          itemBuilder: (context, index) {
            final entry = _todayEntries[index];
            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: _buildMealCard(entry),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMealCard(NutritionEntry entry) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getCategoryColor(entry.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(entry.category),
              color: _getCategoryColor(entry.category),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.foodName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildNutritionInfo('${entry.calories} cal', Icons.local_fire_department),
                    const SizedBox(width: 12),
                    _buildNutritionInfo('${entry.protein.toInt()}g P', Icons.fitness_center),
                    const SizedBox(width: 12),
                    _buildNutritionInfo('${entry.carbs.toInt()}g C', Icons.grass),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMealOptions(entry),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAdd() {
    final quickFoods = [
      {'name': 'Banana', 'calories': '105', 'icon': Icons.eco},
      {'name': 'Apple', 'calories': '95', 'icon': Icons.apple},
      {'name': 'Almonds (1oz)', 'calories': '164', 'icon': Icons.grain},
      {'name': 'Greek Yogurt', 'calories': '130', 'icon': Icons.icecream},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
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
            childAspectRatio: 2.5,
          ),
          itemCount: quickFoods.length,
          itemBuilder: (context, index) {
            final food = quickFoods[index];
            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: CustomCard(
                onTap: () => _quickAddFood(food),
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    Icon(
                      food['icon'] as IconData,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            food['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${food['calories']} cal',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.add,
                      color: AppColors.success,
                      size: 16,
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

  Widget _buildMealPlansTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'Meal Plans Coming Soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AI-powered meal planning will be available soon',
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
            'No nutrition history',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Log your first meal to see history',
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
      case 'breakfast':
        return AppColors.accent;
      case 'lunch':
        return AppColors.secondary;
      case 'dinner':
        return AppColors.success;
      case 'snacks':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.wb_sunny_outlined;
      case 'dinner':
        return Icons.nightlight;
      case 'snacks':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  void _scanFood() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scan Food',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.accent),
              title: const Text('Camera'),
              subtitle: const Text('Take a photo of your food'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera scanning
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner, color: AppColors.secondary),
              title: const Text('Barcode Scanner'),
              subtitle: const Text('Scan product barcode'),
              onTap: () {
                Navigator.pop(context);
                // Implement barcode scanning
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logWater() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Water'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How much water did you drink?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWaterButton('250ml'),
                _buildWaterButton('500ml'),
                _buildWaterButton('750ml'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterButton(String amount) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        // Log water intake
      },
      child: Text(amount),
    );
  }

  void _addFood() {
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
            children: [
              Text(
                'Add Food',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search for food...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Scan with Camera'),
                      onTap: () {
                        Navigator.pop(context);
                        _scanFood();
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Recent Foods'),
                    ),
                    // Add recent foods list here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewAllMeals() {
    // Navigate to all meals view
  }

  void _showMealOptions(NutritionEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.foodName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.secondary),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // Edit meal
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: AppColors.accent),
              title: const Text('Duplicate'),
              onTap: () {
                Navigator.pop(context);
                // Duplicate meal
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                // Delete meal
              },
            ),
          ],
        ),
      ),
    );
  }

  void _quickAddFood(Map<String, dynamic> food) {
    // Quick add food to today's log
  }
}
