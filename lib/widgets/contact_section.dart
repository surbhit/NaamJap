import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String message = _messageController.text.trim();

      final String subject = 'Contact from Naam Jhap Website - $name';
      final String body = '''
Name: $name
Email: $email

Message:
$message

---
This message was sent from the Naam Jhap website contact form.
''';

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'surbhit.thanvi@gmail.com',
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Thank you! Your message has been sent. We will get back to you soon.',
                style: TextStyle(color: AppColors.whiteText),
              ),
              backgroundColor: AppColors.accentGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        throw Exception('Could not launch email client');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Sorry, there was an error sending your message. Please try again.',
              style: TextStyle(color: AppColors.whiteText),
            ),
            backgroundColor: AppColors.accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

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
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),
      child: Column(
        children: [
          // Section title
          Text(
            '📧 Contact Us',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 1.seconds).slideY(),
          
          const SizedBox(height: 20),
          
          Text(
            'Have questions about Naam Jhap? We\'d love to hear from you!',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 0.5.seconds, duration: 1.seconds).slideY(),
          
          const SizedBox(height: 60),
          
          // Contact form
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.whiteText,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person, color: AppColors.primaryOrange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.gradientStart.withOpacity(0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 0.7.seconds, duration: 1.seconds).slideY(),
                  
                  const SizedBox(height: 20),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Enter your email address',
                      prefixIcon: const Icon(Icons.email, color: AppColors.primaryOrange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.gradientStart.withOpacity(0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 0.9.seconds, duration: 1.seconds).slideY(),
                  
                  const SizedBox(height: 20),
                  
                  // Message field
                  TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Your Message',
                      hintText: 'Tell us about your questions, feedback, or how we can help you on your spiritual journey...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 100),
                        child: Icon(Icons.message, color: AppColors.primaryOrange),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.gradientStart.withOpacity(0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your message';
                      }
                      if (value.trim().length < 10) {
                        return 'Please enter a more detailed message (at least 10 characters)';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 1.1.seconds, duration: 1.seconds).slideY(),
                  
                  const SizedBox(height: 30),
                  
                  // Submit button
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: AppColors.whiteText,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: _isSubmitting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteText),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Sending...',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        : const Text(
                            'Send Message',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ).animate().fadeIn(delay: 1.3.seconds, duration: 1.seconds).slideY(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Contact information
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactInfo(
                  icon: Icons.email,
                  title: 'Email Us',
                  subtitle: 'Get in touch with us',
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'surbhit.thanvi@gmail.com',
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                ).animate().fadeIn(delay: 1.5.seconds, duration: 1.seconds).slideY(),
                
                _buildContactInfo(
                  icon: Icons.support_agent,
                  title: 'Support',
                  subtitle: 'We\'re here to help',
                ).animate().fadeIn(delay: 1.7.seconds, duration: 1.seconds).slideY(),
                
                _buildContactInfo(
                  icon: Icons.schedule,
                  title: 'Response Time',
                  subtitle: 'Within 24 hours',
                ).animate().fadeIn(delay: 1.9.seconds, duration: 1.seconds).slideY(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteText.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.whiteText.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
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
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
