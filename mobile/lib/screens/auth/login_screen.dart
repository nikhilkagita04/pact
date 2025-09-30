import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'signup_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Sign in failed. Please try again.'),
            backgroundColor: AppTheme.accentCoral,
          ),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithGoogle();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Google sign in failed. Please try again.'),
            backgroundColor: AppTheme.accentCoral,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.space2XL),
                
                // Logo and title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.accentPrimary,
                              AppTheme.accentSecondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppTheme.shadowMD,
                        ),
                        child: const Center(
                          child: Text(
                            'Pact.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.backgroundPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spaceLG),
                      
                      Text(
                        'Welcome back',
                        style: AppTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppTheme.spaceSM),
                      
                      Text(
                        'Sign in to continue building trust through kept promises',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.space3XL),
                
                        // Google Sign In Button
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                                border: Border.all(
                                  color: AppTheme.surfaceContainerHighest,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: authProvider.isLoading ? null : _signInWithGoogle,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                                  ),
                                ),
                                icon: authProvider.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppTheme.textPrimary,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.g_mobiledata,
                                        color: AppTheme.textPrimary,
                                        size: 24,
                                      ),
                                label: Text(
                                  'Continue with Google',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                
                const SizedBox(height: AppTheme.spaceLG),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppTheme.surfaceContainerHighest)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
                      child: Text(
                        'or',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppTheme.surfaceContainerHighest)),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spaceLG),
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.textSecondary),
                    filled: true,
                    fillColor: AppTheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
                    hintStyle: AppTheme.bodyLarge.copyWith(color: AppTheme.textTertiary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spaceMD),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _signIn(),
                  style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined, color: AppTheme.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
                    hintStyle: AppTheme.bodyLarge.copyWith(color: AppTheme.textTertiary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spaceXL),
                
                // Sign in button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.accentPrimary,
                            AppTheme.accentSecondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        boxShadow: AppTheme.shadowMD,
                      ),
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.backgroundPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.backgroundPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppTheme.spaceLG),
                
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.accentPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.space2XL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
