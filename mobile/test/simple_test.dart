import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pact/theme/app_theme.dart';

void main() {
  group('Pact App Core Tests', () {
    testWidgets('Theme colors match mockup design', (WidgetTester tester) async {
      final theme = AppTheme.darkTheme;
      
      expect(theme.scaffoldBackgroundColor, AppTheme.backgroundPrimary);
      expect(theme.colorScheme.primary, AppTheme.accentPrimary);
      expect(theme.colorScheme.onPrimary, AppTheme.backgroundPrimary);
    });

    testWidgets('App theme has correct color values', (WidgetTester tester) async {
      // Test that our theme colors match the phone mockups exactly
      expect(AppTheme.backgroundPrimary, const Color(0xFF1A1A1A));
      expect(AppTheme.backgroundSecondary, const Color(0xFF1A1C1C));
      expect(AppTheme.backgroundTertiary, const Color(0xFF2D3030));
      expect(AppTheme.textPrimary, const Color(0xFFF4F4F5));
      expect(AppTheme.textSecondary, const Color(0xFFA1A1AA));
      expect(AppTheme.textTertiary, const Color(0xFF71717A));
      expect(AppTheme.accentPrimary, const Color(0xFF11D4C1));
      expect(AppTheme.accentWarm, const Color(0xFFFF6B6B));
    });

    testWidgets('Theme typography uses correct font family', (WidgetTester tester) async {
      expect(AppTheme.fontFamily, 'Plus Jakarta Sans');
    });

    testWidgets('Theme has correct spacing values', (WidgetTester tester) async {
      expect(AppTheme.spaceXS, 8.0);
      expect(AppTheme.spaceSM, 16.0);
      expect(AppTheme.spaceMD, 24.0);
      expect(AppTheme.spaceLG, 32.0);
      expect(AppTheme.spaceXL, 48.0);
    });

    testWidgets('Theme has correct border radius values', (WidgetTester tester) async {
      expect(AppTheme.radiusXS, 6.0);
      expect(AppTheme.radiusSM, 12.0);
      expect(AppTheme.radiusMD, 16.0);
      expect(AppTheme.radiusLG, 24.0);
      expect(AppTheme.radiusXL, 32.0);
      expect(AppTheme.radiusPill, 9999.0);
    });

    testWidgets('Basic MaterialApp renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(
              child: Text('Pact App'),
            ),
          ),
        ),
      );

      expect(find.text('Pact App'), findsOneWidget);
    });
  });
}
