import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

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
            AppColors.darkGradientStart,
            AppColors.darkGradientEnd,
          ],
        ),
      ),
      child: Column(
        children: [
          // Main CTA section
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: AppColors.whiteText.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.whiteText.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Om symbol
                Text(
                  '🕉️',
                  style: const TextStyle(fontSize: 60),
                ).animate().fadeIn(duration: 1.seconds).scale(),
                
                const SizedBox(height: 30),
                
                Text(
                  'Start Your Sacred Journey Today',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 0.5.seconds, duration: 1.seconds).slideY(),
                
                const SizedBox(height: 20),
                
                Text(
                  'Every chant brings you closer to your divine goal. With Naam Jhap, you can track your progress, stay motivated, and witness your spiritual growth with beautiful analytics and insights.',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 16 : 14,
                    color: AppColors.whiteText.withOpacity(0.8),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 1.seconds, duration: 1.seconds).slideY(),
                
                const SizedBox(height: 40),
                
                // Download button
                Center(
                  child: _buildDownloadButton(
                    icon: Icons.android,
                    text: 'Download for Android',
                    onTap: () async {
                      final Uri playStoreUri = Uri.parse('https://play.google.com/store/apps/details?id=com.maindra.naamjhap');
                      if (await canLaunchUrl(playStoreUri)) {
                        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ).animate().fadeIn(delay: 1.5.seconds, duration: 1.seconds).slideY(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Features summary
          Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenWidth > 800 ? 4 : screenWidth > 600 ? 2 : 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
              children: [
                _buildFeatureSummary(
                  icon: Icons.security,
                  title: 'Complete Privacy',
                  description: 'All data stored locally',
                ),
                _buildFeatureSummary(
                  icon: Icons.offline_bolt,
                  title: 'Offline Ready',
                  description: 'No internet required',
                ),
                _buildFeatureSummary(
                  icon: Icons.analytics,
                  title: 'Smart Analytics',
                  description: 'Track your progress',
                ),
                _buildFeatureSummary(
                  icon: Icons.palette,
                  title: 'Beautiful Design',
                  description: 'Sacred color theme',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Perfect for section
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.whiteText.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '🌟 Perfect for Spiritual Seekers',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 1.seconds).slideY(),
                
                const SizedBox(height: 30),
                
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    '8 crore naam jhap practitioners',
                    'Japa and mantra meditation enthusiasts',
                    'Spiritual seekers on devotional paths',
                    'Yoga practitioners and meditation teachers',
                    'Anyone tracking repetitive spiritual practices',
                    'Devotees following traditional spiritual disciplines',
                  ].map((text) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.whiteText,
                      ),
                    ),
                  )).toList(),
                ).animate().fadeIn(delay: 0.5.seconds, duration: 1.seconds).slideY(),
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Final blessing
          Text(
            '✨ Om Namah Shivaya ✨',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.omSymbol,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 1.seconds, duration: 2.seconds).scale(),
          
          const SizedBox(height: 20),
          
          Text(
            'May your spiritual journey be blessed with peace, progress, and divine grace.',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 16 : 14,
              color: AppColors.whiteText.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 1.5.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 40),
          
          // Copyright
          Text(
            '© 2024 Naam Jhap. Made with ❤️ for spiritual seekers.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.whiteText.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 2.seconds, duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildDownloadButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryOrange, AppColors.deepOrange],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.whiteText,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.whiteText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSummary({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteText.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.whiteText.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.primaryOrange,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.whiteText.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
