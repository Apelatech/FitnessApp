import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_card.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '7 Days';
  
  final List<String> _periods = ['7 Days', '30 Days', '3 Months', '1 Year'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Analytics'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) => setState(() => _selectedPeriod = value),
            itemBuilder: (context) => _periods
                .map((period) => PopupMenuItem(
                      value: period,
                      child: Text(period),
                    ))
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Workouts'),
            Tab(text: 'Nutrition'),
            Tab(text: 'Body'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildWorkoutsTab(),
          _buildNutritionTab(),
          _buildBodyTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 24),
          _buildKeyMetrics(),
          const SizedBox(height: 24),
          _buildProgressChart(),
          const SizedBox(height: 24),
          _buildAchievements(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _periods.length,
          itemBuilder: (context, index) {
            final period = _periods[index];
            final isSelected = period == _selectedPeriod;
            
            return GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.textLight.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    final metrics = [
      {
        'title': 'Workouts',
        'value': '12',
        'change': '+3',
        'icon': Icons.fitness_center,
        'color': AppColors.accent,
      },
      {
        'title': 'Calories Burned',
        'value': '3,240',
        'change': '+15%',
        'icon': Icons.local_fire_department,
        'color': AppColors.secondary,
      },
      {
        'title': 'Active Days',
        'value': '5/7',
        'change': '71%',
        'icon': Icons.calendar_today,
        'color': AppColors.success,
      },
      {
        'title': 'Avg Heart Rate',
        'value': '142',
        'change': '+2 bpm',
        'icon': Icons.favorite,
        'color': AppColors.error,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics ($_selectedPeriod)',
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
            childAspectRatio: 1.2,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: CustomCard(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (metric['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            metric['icon'] as IconData,
                            color: metric['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            metric['change'] as String,
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      metric['title'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      metric['value'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
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

  Widget _buildProgressChart() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 250),
                        FlSpot(1, 320),
                        FlSpot(2, 180),
                        FlSpot(3, 410),
                        FlSpot(4, 360),
                        FlSpot(5, 480),
                        FlSpot(6, 290),
                      ],
                      isCurved: true,
                      gradient: AppColors.accentGradient,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.accent,
                            strokeWidth: 2,
                            strokeColor: AppColors.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withOpacity(0.3),
                            AppColors.accent.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'title': 'First Workout',
        'description': 'Completed your first workout session',
        'icon': Icons.emoji_events,
        'color': AppColors.warning,
        'unlocked': true,
      },
      {
        'title': 'Week Warrior',
        'description': 'Workout 5 days in a row',
        'icon': Icons.local_fire_department,
        'color': AppColors.accent,
        'unlocked': true,
      },
      {
        'title': 'Calorie Crusher',
        'description': 'Burn 500 calories in one workout',
        'icon': Icons.flash_on,
        'color': AppColors.secondary,
        'unlocked': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final isUnlocked = achievement['unlocked'] as bool;
            
            return FadeInLeft(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: CustomCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? (achievement['color'] as Color).withOpacity(0.1)
                            : AppColors.textLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        achievement['icon'] as IconData,
                        color: isUnlocked
                            ? (achievement['color'] as Color)
                            : AppColors.textLight,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'] as String,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isUnlocked ? AppColors.textPrimary : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement['description'] as String,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUnlocked)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      )
                    else
                      Icon(
                        Icons.lock_outline,
                        color: AppColors.textLight,
                        size: 20,
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

  Widget _buildWorkoutsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWorkoutFrequencyChart(),
          const SizedBox(height: 24),
          _buildWorkoutTypeDistribution(),
          const SizedBox(height: 24),
          _buildIntensityProgress(),
        ],
      ),
    );
  }

  Widget _buildWorkoutFrequencyChart() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Frequency',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3, color: AppColors.accent)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2, color: AppColors.accent)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4, color: AppColors.accent)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1, color: AppColors.accent)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3, color: AppColors.accent)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 2, color: AppColors.accent)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 1, color: AppColors.accent)]),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTypeDistribution() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 40,
                    color: AppColors.accent,
                    title: 'Strength\n40%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: AppColors.secondary,
                    title: 'Cardio\n30%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    color: AppColors.success,
                    title: 'HIIT\n20%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  PieChartSectionData(
                    value: 10,
                    color: AppColors.warning,
                    title: 'Yoga\n10%',
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
        ],
      ),
    );
  }

  Widget _buildIntensityProgress() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intensity Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildIntensityRow('Low', 0.3, AppColors.success),
          const SizedBox(height: 12),
          _buildIntensityRow('Medium', 0.6, AppColors.warning),
          const SizedBox(height: 12),
          _buildIntensityRow('High', 0.8, AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildIntensityRow(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildNutritionTab() {
    return const Center(
      child: Text('Nutrition Analytics Coming Soon'),
    );
  }

  Widget _buildBodyTab() {
    return const Center(
      child: Text('Body Analytics Coming Soon'),
    );
  }

  void _shareProgress() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.image, color: AppColors.accent),
              title: const Text('Generate Report'),
              subtitle: const Text('Create a visual progress report'),
              onTap: () {
                Navigator.pop(context);
                // Generate and share report
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.secondary),
              title: const Text('Share Stats'),
              subtitle: const Text('Share your key metrics'),
              onTap: () {
                Navigator.pop(context);
                // Share stats
              },
            ),
          ],
        ),
      ),
    );
  }
}
