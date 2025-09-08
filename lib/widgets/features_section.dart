import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          // Section title
          Text(
            '✨ Sacred Features for Your Spiritual Practice',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 1.seconds).slideY(),
          
          const SizedBox(height: 60),
          
          // Features grid
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenWidth > 1000 ? 3 : screenWidth > 600 ? 2 : 1,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 1.2,
              children: [
                _buildFeatureCard(
                  icon: Icons.track_changes,
                  title: '🎯 8 Crore Goal Visualization',
                  description: 'Beautiful circular progress indicator showing your journey with real-time progress percentage towards 8 crore.',
                  delay: 0.seconds,
                ),
                _buildFeatureCard(
                  icon: Icons.psychology,
                  title: '📿 Mantra Management System',
                  description: 'Create unlimited personal mantras and track individual progress for each mantra with detailed analytics.',
                  delay: 0.2.seconds,
                ),
                _buildFeatureCard(
                  icon: Icons.touch_app,
                  title: '🔢 Intelligent Counting System',
                  description: 'One-tap chant increment with haptic feedback and automatic mala calculation (108 chants = 1 mala).',
                  delay: 0.4.seconds,
                ),
                _buildFeatureCard(
                  icon: Icons.analytics,
                  title: '📊 Comprehensive Analytics',
                  description: 'Daily chanting statistics, per-mantra progress breakdown, and historical data visualization.',
                  delay: 0.6.seconds,
                ),
                _buildFeatureCard(
                  icon: Icons.schedule,
                  title: '⏰ Smart ETA Calculator',
                  description: 'Predict when you\'ll reach 8 crore based on current pace with progress acceleration suggestions.',
                  delay: 0.8.seconds,
                ),
                _buildFeatureCard(
                  icon: Icons.palette,
                  title: '🎨 Beautiful Spiritual Design',
                  description: 'Stunning orange gradient theme inspired by sacred colors with intuitive, distraction-free interface.',
                  delay: 1.seconds,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 80),
          
          // Why Choose Naam Jhap section
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '🎯 Why Choose Naam Jhap?',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 1.seconds).slideY(),
                
                const SizedBox(height: 30),
                
                Text(
                  'Unlike generic counting apps, Naam Jhap is specifically designed for spiritual practitioners. Every feature is crafted with the understanding of traditional spiritual practices, making it the perfect companion for your journey to 8 crore naam jhap.',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 16 : 14,
                    color: AppColors.secondaryText,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 0.5.seconds, duration: 1.seconds).slideY(),
                
                const SizedBox(height: 30),
                
                Text(
                  'The app respects the sacred nature of your practice while providing modern tools to track and enhance your spiritual progress. Whether you\'re just beginning your journey or are well on your way to 8 crore, Naam Jhap will be your faithful companion.',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 16 : 14,
                    color: AppColors.secondaryText,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 1.seconds, duration: 1.seconds).slideY(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.whiteText,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.deepOrange],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: AppColors.whiteText,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 15),
          
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.lightText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay, duration: 1.seconds).slideY();
  }
}
