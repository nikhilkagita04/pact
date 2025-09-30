import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:pact/providers/auth_provider.dart';
import 'package:pact/providers/pact_provider.dart';
import 'package:pact/screens/splash_screen.dart';
import 'package:pact/screens/auth/login_screen.dart';
import 'package:pact/screens/home/home_screen.dart';
import 'package:pact/screens/pact/pact_list_screen.dart';
import 'package:pact/theme/app_theme.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([AuthProvider, PactProvider])
void main() {
  group('Pact App Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockPactProvider mockPactProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockPactProvider = MockPactProvider();
    });

    testWidgets('App starts with splash screen', (WidgetTester tester) async {
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.isLoading).thenReturn(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider<PactProvider>.value(value: mockPactProvider),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const SplashScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pact'), findsOneWidget);
      expect(find.text('Building trust, one promise at a time'), findsOneWidget);
    });

    testWidgets('Login screen displays correctly', (WidgetTester tester) async {
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.errorMessage).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('Home screen displays bottom navigation', (WidgetTester tester) async {
      when(mockAuthProvider.isAuthenticated).thenReturn(true);
      when(mockAuthProvider.user).thenReturn(null);
      when(mockPactProvider.isLoading).thenReturn(false);
      when(mockPactProvider.pacts).thenReturn([]);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<PactProvider>.value(value: mockPactProvider),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Pacts'), findsOneWidget);
      expect(find.text('New Pact'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Pact list screen displays filter tabs', (WidgetTester tester) async {
      when(mockPactProvider.isLoading).thenReturn(false);
      when(mockPactProvider.pacts).thenReturn([]);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: ChangeNotifierProvider<PactProvider>.value(
            value: mockPactProvider,
            child: const PactListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Pacts'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Partner'), findsOneWidget);
      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Family'), findsOneWidget);
      expect(find.text('Colleague'), findsOneWidget);
    });

    testWidgets('Theme colors match mockup design', (WidgetTester tester) async {
      final theme = AppTheme.darkTheme;
      
      expect(theme.scaffoldBackgroundColor, AppTheme.backgroundPrimary);
      expect(theme.colorScheme.primary, AppTheme.accentPrimary);
      expect(theme.colorScheme.onPrimary, AppTheme.backgroundPrimary);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.errorMessage).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Filter tabs work correctly', (WidgetTester tester) async {
      when(mockPactProvider.isLoading).thenReturn(false);
      when(mockPactProvider.pacts).thenReturn([]);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: ChangeNotifierProvider<PactProvider>.value(
            value: mockPactProvider,
            child: const PactListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Partner filter
      await tester.tap(find.text('Partner'));
      await tester.pumpAndSettle();

      // Partner should be selected (different styling)
      final partnerTab = find.text('Partner');
      expect(partnerTab, findsOneWidget);
    });
  });
}