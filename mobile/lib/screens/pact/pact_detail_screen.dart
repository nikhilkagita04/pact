import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pact_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/pact.dart';

class PactDetailScreen extends StatelessWidget {
  final Pact pact;

  const PactDetailScreen({
    super.key,
    required this.pact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundPrimary,
        elevation: 0,
        title: const Text('Pact Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppTheme.accentCoral),
                    SizedBox(width: AppTheme.spaceSM),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pact card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with contact info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppTheme.accentPrimary.withOpacity(0.2),
                          child: Text(
                            pact.recipientName.isNotEmpty
                                ? pact.recipientName[0].toUpperCase()
                                : '?',
                            style: AppTheme.headlineSmall.copyWith(
                              color: AppTheme.accentPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pact.recipientName,
                                style: AppTheme.headlineSmall,
                              ),
                              Text(
                                pact.recipientPhone,
                                style: AppTheme.bodyLarge.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (pact.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceMD,
                              vertical: AppTheme.spaceSM,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.accentPrimary,
                                  size: 16,
                                ),
                                const SizedBox(width: AppTheme.spaceXS),
                                Text(
                                  'Completed',
                                  style: AppTheme.labelLarge.copyWith(
                                    color: AppTheme.accentPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spaceXL),
                    
                    // Pact title
                    Text(
                      pact.title,
                      style: AppTheme.headlineMedium,
                    ),
                    
                    if (pact.description.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spaceMD),
                      Text(
                        pact.description,
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceXL),
            
            // Status section
            Text(
              'Status',
              style: AppTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spaceMD),
            
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        pact.isCompleted ? Icons.check_circle : Icons.schedule,
                        color: pact.isCompleted ? AppTheme.accentPrimary : AppTheme.textTertiary,
                      ),
                      const SizedBox(width: AppTheme.spaceMD),
                      Text(
                        pact.isCompleted ? 'Completed' : 'In Progress',
                        style: AppTheme.titleMedium,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spaceMD),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppTheme.textTertiary,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.spaceSM),
                      Text(
                        'Created ${_formatDate(pact.createdAt)}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  
                  if (pact.isCompleted && pact.completedAt != null) ...[
                    const SizedBox(height: AppTheme.spaceSM),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppTheme.accentPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: AppTheme.spaceSM),
                        Text(
                          'Completed ${_formatDate(pact.completedAt!)}',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.accentPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.space2XL),
            
            // Action buttons
            if (!pact.isCompleted) ...[
              Consumer<PactProvider>(
                builder: (context, pactProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: pactProvider.isLoading ? null : () => _completePact(context),
                      child: pactProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.backgroundPrimary),
                              ),
                            )
                          : const Text('Mark as Complete'),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pact'),
        content: const Text(
          'Are you sure you want to delete this pact? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePact(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentCoral,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _completePact(BuildContext context) async {
    try {
      final pactProvider = Provider.of<PactProvider>(context, listen: false);
      await pactProvider.completePact(pact.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pact completed! 🎉'),
            backgroundColor: AppTheme.accentPrimary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete pact: $e'),
            backgroundColor: AppTheme.accentCoral,
          ),
        );
      }
    }
  }

  Future<void> _deletePact(BuildContext context) async {
    try {
      final pactProvider = Provider.of<PactProvider>(context, listen: false);
      await pactProvider.deletePact(pact.id);
      
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pact deleted'),
            backgroundColor: AppTheme.accentCoral,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete pact: $e'),
            backgroundColor: AppTheme.accentCoral,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return 'on ${date.day}/${date.month}/${date.year}';
    }
  }
}
