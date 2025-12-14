import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cool_ui/cool_ui.dart';

void main() {
  group('CoolThemeExtension', () {
    test('should create theme extension with required colors', () {
      final theme = CoolThemeExtension(
        primaryColor: Colors.blue,
        secondaryColor: Colors.red,
        themeMode: ThemeMode.light,
      );
      
      expect(theme.primaryColor, Colors.blue);
      expect(theme.secondaryColor, Colors.red);
      expect(theme.themeMode, ThemeMode.light);
    });
    
    test('should resolve colors correctly', () {
      final theme = CoolThemeExtension(
        primaryColor: Colors.blue,
        secondaryColor: Colors.red,
        themeMode: ThemeMode.light,
      );
      
      final color = theme.colorSystem.resolve(CoolColorToken.primary);
      expect(color, Colors.blue);
    });
  });
  
  group('CoolColorSystem', () {
    test('should generate color system from primary and secondary', () {
      final colorSystem = CoolColorSystem(
        primaryColor: Colors.blue,
        secondaryColor: Colors.red,
        isDark: false,
      );
      
      expect(colorSystem.primaryColor, Colors.blue);
      expect(colorSystem.secondaryColor, Colors.red);
      expect(colorSystem.isDark, false);
    });
  });
  
  group('CoolRadiusScale', () {
    test('should provide radius values', () {
      expect(CoolRadiusScale.xs, 4.0);
      expect(CoolRadiusScale.sm, 8.0);
      expect(CoolRadiusScale.md, 12.0);
      expect(CoolRadiusScale.lg, 16.0);
      expect(CoolRadiusScale.xl, 20.0);
      expect(CoolRadiusScale.xxl, 24.0);
    });
  });
}
