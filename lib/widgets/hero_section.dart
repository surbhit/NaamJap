import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      height: screenHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background spiritual elements
          Positioned(
            top: 50,
            right: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.omSymbol.withOpacity(0.1),
              ),
            ),
          ).animate().fadeIn(duration: 2.seconds).scale(),
          
          // Om symbol in background
          Positioned(
            top: screenHeight * 0.3,
            left: screenWidth * 0.1,
            child: Text(
              'ॐ',
              style: TextStyle(
                fontSize: 120,
                color: AppColors.omSymbol.withOpacity(0.3),
                fontWeight: FontWeight.w300,
              ),
            ),
          ).animate().fadeIn(duration: 3.seconds).scale(),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon/logo placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryOrange, AppColors.deepOrange],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.self_improvement,
                    size: 60,
                    color: AppColors.whiteText,
                  ),
                ).animate().fadeIn(duration: 1.seconds).scale(),
                
                const SizedBox(height: 40),
                
                // Main title
                Text(
                  '🕉️ Naam Jhap',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 48 : 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    letterSpacing: 2,
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 1.seconds).slideY(),
                
                const SizedBox(height: 20),
                
                // Subtitle
                Text(
                  'Your Sacred Journey to 8 Crore',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 24 : 18,
                    fontWeight: FontWeight.w300,
                    color: AppColors.secondaryText,
                    letterSpacing: 1,
                  ),
                ).animate().fadeIn(delay: 1.seconds, duration: 1.seconds).slideY(),
                
                const SizedBox(height: 40),
                
                // Description
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Embark on the most profound spiritual journey of your life with Naam Jhap, the ultimate companion for tracking your progress towards the sacred goal of 8 crore naam jhap.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 18 : 16,
                      color: AppColors.lightText,
                      height: 1.6,
                    ),
                  ),
                ).animate().fadeIn(delay: 1.5.seconds, duration: 1.seconds).slideY(),
                
                const SizedBox(height: 50),
                
                // CTA Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Scroll to features section
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: AppColors.whiteText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Start Your Journey',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).animate().fadeIn(delay: 2.seconds, duration: 1.seconds).slideY(),
                ),
              ],
            ),
          ),
          
          // Floating spiritual elements
          Positioned(
            bottom: 100,
            left: 50,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.diyaFlame.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wb_sunny,
                color: AppColors.diyaFlame,
                size: 30,
              ),
            ),
          ).animate().fadeIn(delay: 2.5.seconds, duration: 1.seconds).scale(),
          
          Positioned(
            bottom: 150,
            right: 80,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: AppColors.accentGold,
                size: 20,
              ),
            ),
          ).animate().fadeIn(delay: 2.7.seconds, duration: 1.seconds).scale(),
        ],
      ),
    );
  }
}
