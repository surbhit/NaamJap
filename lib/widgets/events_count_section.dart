import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../services/events_service.dart';

class EventsCountSection extends StatefulWidget {
  const EventsCountSection({super.key});

  @override
  State<EventsCountSection> createState() => _EventsCountSectionState();
}

class _EventsCountSectionState extends State<EventsCountSection> {
  int _eventsCount = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEventsCount();
  }

  Future<void> _loadEventsCount() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final count = await EventsService.getEventsCount();
      
      if (mounted) {
        setState(() {
          _eventsCount = count;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load events count';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          // Section title
          Text(
            '🎉 Community Events',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 32 : 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 1.seconds).slideY(),
          
          const SizedBox(height: 20),
          
          Text(
            'Join our growing community of spiritual practitioners',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 0.3.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 40),
          
          // Events count card
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.whiteText.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event,
                    size: 40,
                    color: AppColors.whiteText,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Count display
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteText),
                  )
                else if (_error != null)
                  Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 40,
                        color: AppColors.whiteText.withOpacity(0.8),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: AppColors.whiteText,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _loadEventsCount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteText,
                          foregroundColor: AppColors.primaryOrange,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Text(
                        '$_eventsCount',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _eventsCount == 1 ? 'Event' : 'Events',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.whiteText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 20),
                
                // Description
                Text(
                  'Total spiritual events and gatherings in our community',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 16 : 14,
                    color: AppColors.whiteText.withOpacity(0.9),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 0.6.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 30),
          
          // Refresh button
          if (!_isLoading && _error == null)
            ElevatedButton.icon(
              onPressed: _loadEventsCount,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Count'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.whiteText,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ).animate().fadeIn(delay: 0.9.seconds, duration: 1.seconds).slideY(),
        ],
      ),
    );
  }
}
