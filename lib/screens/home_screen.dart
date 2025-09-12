import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/hero_section.dart';
import '../widgets/features_section.dart';
import '../widgets/screenshots_section.dart';
import '../widgets/events_count_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                const HeroSection(),
                const FeaturesSection(),
                const EventsCountSection(),
                const ScreenshotsSection(),
                const ContactSection(),
                const FooterSection(),
              ],
            ),
          ),
      ),
    );
  }
}
