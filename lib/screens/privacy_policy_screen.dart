import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse('mailto:surbhit.thanvi@gmail.com');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.whiteText,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Back to Home',
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isWide ? 1000 : 720),
              padding: EdgeInsets.all(isWide ? 40 : 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: isWide ? 36 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Effective Date: 12th August 2025',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Naam Jhapa (“we,” “our,” or “us”) respects your privacy and is committed to protecting the personal information you share with us. This Privacy Policy explains how we handle your information when you use our mobile application Naam Jhapa (the “App”).',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _PolicySection(
                    title: '1. Information We Collect',
                    paragraphs: [
                      'We do not collect any personally identifiable information (PII) from our users. The App operates entirely on your device and does not require you to create an account or share personal details.',
                      'However, we may collect:',
                    ],
                    bullets: [
                      'Non-personal information such as device type, operating system, and anonymous usage statistics, solely for improving app performance.',
                      'App preferences and progress, stored locally on your device.',
                    ],
                  ),
                  const _PolicySection(
                    title: '2. How We Use Information',
                    paragraphs: ['Any data collected is used for:'],
                    bullets: [
                      'Improving the App’s functionality and performance.',
                      'Providing a better user experience.',
                      'Fixing bugs and enhancing features.',
                      'We do not sell, rent, or share your personal data with third parties.',
                    ],
                  ),
                  const _PolicySection(
                    title: '3. Third-Party Services',
                    paragraphs: [
                      'The App may use third-party services (e.g., analytics, crash reporting, ads) which may collect information as per their own privacy policies:',
                    ],
                    bullets: [
                      'Google Analytics for Firebase',
                      'AdMob (if ads are enabled)',
                      'We encourage you to review the privacy policies of these services.',
                    ],
                  ),
                  const _PolicySection(
                    title: '4. Data Storage & Security',
                    paragraphs: [
                      'All chanting counts, preferences, and settings are stored locally on your device unless otherwise stated.',
                      'We implement reasonable measures to protect data, but no method of transmission or storage is 100% secure.',
                    ],
                  ),
                  const _PolicySection(
                    title: '5. Children’s Privacy',
                    paragraphs: [
                      'Our App is suitable for general audiences. We do not knowingly collect any data from children under 13.',
                    ],
                  ),
                  const _PolicySection(
                    title: '6. Changes to This Policy',
                    paragraphs: [
                      'We may update this Privacy Policy from time to time. Updates will be reflected in this section with a revised effective date.',
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '7. Contact Us',
                    style: TextStyle(
                      fontSize: isWide ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'If you have any questions or concerns about this Privacy Policy or the App, please contact us:',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      InkWell(
                        onTap: _launchEmail,
                        child: const Text(
                          'surbhit.thanvi@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkOrange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  const _PolicySection({
    required this.title,
    required this.paragraphs,
    this.bullets = const [],
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleSize = screenWidth > 900 ? 24.0 : 20.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          ...paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                paragraph,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ),
          ...bullets.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
