import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PactCompletedScreen extends StatefulWidget {
  final String recipientName;
  final String recipientAvatar;

  const PactCompletedScreen({
    super.key,
    required this.recipientName,
    required this.recipientAvatar,
  });

  @override
  State<PactCompletedScreen> createState() => _PactCompletedScreenState();
}

class _PactCompletedScreenState extends State<PactCompletedScreen>
    with TickerProviderStateMixin {
  late AnimationController _popInController;
  late AnimationController _heartController;
  late Animation<double> _popInAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pop-in animation for avatars and text
    _popInController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Heart flying animation
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _popInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _popInController,
      curve: Curves.easeOutCubic,
    ));

    _heartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _popInController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _heartController.forward();
    });
  }

  @override
  void dispose() {
    _popInController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Column(
        children: [
          // Main content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar section with animations
                    _buildAvatarSection(),
                    
                    const SizedBox(height: 48),
                    
                    // Title with animation
                    AnimatedBuilder(
                      animation: _popInAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _popInAnimation.value)),
                          child: Opacity(
                            opacity: _popInAnimation.value,
                            child: Text(
                              'Pact Complete!',
                              style: AppTheme.displayLarge.copyWith(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subtitle with animation
                    AnimatedBuilder(
                      animation: _popInAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _popInAnimation.value)),
                          child: Opacity(
                            opacity: _popInAnimation.value,
                            child: Text(
                              '${widget.recipientName} sent you a ❤️!',
                              style: AppTheme.titleLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom button
          Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _popInAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _popInAnimation.value)),
                  child: Opacity(
                    opacity: _popInAnimation.value,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPrimary,
                          foregroundColor: const Color(0xFF111817),
                          elevation: 8,
                          shadowColor: AppTheme.accentPrimary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                        ),
                        child: Text(
                          'Got it!',
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111817),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return AnimatedBuilder(
      animation: _popInAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _popInAnimation.value),
          child: Opacity(
            opacity: _popInAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // First avatar
                Transform.translate(
                  offset: const Offset(-28, 0),
                  child: _buildAvatar(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA732CG33VbYhX_gCya0ra2C6xhS3ABt9TirLR2FtNQy319VDHSl_5C_zYzkCMuudHN-RSOR5a1bpB7atTaOVD_kpK6-5Qsl3cYkBF6VU-KxymaQ85uArjeu2nWJxagZv9DqFP145cUCt9dzH5lZ3vhpZxngfASb89OpVvyeV4B9asT7SnlFDD1QWyximfLE4UdgSMbqLU7E4kjIJqTBPYxEePpFEjgjsiJyX2yHp5Lz1C4KwgqPBkVPYV8eJjRdHXrEO31siQ6_LGi',
                    delay: 200,
                  ),
                ),
                
                // Second avatar
                Transform.translate(
                  offset: const Offset(28, 0),
                  child: _buildAvatar(
                    widget.recipientAvatar,
                    delay: 300,
                  ),
                ),
                
                // Flying heart
                AnimatedBuilder(
                  animation: _heartAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -40 * _heartAnimation.value),
                      child: Opacity(
                        opacity: (1 - _heartAnimation.value),
                        child: Text(
                          '❤️',
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String imageUrl, {required int delay}) {
    return AnimatedBuilder(
      animation: _popInAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _popInAnimation.value),
          child: Opacity(
            opacity: _popInAnimation.value,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.backgroundPrimary,
                  width: 4,
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
