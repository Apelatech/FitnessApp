import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _logoController;
  late AnimationController _progressController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _showProgress = false;
  String _loadingText = 'Initializing...';
  bool _canSkip = false;
  bool _hasNavigated = false;
  
  final List<String> _loadingMessages = [
    'Initializing AI Coach...',
    'Loading Workout Library...',
    'Preparing Analytics...',
    'Setting up Nutrition Database...',
    'Optimizing User Experience...',
    'Ready to Transform Your Fitness!',
  ];
  
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Pulse animation for glow effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for background elements
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Logo entrance animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Start background animations
    _rotationController.repeat();
    
    // Start logo entrance
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    // Start pulse after logo appears
    await Future.delayed(const Duration(milliseconds: 800));
    _pulseController.repeat(reverse: true);
    
    // Show progress after logo animation
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _showProgress = true;
      _canSkip = true; // Allow skipping after progress shows
    });
    
    // Start progress animation and text cycling
    _progressController.forward();
    _startTextCycling();
    
    // Navigate to home (reduced from 4500ms to 3000ms)
    await Future.delayed(const Duration(milliseconds: 3000));
    _navigateToHome();
  }

  void _startTextCycling() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_currentMessageIndex < _loadingMessages.length - 1) {
        setState(() {
          _currentMessageIndex++;
          _loadingText = _loadingMessages[_currentMessageIndex];
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _navigateToHome() {
    if (mounted && !_hasNavigated) {
      _hasNavigated = true;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Create a fade and scale transition
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.8,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_canSkip && !_hasNavigated) {
            _navigateToHome();
          }
        },
        child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              Color(0xFF0F1415),
              Color(0xFF1A2B2D),
              AppColors.primary,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(size),
            
            // Floating particles
            _buildFloatingParticles(size),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section with animations
                  _buildAnimatedLogo(),
                  
                  const SizedBox(height: 50),
                  
                  // App name with gradient text
                  _buildAnimatedAppName(),
                  
                  const SizedBox(height: 20),
                  
                  // Tagline with border animation
                  _buildAnimatedTagline(),
                  
                  const SizedBox(height: 80),
                  
                  // Progress section
                  if (_showProgress) _buildProgressSection(),
                ],
              ),
            ),
            
            // Bottom section
            _buildBottomSection(),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(Size size) {
    return Stack(
      children: [
        // Large rotating gradient circle
        Positioned(
          top: -150,
          right: -150,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.accent.withOpacity(0.08),
                    AppColors.secondary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Bottom left circle
        Positioned(
          bottom: -120,
          left: -120,
          child: RotationTransition(
            turns: Tween<double>(begin: 1.0, end: 0.0).animate(_rotationAnimation),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.12),
                    AppColors.secondary.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Center accent circle
        Positioned(
          top: size.height * 0.7,
          right: -80,
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return Stack(
      children: List.generate(8, (index) {
        final delay = index * 200;
        final topPosition = (size.height * 0.1) + (index * size.height * 0.1);
        final leftPosition = (index.isEven ? 30.0 : size.width - 50);
        
        return Positioned(
          top: topPosition,
          left: leftPosition,
          child: FadeInUp(
            duration: const Duration(milliseconds: 2000),
            delay: Duration(milliseconds: delay),
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: index.isEven ? 4 : 6,
                height: index.isEven ? 4 : 6,
                decoration: BoxDecoration(
                  color: index.isEven 
                    ? AppColors.accent.withOpacity(0.7)
                    : AppColors.secondary.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (index.isEven ? AppColors.accent : AppColors.secondary)
                          .withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoOpacityAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent,
                      Color(0xFFFF6B47),
                      AppColors.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.2),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/faviicon.svg',
                  width: 70,
                  height: 70,
                  // Keep the original SVG colors (orange to blue gradient)
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAppName() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      delay: const Duration(milliseconds: 800),
      child: SlideInUp(
        duration: const Duration(milliseconds: 1000),
        delay: const Duration(milliseconds: 1000),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Colors.white,
              AppColors.accent,
              AppColors.secondary,
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: const Text(
            'ApelaTech',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.4),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.08),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          'AI-Powered Fitness Revolution',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          // Progress bar
          SizedBox(
            width: 250,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accent.withOpacity(0.9),
                  ),
                  minHeight: 4,
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Loading text with animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _loadingText,
              key: ValueKey(_loadingText),
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: FadeInUp(
        duration: const Duration(milliseconds: 1000),
        delay: const Duration(milliseconds: 2000),
        child: Column(
          children: [
            Text(
              'Powered by Advanced AI Technology',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 16),
            // Animated dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    final progress = _progressAnimation.value;
                    final dotProgress = ((progress * 3) - index).clamp(0.0, 1.0);
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          Colors.white24,
                          AppColors.accent,
                          dotProgress,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: dotProgress > 0.5
                            ? [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    );
                  },
                );
              }),
            ),
            
            // Tap to continue indicator
            if (_canSkip)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: Colors.white.withOpacity(0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tap anywhere to continue',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
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
}
