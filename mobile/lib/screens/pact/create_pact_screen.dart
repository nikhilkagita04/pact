import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pact_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/contact_provider.dart';
import '../../models/contact.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../home/home_screen.dart';

class CreatePactScreen extends StatefulWidget {
  const CreatePactScreen({super.key});

  @override
  State<CreatePactScreen> createState() => _CreatePactScreenState();
}

class _CreatePactScreenState extends State<CreatePactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  
  Contact? _selectedContact;
  bool _isCreatingPact = false;

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    await contactProvider.loadContacts();
  }

  void _filterContacts() {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    contactProvider.searchContacts(_searchController.text);
  }

  Future<void> _createPact() async {
    if (!_formKey.currentState!.validate() || _selectedContact == null) {
      return;
    }

    setState(() {
      _isCreatingPact = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final pactProvider = Provider.of<PactProvider>(context, listen: false);

      if (authProvider.user == null) {
        throw Exception('User not authenticated');
      }

      // Create pact using API service
      await ApiService.createPact(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        recipientId: _selectedContact!.id,
        recipientName: _selectedContact!.name,
        recipientPhone: _selectedContact!.phone,
      );

      // Refresh pacts
      await pactProvider.loadPacts(authProvider.user!.uid);

      if (mounted) {
        // Navigate to home screen to show the pact list
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pact created with ${_selectedContact!.name}!'),
            backgroundColor: AppTheme.accentPrimary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create pact: $e'),
            backgroundColor: AppTheme.accentCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingPact = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textPrimary,
          ),
        ),
        title: Text(
          'Create Pact',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title field
              Text(
                'What\'s the pact?',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spaceSM),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Pick up groceries',
                  hintStyle: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textPrimary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppTheme.spaceLG),
              
              // Description field
              Text(
                'Add details',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spaceSM),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g., Need to pick up milk, bread, and eggs from the store',
                  hintStyle: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textPrimary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppTheme.spaceLG),
              
              // Contact selection
              Text(
                'Who\'s this with?',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spaceSM),
              
              // Search field
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.textTertiary,
                  ),
                ),
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              
              const SizedBox(height: AppTheme.spaceMD),
              
              // Contact list
              Consumer<ContactProvider>(
                builder: (context, contactProvider, child) {
                  if (contactProvider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.space2XL),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentPrimary),
                        ),
                      ),
                    );
                  }

                  if (contactProvider.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.space2XL),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppTheme.accentCoral,
                            ),
                            const SizedBox(height: AppTheme.spaceSM),
                            Text(
                              contactProvider.errorMessage!,
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spaceSM),
                            ElevatedButton(
                              onPressed: () => contactProvider.loadContacts(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final contacts = contactProvider.filteredContacts;
                  
                  if (contacts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.space2XL),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(height: AppTheme.spaceSM),
                            Text(
                              'No contacts found',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: contacts.map((contact) {
                      final isSelected = _selectedContact?.id == contact.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppTheme.spaceSM),
                        child: Material(
                          color: isSelected 
                              ? AppTheme.accentPrimary.withValues(alpha: 0.2)
                              : AppTheme.backgroundTertiary,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedContact = contact;
                              });
                            },
                            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                            child: Padding(
                              padding: const EdgeInsets.all(AppTheme.spaceMD),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AppTheme.surfaceContainerHigh,
                                    backgroundImage: NetworkImage(contact.avatarUrl),
                                    onBackgroundImageError: (exception, stackTrace) {
                                      // Handle error
                                    },
                                  ),
                                  const SizedBox(width: AppTheme.spaceMD),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact.name,
                                          style: AppTheme.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          contact.phone,
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          contact.relationship.toUpperCase(),
                                          style: AppTheme.bodySmall.copyWith(
                                            color: AppTheme.textTertiary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.accentPrimary,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              
              const SizedBox(height: AppTheme.space2XL),
              
              // Create button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isCreatingPact ? null : _createPact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPrimary,
                    foregroundColor: const Color(0xFF111817),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                  ),
                  child: _isCreatingPact
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF111817),
                            ),
                          ),
                        )
                      : Text(
                          'Create Pact',
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111817),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}