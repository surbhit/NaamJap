import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class ScreenshotsSection extends StatelessWidget {
  const ScreenshotsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientEnd,
            AppColors.darkGradientStart,
          ],
        ),
      ),
      child: Column(
        children: [
          // Section title
          Text(
            '📱 See Naam Jhap in Action',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 1.seconds).slideY(),
          
          const SizedBox(height: 20),
          
          Text(
            'Experience the beautiful interface designed for your spiritual journey',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: AppColors.whiteText.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 0.5.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 60),
          
          // Screenshots grid
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenWidth > 1000 ? 3 : screenWidth > 600 ? 2 : 1,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 0.6,
              children: [
                _buildScreenshotCard(
                  title: 'Main Counter',
                  description: 'Track your chants with beautiful mala visualization',
                  features: ['One-tap counting', 'Mala progress', 'Real-time updates'],
                  delay: 0.seconds,
                ),
                _buildScreenshotCard(
                  title: 'Progress Tracker',
                  description: 'Visualize your journey to 8 crore with detailed progress',
                  features: ['Circular progress', 'ETA calculation', 'Milestone tracking'],
                  delay: 0.2.seconds,
                ),
                _buildScreenshotCard(
                  title: 'Mantra Management',
                  description: 'Organize and track multiple mantras',
                  features: ['Multiple mantras', 'Individual tracking', 'Easy management'],
                  delay: 0.4.seconds,
                ),
                _buildScreenshotCard(
                  title: 'Analytics Dashboard',
                  description: 'Comprehensive insights into your practice',
                  features: ['Daily statistics', 'Trend analysis', 'Progress history'],
                  delay: 0.6.seconds,
                ),
                _buildScreenshotCard(
                  title: 'Journey Overview',
                  description: 'Complete view of your spiritual journey',
                  features: ['Overall progress', 'Daily breakdown', 'Achievement tracking'],
                  delay: 0.8.seconds,
                ),
                _buildScreenshotCard(
                  title: 'Spiritual Design',
                  description: 'Beautiful interface inspired by sacred traditions',
                  features: ['Sacred colors', 'Intuitive design', 'Peaceful experience'],
                  delay: 1.seconds,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          
          // App preview mockup
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Phone frame
                Container(
                  width: 280,
                  height: 560,
                  decoration: BoxDecoration(
                    color: AppColors.primaryText,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
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
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.self_improvement,
                              size: 80,
                              color: AppColors.primaryOrange,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Naam Jhap',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Your Sacred Journey',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Floating elements
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.omSymbol,
                      shape: BoxShape.circle,
                    ),
                  ),
                ).animate().fadeIn(delay: 1.5.seconds, duration: 1.seconds).scale(),
                
                Positioned(
                  bottom: 80,
                  left: 30,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: AppColors.diyaFlame,
                      shape: BoxShape.circle,
                    ),
                  ),
                ).animate().fadeIn(delay: 1.7.seconds, duration: 1.seconds).scale(),
              ],
            ),
          ).animate().fadeIn(delay: 1.2.seconds, duration: 1.seconds).scale(),
        ],
      ),
    );
  }

  Widget _buildScreenshotCard({
    required String title,
    required String description,
    required List<String> features,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.whiteText.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.whiteText.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock phone screen
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: AppColors.whiteText,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Content
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteText,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.whiteText.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Features list
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.accentGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.whiteText.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay, duration: 1.seconds).slideY();
  }
}

