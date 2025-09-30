import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pact_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/pact.dart';
import 'pact_detail_screen.dart';
import 'create_pact_screen.dart';

class PactListScreen extends StatefulWidget {
  const PactListScreen({super.key});

  @override
  State<PactListScreen> createState() => _PactListScreenState();
}

class _PactListScreenState extends State<PactListScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSecondary,
      body: Column(
        children: [
          // Header - exact match from mockup
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const SizedBox(width: 40), // Spacer for centering
                Expanded(
                  child: Text(
                    'My Pacts',
                    style: AppTheme.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreatePactScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppTheme.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter tabs - exact match from mockup
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterTab('All', _selectedFilter == 'All'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab('Partner', _selectedFilter == 'Partner'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab('Friends', _selectedFilter == 'Friends'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab('Family', _selectedFilter == 'Family'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab('Colleague', _selectedFilter == 'Colleague'),
                ),
              ],
            ),
          ),
          
          const Divider(
            color: AppTheme.borderColor,
            height: 1,
          ),
          
          // Pact list
          Expanded(
            child: _buildPactList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF111817) : AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  Widget _buildPactList() {
    return Consumer<PactProvider>(
      builder: (context, pactProvider, child) {
        if (pactProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentPrimary),
            ),
          );
        }

        final pacts = pactProvider.pacts;

        if (pacts.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pacts.length,
          itemBuilder: (context, index) {
            final pact = pacts[index];
            return _buildPactCard(pact, index);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space2XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.handshake_outlined,
              size: 80,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppTheme.spaceLG),
            Text(
              'No pacts yet',
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            Text(
              'Create your first pact to start building trust',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPactCard(Pact pact, int index) {
    // Use actual pact data only
    final pactData = {
      'title': pact.title,
      'recipientName': pact.recipientName,
      'isCompleted': pact.isCompleted,
      'status': pact.isCompleted ? 'Completed today' : 'Due in 2 days',
      'avatar': 'https://via.placeholder.com/24',
      'showStreak': false,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          // Main pact card
          Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundTertiary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PactDetailScreen(pact: pact),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Checkbox - exact match from mockup
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: (pactData['isCompleted'] as bool) ? AppTheme.accentPrimary : Colors.transparent,
                        border: Border.all(
                          color: (pactData['isCompleted'] as bool) ? AppTheme.accentPrimary : AppTheme.checkboxUnchecked,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: (pactData['isCompleted'] as bool)
                          ? const Icon(
                              Icons.check,
                              color: Color(0xFF111817),
                              size: 16,
                            )
                          : null,
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pactData['title'] as String,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppTheme.surfaceContainerHigh,
                                backgroundImage: NetworkImage(pactData['avatar'] as String),
                                onBackgroundImageError: (exception, stackTrace) {
                                  // Handle error
                                },
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'with ${pactData['recipientName']}',
                                style: AppTheme.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                pactData['status'] as String,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Streak message - exact match from mockup
          if ((pactData['showStreak'] as bool) == true) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 44), // Align with content
              child: Text(
                pactData['streakText'] as String,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.amberAccent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}