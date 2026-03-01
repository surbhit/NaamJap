import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class NaamJapScreen extends StatelessWidget {
  const NaamJapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              _buildHeroSection(context, isMobile),
              
              // App Overview Section
              _buildOverviewSection(isMobile),
              
              // Features Section
              _buildFeaturesSection(isMobile),
              
              // Screenshots Section
              _buildScreenshotsSection(isMobile),
              
              // How It Works Section
              _buildHowItWorksSection(isMobile),
              
              // Instagram CTA Section
              _buildInstagramSection(context, isMobile),
              
              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Column(
        children: [
          // Back button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
              onPressed: () => context.go('/'),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.whiteText.withOpacity(0.2),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ).animate().fadeIn(duration: 0.5.seconds),
          
          const SizedBox(height: 40),
          
          // App Icon/Logo
          Container(
            width: isMobile ? 120 : 150,
            height: isMobile ? 120 : 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.deepOrange],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.self_improvement,
              size: 70,
              color: AppColors.whiteText,
            ),
          ).animate().fadeIn(duration: 1.seconds).scale(),
          
          const SizedBox(height: 30),
          
          // Title
          Text(
            '🕉️ Naam Jap',
            style: TextStyle(
              fontSize: isMobile ? 42 : 56,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: 2,
            ),
          ).animate().fadeIn(delay: 0.3.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 20),
          
          // Subtitle
          Text(
            'Your Sacred Mantra Chanting Companion',
            style: TextStyle(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.w300,
              color: AppColors.secondaryText,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 0.6.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 30),
          
          // Description
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Embark on a transformative spiritual journey with Naam Jap, the ultimate mobile app for tracking your mantra chanting practice. Experience peace, devotion, and progress as you work towards your sacred goal of 8 crore naam jhap.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 16 : 20,
                color: AppColors.lightText,
                height: 1.8,
              ),
            ),
          ).animate().fadeIn(delay: 0.9.seconds, duration: 1.seconds).slideY(),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'About Naam Jap App',
              style: TextStyle(
                fontSize: isMobile ? 32 : 42,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 1.seconds),
            
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.whiteText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.cardBorder,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Naam Jap is a beautifully designed spiritual app that helps you maintain consistency in your mantra chanting practice. Track your daily chants, visualize your progress with traditional mala beads, and stay motivated on your journey to spiritual fulfillment.',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: AppColors.primaryText,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Key Highlights
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildHighlightCard(
                        icon: Icons.self_improvement,
                        title: 'Spiritual Practice',
                        description: 'Track your daily mantra chanting',
                      ),
                      _buildHighlightCard(
                        icon: Icons.track_changes,
                        title: 'Progress Tracking',
                        description: 'Visualize progress with mala beads',
                      ),
                      _buildHighlightCard(
                        icon: Icons.insights,
                        title: 'Journey Analytics',
                        description: 'Comprehensive progress insights',
                      ),
                      _buildHighlightCard(
                        icon: Icons.auto_awesome,
                        title: 'Multiple Mantras',
                        description: 'Manage and track various mantras',
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 0.3.seconds, duration: 1.seconds).slideY(),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteText.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.primaryOrange),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    final features = [
      {
        'icon': Icons.radio_button_checked,
        'title': 'Mala Counter',
        'description': 'Track your chants with a beautiful circular mala visualization. Each complete round represents 108 chants, helping you maintain focus and consistency.',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Progress Tracking',
        'description': 'Visualize your journey to 8 crore with detailed progress bars, ETA calculations, and milestone celebrations. See your daily, weekly, and overall progress.',
      },
      {
        'icon': Icons.list_alt,
        'title': 'Multiple Mantras',
        'description': 'Choose from a variety of sacred mantras including Ram Naam, Om Namah Shivaya, Gan Ganapataye Namah, and more. Track each mantra separately.',
      },
      {
        'icon': Icons.analytics,
        'title': 'Journey Analytics',
        'description': 'Get comprehensive insights into your practice with daily breakdowns, total chants, per-day averages, and completion estimates.',
      },
      {
        'icon': Icons.palette,
        'title': 'Beautiful Design',
        'description': 'Experience a serene, spiritual interface with warm orange gradients, sacred symbols, and peaceful aesthetics inspired by traditional practices.',
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Daily Reminders',
        'description': 'Stay consistent with your practice through gentle reminders and motivational messages to keep you on track.',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
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
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Key Features',
              style: TextStyle(
                fontSize: isMobile ? 32 : 42,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteText,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 1.seconds),
            
            const SizedBox(height: 20),
            
            Text(
              'Everything you need for your spiritual journey',
              style: TextStyle(
                fontSize: isMobile ? 16 : 20,
                color: AppColors.whiteText.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 0.3.seconds, duration: 1.seconds),
            
            const SizedBox(height: 50),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: isMobile ? 1.2 : 1.3,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return _buildFeatureCard(
                  icon: feature['icon'] as IconData,
                  title: feature['title'] as String,
                  description: feature['description'] as String,
                  delay: (index * 0.1).seconds,
                );
              },
            ),
          ],
        ),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: AppColors.primaryOrange),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.whiteText.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay, duration: 1.seconds).slideY();
  }

  Widget _buildScreenshotsSection(bool isMobile) {
    final screenshots = [
      {
        'title': 'Choose Your Mantra',
        'description': 'Select from a variety of sacred mantras including Gan Ganapataye Namah, Ram Naam, Om Namah Shivaya, Durga Mantra, and more. Each mantra comes with its meaning and significance.',
        'features': ['Multiple mantras', 'Sacred meanings', 'Easy selection'],
        'image': 'assets/images/screenshots/choose_mantra.png',
      },
      {
        'title': 'My Mantras',
        'description': 'Manage all your mantras in one place. Track individual progress with chants and malas completed for each mantra. Keep your spiritual practice organized.',
        'features': ['Individual tracking', 'Progress per mantra', 'Easy management'],
        'image': 'assets/images/screenshots/my_mantras.png',
      },
      {
        'title': 'Your Journey',
        'description': 'Comprehensive analytics showing your overall progress, daily breakdown, total chants, per-day average, and ETA to reach your goal of 8 crore.',
        'features': ['Overall progress', 'Daily breakdown', 'ETA calculation'],
        'image': 'assets/images/screenshots/your_journey.png',
      },
      {
        'title': 'Mala Completion',
        'description': 'Beautiful visualization of completed malas with the traditional 108-bead count. Celebrate each milestone as you progress on your spiritual journey.',
        'features': ['108-bead malas', 'Visual progress', 'Milestone tracking'],
        'image': 'assets/images/screenshots/mala_completion.png',
      },
      {
        'title': 'Spiritual Interface',
        'description': 'Experience a serene, peaceful interface with warm colors, sacred symbols like Om and Lord Shiva, and traditional diya lamps creating a devotional atmosphere.',
        'features': ['Sacred design', 'Peaceful colors', 'Traditional elements'],
        'image': 'assets/images/screenshots/spiritual_interface.png',
      },
      {
        'title': 'Progress Counter',
        'description': 'Track your chants with a beautiful circular progress indicator showing your current count out of 11,000 (11k) with percentage completion.',
        'features': ['Circular progress', 'Real-time tracking', 'Goal visualization'],
        'image': 'assets/images/screenshots/progress_counter.png',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'App Screenshots & Features',
              style: TextStyle(
                fontSize: isMobile ? 32 : 42,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 1.seconds),
            
            const SizedBox(height: 20),
            
            Text(
              'Explore the beautiful interface and powerful features',
              style: TextStyle(
                fontSize: isMobile ? 16 : 20,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 0.3.seconds, duration: 1.seconds),
            
            const SizedBox(height: 50),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: isMobile ? 1.1 : 1.2,
              ),
              itemCount: screenshots.length,
              itemBuilder: (context, index) {
                final screenshot = screenshots[index];
                return _buildScreenshotCard(
                  title: screenshot['title'] as String,
                  description: screenshot['description'] as String,
                  features: screenshot['features'] as List<String>,
                  imagePath: screenshot['image'] as String?,
                  delay: (index * 0.1).seconds,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenshotCard({
    required String title,
    required String description,
    required List<String> features,
    String? imagePath,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screenshot image or placeholder
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imagePath != null
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to placeholder if image not found
                          return _buildPlaceholder(title);
                        },
                      )
                    : _buildPlaceholder(title),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Content
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 15),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.accentGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.lightText,
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

  Widget _buildPlaceholder(String title) {
    return Container(
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_android,
                size: 40,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection(bool isMobile) {
    final steps = [
      {
        'number': '1',
        'title': 'Download & Install',
        'description': 'Get Naam Jap from the App Store or Google Play Store and install it on your device.',
      },
      {
        'number': '2',
        'title': 'Choose Your Mantra',
        'description': 'Select from a variety of sacred mantras or add your own custom mantra to track.',
      },
      {
        'number': '3',
        'title': 'Start Chanting',
        'description': 'Begin your practice by tapping to count each chant. Watch your progress grow with beautiful visualizations.',
      },
      {
        'number': '4',
        'title': 'Track Progress',
        'description': 'Monitor your journey with detailed analytics, daily breakdowns, and progress towards your goal.',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkGradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'How It Works',
              style: TextStyle(
                fontSize: isMobile ? 32 : 42,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteText,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 1.seconds),
            
            const SizedBox(height: 50),
            
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    if (!isMobile) ...[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            step['number'] as String,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: AppColors.whiteText.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColors.whiteText.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isMobile) ...[
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    step['number'] as String,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteText,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    step['description'] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.whiteText.withOpacity(0.8),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 0.2).seconds, duration: 1.seconds).slideX();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInstagramSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryOrange, AppColors.deepOrange],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(
              Icons.camera_alt,
              size: 60,
              color: AppColors.whiteText,
            ),
            const SizedBox(height: 20),
            Text(
              'Follow Us on Instagram',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'Stay connected with our community and see the latest updates, features, and spiritual insights from Naam Jap.',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: AppColors.whiteText.withOpacity(0.9),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(
                  'https://www.instagram.com/naamjhap?igsh=ejcwYWllNWtmZGJi&utm_source=qr',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new, size: 20),
              label: const Text(
                'Visit Instagram',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.whiteText,
                foregroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 1.seconds).scale(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryText.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Text(
            '🕉️',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 15),
          Text(
            'May your spiritual journey be blessed',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.secondaryText,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text(
              '← Back to Home',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

