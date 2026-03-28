import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/naamjap_screen.dart';
import 'screens/chanting_stats_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'widgets/custom_scroll_behavior.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const NaamJhapWebsite());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/naamjap',
      builder: (context, state) => const NaamJapScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/chanting-stats',
      builder: (context, state) => const ChantingStatsScreen(),
    ),
  ],
);

class NaamJhapWebsite extends StatelessWidget {
  const NaamJhapWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Naam Jhap - Your Sacred Journey to 8 Crore',
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
