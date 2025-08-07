import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';

class OnboardingSplashPage extends StatefulWidget {
  const OnboardingSplashPage({super.key});

  @override
  State<OnboardingSplashPage> createState() => _OnboardingSplashPageState();
}

class _OnboardingSplashPageState extends State<OnboardingSplashPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _waveController;
  
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _waveAnimation;
  
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPageTimer;
  
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      icon: Icons.psychology,
      title: 'AI-Powered\nCoaching',
      subtitle: 'Get personalized fitness guidance from our advanced AI coach',
      color: AppColors.accent,
    ),
    OnboardingData(
      icon: Icons.trending_up,
      title: 'Track Your\nProgress',
      subtitle: 'Monitor your fitness journey with detailed analytics and insights',
      color: AppColors.secondary,
    ),
    OnboardingData(
      icon: Icons.restaurant,
      title: 'Smart\nNutrition',
      subtitle: 'Receive intelligent meal planning and nutrition recommendations',
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    _initializeAnimations();
    _startAnimations();
    _startAutoPageTimer();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);
    
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_waveController);
  }

  void _startAnimations() {
    _mainController.forward();
    _particleController.repeat();
    _waveController.repeat();
  }

  void _startAutoPageTimer() {
    _autoPageTimer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (_currentPage < _onboardingData.length - 1) {
        setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.2,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _waveController.dispose();
    _pageController.dispose();
    _autoPageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              Color(0xFF0F1415),
              Color(0xFF1A2B2D),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(size),
            
            // Floating particles
            _buildFloatingParticles(size),
            
            // Wave animation
            _buildWaveAnimation(size),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo section
                  _buildLogoSection(),
                  
                  const SizedBox(height: 40),
                  
                  // App name
                  _buildAppName(),
                  
                  const Spacer(),
                  
                  // Onboarding content
                  _buildOnboardingContent(),
                  
                  const SizedBox(height: 60),
                  
                  // Page indicators
                  _buildPageIndicators(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(Size size) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: size,
          painter: BackgroundParticlePainter(_particleAnimation.value),
        );
      },
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final progress = (_particleAnimation.value + index * 0.1) % 1.0;
            final x = size.width * (0.1 + (index % 4) * 0.25);
            final y = size.height * (1.0 - progress);
            
            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: (1.0 - progress) * 0.6,
                child: Container(
                  width: 4 + (index % 3) * 2,
                  height: 4 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    color: index.isEven ? AppColors.accent : AppColors.secondary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (index.isEven ? AppColors.accent : AppColors.secondary)
                            .withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildWaveAnimation(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(size.width, 100),
            painter: WavePainter(_waveAnimation.value),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent,
                  AppColors.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 50,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _textAnimation.value)),
            child: const Text(
              'ApelaTech Fitness',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnboardingContent() {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final data = _onboardingData[index];
          return FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.color.withOpacity(0.2),
                    border: Border.all(
                      color: data.color.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    data.icon,
                    size: 60,
                    color: data.color,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardingData.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index 
              ? AppColors.accent
              : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class BackgroundParticlePainter extends CustomPainter {
  final double animationValue;

  BackgroundParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final progress = (animationValue + i * 0.05) % 1.0;
      final x = size.width * (0.1 + (i % 4) * 0.25);
      final y = size.height * progress;
      final radius = 2 + math.sin(progress * math.pi) * 3;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = (i.isEven ? AppColors.accent : AppColors.secondary)
            .withOpacity(0.1 * (1 - progress)),
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final normalizedX = x / size.width;
      final waveHeight = math.sin((normalizedX * 2 * math.pi) + (animationValue * 2 * math.pi)) * 20;
      path.lineTo(x, size.height - 40 + waveHeight);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
