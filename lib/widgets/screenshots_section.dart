import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class ScreenshotsSection extends StatelessWidget {
  const ScreenshotsSection({super.key});

  // Screenshot data with descriptions
  final List<Map<String, dynamic>> screenshots = const [
    {
      'title': 'Choose Your Mantra',
      'image': 'assets/images/screenshots/choose_mantra.png',
      'description': [
        'Select from a variety of sacred mantras',
        'Includes Gan Ganapataye Namah, Ram Naam, Om Namah Shivaya',
        'Each mantra comes with its meaning and significance',
        'Easy selection interface',
      ],
    },
    {
      'title': 'My Mantras',
      'image': 'assets/images/screenshots/my_mantras.png',
      'description': [
        'Manage all your mantras in one place',
        'Track individual progress with chants and malas',
        'View progress per mantra',
        'Keep your spiritual practice organized',
      ],
    },
    {
      'title': 'Your Journey',
      'image': 'assets/images/screenshots/your_journey.png',
      'description': [
        'Track your complete spiritual journey',
        'View your meditation history',
        'Monitor your progress over time',
        'Celebrate milestones and achievements',
      ],
    },
    {
      'title': 'Mala Completion',
      'image': 'assets/images/screenshots/mala_completion.png',
      'description': [
        'Complete full malas of 108 beads',
        'Track your mala completion count',
        'Celebrate each completed mala',
        'Maintain your daily practice',
      ],
    },
    {
      'title': 'Spiritual Interface',
      'image': 'assets/images/screenshots/spiritual_interface.png',
      'description': [
        'Beautiful and intuitive design',
        'Peaceful and calming interface',
        'Easy to navigate features',
        'Designed for focused meditation',
      ],
    },
    {
      'title': 'Progress Counter',
      'image': 'assets/images/screenshots/progress_counter.png',
      'description': [
        'Real-time progress tracking',
        'Visual progress indicators',
        'Set and achieve your goals',
        'Monitor your daily chanting',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
    // Calculate image size based on screen width
    // For one row, we need to fit all images
    final imageHeight = isMobile ? 300.0 : isTablet ? 400.0 : 500.0;
    final imageWidth = imageHeight * (368 / 800); // Maintain aspect ratio
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 16 : 24,
      ),
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
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 1.seconds).slideY(),
          
          const SizedBox(height: 20),
          
          Text(
            'Experience the beautiful interface designed for your spiritual journey',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: AppColors.whiteText.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 0.5.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 50),
          
          // Images in one row with descriptions below
          isMobile
              ? _buildMobileLayout(imageWidth, imageHeight)
              : _buildDesktopLayout(imageWidth, imageHeight),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(double imageWidth, double imageHeight) {
    return Column(
      children: screenshots.map((screenshot) {
        final index = screenshots.indexOf(screenshot);
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: _buildScreenshotCard(
            screenshot: screenshot,
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            delay: (index * 0.1).seconds,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDesktopLayout(double imageWidth, double imageHeight) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 40,
      children: screenshots.asMap().entries.map((entry) {
        final index = entry.key;
        final screenshot = entry.value;
        return _buildScreenshotCard(
          screenshot: screenshot,
          imageWidth: imageWidth,
          imageHeight: imageHeight,
          delay: (index * 0.1).seconds,
        );
      }).toList(),
    );
  }

  Widget _buildScreenshotCard({
    required Map<String, dynamic> screenshot,
    required double imageWidth,
    required double imageHeight,
    required Duration delay,
  }) {
    final title = screenshot['title'] as String;
    final imagePath = screenshot['image'] as String;
    final description = screenshot['description'] as List<String>;

    return Container(
      width: imageWidth + 40, // Add padding for card
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image container
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 3,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: AppColors.whiteText.withOpacity(0.5),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.whiteText.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteText,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description as bullet points
          ...description.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.whiteText.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ).animate()
      .fadeIn(delay: delay, duration: 0.6.seconds)
      .slideY(delay: delay, begin: 0.2, duration: 0.6.seconds);
  }
}
