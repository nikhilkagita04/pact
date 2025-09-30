import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/pact.dart';

class RequestScreen extends StatefulWidget {
  final Pact pact;

  const RequestScreen({
    super.key,
    required this.pact,
  });

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?q=80&w=2524&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF242424).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar and title
                        Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2D2D2D),
                                  width: 4,
                                ),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDyW4YuB4366Qwh_uMzqs3ii53OYiU0uVWWjNxREnkKecZAwCJfz9U3iQgp0z8hzXs3BgcYT7ryS_nWqEgzYqlrnQ1LJQRYBkJ2PCHm3zYKbKVgQaHZCbQ5Sdwjimi9Y7mYcsSTTqumrX7mKueSATJZZfGAKZEpgdqM7BPZec64vu_CMmaJH7CIY_EIaQyopKVZ8uFudyMQ0ybw7_ZzVh7gMxFRgbEnBibaMiLzZ_irGPoSOUFEJsmVRZYkXFzGoWDRgycRwkOHZwj8',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'New Request from ${widget.pact.recipientName}',
                              style: AppTheme.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Message
                        Text(
                          '"${widget.pact.description}"',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Heart icon with pulse animation
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _pulseAnimation.value,
                              child: const Icon(
                                Icons.favorite,
                                color: Color(0xFFFF6B6B),
                                size: 32,
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Buttons
                        Column(
                          children: [
                            // Accept button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _acceptRequest(),
                                  borderRadius: BorderRadius.circular(28),
                                  child: Center(
                                    child: Text(
                                      'Accept',
                                      style: AppTheme.titleMedium.copyWith(
                                        color: const Color(0xFF111817),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Decline button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF4A4A4A),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _declineRequest(),
                                  borderRadius: BorderRadius.circular(28),
                                  child: Center(
                                    child: Text(
                                      'Decline',
                                      style: AppTheme.titleMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Adjust link
                        TextButton(
                          onPressed: () => _showAdjustOptions(),
                          child: Text(
                            'Need to adjust? •••',
                            style: AppTheme.bodyMedium.copyWith(
                              color: const Color(0xFF9DB9B6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _acceptRequest() {
    // TODO: Implement accept logic
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request accepted!'),
        backgroundColor: AppTheme.accentPrimary,
      ),
    );
  }

  void _declineRequest() {
    // TODO: Implement decline logic
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request declined'),
        backgroundColor: AppTheme.accentCoral,
      ),
    );
  }

  void _showAdjustOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Adjust Request',
              style: AppTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.accentPrimary),
              title: const Text('Edit Details'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: AppTheme.accentPrimary),
              title: const Text('Change Due Date'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement change due date
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppTheme.accentPrimary),
              title: const Text('Change Assignee'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement change assignee
              },
            ),
          ],
        ),
      ),
    );
  }
}
