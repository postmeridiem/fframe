import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:example/themes/config.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Theme Configuration', () {
    timedGroup('Fonts Class', () {
      timedTest('should have correct default font values', () {
        final fonts = Fonts();
        
        expect(fonts.mainFont, equals('OpenSans'));
        expect(fonts.monoFont, equals('RobotoMono'));
      });

      timedTest('should allow font values to be modified', () {
        final fonts = Fonts();
        
        fonts.mainFont = 'Poppins';
        fonts.monoFont = 'SourceCodePro';
        
        expect(fonts.mainFont, equals('Poppins'));
        expect(fonts.monoFont, equals('SourceCodePro'));
      });

      timedTest('should handle various font family names', () {
        final fonts = Fonts();
        const testFonts = [
          'Roboto',
          'Inter',
          'Montserrat',
          'Lato',
          'Source Code Pro',
          'JetBrains Mono',
        ];
        
        for (final fontName in testFonts) {
          fonts.mainFont = fontName;
          expect(fonts.mainFont, equals(fontName));
        }
      });
    });

    timedGroup('SignalColors Class', () {
      timedTest('should have correct signal color values', () {
        final signalColors = SignalColors();
        
        expect(signalColors.constAccentColor, equals(const Color.fromARGB(255, 21, 206, 163)));
        expect(signalColors.constWaitingColor, equals(const Color.fromARGB(255, 72, 72, 72)));
        expect(signalColors.constWarningColor, equals(const Color.fromARGB(255, 241, 126, 32)));
        expect(signalColors.constRunningColor, equals(const Color.fromARGB(255, 203, 134, 235)));
        expect(signalColors.constSuccessColor, equals(const Color.fromARGB(255, 6, 178, 83)));
        expect(signalColors.constErrorColor, equals(const Color.fromARGB(255, 192, 64, 61)));
      });

      timedTest('should have valid Color objects', () {
        final signalColors = SignalColors();
        
        expect(signalColors.constAccentColor, isA<Color>());
        expect(signalColors.constWaitingColor, isA<Color>());
        expect(signalColors.constWarningColor, isA<Color>());
        expect(signalColors.constRunningColor, isA<Color>());
        expect(signalColors.constSuccessColor, isA<Color>());
        expect(signalColors.constErrorColor, isA<Color>());
      });

      timedTest('should have appropriate alpha values', () {
        final signalColors = SignalColors();
        
        // All signal colors should be fully opaque
        expect(signalColors.constAccentColor.alpha, equals(255));
        expect(signalColors.constWaitingColor.alpha, equals(255));
        expect(signalColors.constWarningColor.alpha, equals(255));
        expect(signalColors.constRunningColor.alpha, equals(255));
        expect(signalColors.constSuccessColor.alpha, equals(255));
        expect(signalColors.constErrorColor.alpha, equals(255));
      });

      timedTest('should allow signal colors to be modified', () {
        final signalColors = SignalColors();
        
        signalColors.constAccentColor = Colors.blue;
        signalColors.constErrorColor = Colors.red;
        
        expect(signalColors.constAccentColor, equals(Colors.blue));
        expect(signalColors.constErrorColor, equals(Colors.red));
      });
    });

    timedGroup('DarkModeThemeConfig Class', () {
      timedTest('should have correct brightness setting', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.brightness, equals(Brightness.dark));
      });

      timedTest('should have correct primary color configuration', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constPrimaryColor, equals(const Color.fromARGB(255, 78, 6, 31)));
        expect(darkConfig.constOnPrimaryColor, equals(const Color.fromARGB(255, 255, 255, 255)));
      });

      timedTest('should have correct secondary color configuration', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constSecondaryColor, equals(const Color.fromARGB(255, 33, 33, 33)));
        expect(darkConfig.constOnSecondaryColor, equals(const Color.fromARGB(255, 238, 238, 238)));
      });

      timedTest('should have correct tertiary color configuration', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constTertiaryColor, equals(const Color.fromARGB(255, 14, 13, 13)));
        expect(darkConfig.constOnTertiaryColor, equals(const Color.fromARGB(255, 238, 238, 238)));
      });

      timedTest('should have correct surface color configuration', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constSurfaceColor, equals(const Color.fromARGB(255, 78, 6, 31)));
        expect(darkConfig.constOnSurfaceColor, equals(const Color.fromARGB(255, 255, 255, 255)));
      });

      timedTest('should have correct surface variant color configuration', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constSurfaceVariantColor, equals(const Color.fromARGB(255, 14, 13, 13)));
        expect(darkConfig.constOnSurfaceVariantColor, equals(const Color.fromARGB(255, 238, 238, 238)));
      });

      timedTest('should have correct accent and utility colors', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constPrimaryAccentColor, equals(const Color.fromARGB(255, 5, 202, 198)));
        expect(darkConfig.constUnselectedColor, equals(const Color.fromARGB(177, 233, 233, 233)));
        expect(darkConfig.constDividerColor, equals(const Color.fromARGB(177, 28, 28, 28)));
      });

      timedTest('should have correct background color configuration', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.constBackgroundColor, equals(const Color.fromARGB(255, 14, 13, 13)));
        expect(darkConfig.constOnBackgroundColor, equals(const Color.fromARGB(255, 238, 238, 238)));
        expect(darkConfig.constBackgroundColorFaded, equals(const Color.fromARGB(255, 51, 2, 22)));
      });

      timedTest('should include signal colors and fonts', () {
        final darkConfig = DarkModeThemeConfig();
        
        expect(darkConfig.signalColors, isA<SignalColors>());
        expect(darkConfig.fonts, isA<Fonts>());
        expect(darkConfig.signalColors.constAccentColor, equals(const Color.fromARGB(255, 21, 206, 163)));
        expect(darkConfig.fonts.mainFont, equals('OpenSans'));
      });

      timedTest('should have valid dark theme colors (dark background, light text)', () {
        final darkConfig = DarkModeThemeConfig();
        
        // Background should be dark
        expect(darkConfig.constBackgroundColor.computeLuminance(), lessThan(0.5));
        expect(darkConfig.constTertiaryColor.computeLuminance(), lessThan(0.5));
        
        // Text on dark backgrounds should be light
        expect(darkConfig.constOnBackgroundColor.computeLuminance(), greaterThan(0.5));
        expect(darkConfig.constOnTertiaryColor.computeLuminance(), greaterThan(0.5));
      });
    });

    timedGroup('LightModeThemeConfig Class', () {
      timedTest('should have correct brightness setting', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.brightness, equals(Brightness.light));
      });

      timedTest('should have correct primary color configuration', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constPrimaryColor, equals(const Color.fromARGB(255, 97, 5, 37)));
        expect(lightConfig.constOnPrimaryColor, equals(const Color.fromARGB(255, 255, 255, 255)));
      });

      timedTest('should have correct secondary color configuration', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constSecondaryColor, equals(const Color.fromARGB(255, 244, 243, 244)));
        expect(lightConfig.constOnSecondaryColor, equals(const Color.fromARGB(176, 28, 28, 28)));
      });

      timedTest('should have correct tertiary color configuration', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constTertiaryColor, equals(const Color.fromARGB(255, 255, 255, 255)));
        expect(lightConfig.constOnTertiaryColor, equals(const Color.fromARGB(255, 114, 7, 45)));
      });

      timedTest('should have correct surface color configuration', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constSurfaceColor, equals(const Color.fromARGB(255, 229, 222, 226)));
        expect(lightConfig.constOnSurfaceColor, equals(const Color.fromARGB(176, 28, 28, 28)));
      });

      timedTest('should have correct surface variant color configuration', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constSurfaceVariantColor, equals(const Color.fromARGB(255, 255, 255, 255)));
        expect(lightConfig.constOnSurfaceVariantColor, equals(const Color.fromARGB(255, 49, 4, 20)));
      });

      timedTest('should have correct accent and utility colors', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constPrimaryAccentColor, equals(const Color.fromARGB(255, 0, 138, 136)));
        expect(lightConfig.constUnselectedColor, equals(const Color.fromARGB(177, 71, 71, 71)));
        expect(lightConfig.constDividerColor, equals(const Color.fromARGB(177, 182, 182, 182)));
      });

      timedTest('should have correct background color configuration', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.constBackgroundColor, equals(const Color.fromARGB(255, 255, 255, 255)));
        expect(lightConfig.constOnBackgroundColor, equals(const Color.fromARGB(255, 27, 2, 11)));
        expect(lightConfig.constOnBackgroundColorFaded, equals(const Color.fromARGB(255, 218, 200, 207)));
      });

      timedTest('should include signal colors and fonts', () {
        final lightConfig = LightModeThemeConfig();
        
        expect(lightConfig.signalColors, isA<SignalColors>());
        expect(lightConfig.fonts, isA<Fonts>());
        expect(lightConfig.signalColors.constAccentColor, equals(const Color.fromARGB(255, 21, 206, 163)));
        expect(lightConfig.fonts.mainFont, equals('OpenSans'));
      });

      timedTest('should have valid light theme colors (light background, dark text)', () {
        final lightConfig = LightModeThemeConfig();
        
        // Background should be light
        expect(lightConfig.constBackgroundColor.computeLuminance(), greaterThan(0.5));
        expect(lightConfig.constTertiaryColor.computeLuminance(), greaterThan(0.5));
        
        // Text on light backgrounds should be dark
        expect(lightConfig.constOnBackgroundColor.computeLuminance(), lessThan(0.5));
        expect(lightConfig.constOnTertiaryColor.computeLuminance(), lessThan(0.5));
      });
    });

    timedGroup('Theme Consistency', () {
      timedTest('should have consistent signal colors between light and dark themes', () {
        final darkConfig = DarkModeThemeConfig();
        final lightConfig = LightModeThemeConfig();
        
        expect(darkConfig.signalColors.constAccentColor, equals(lightConfig.signalColors.constAccentColor));
        expect(darkConfig.signalColors.constWarningColor, equals(lightConfig.signalColors.constWarningColor));
        expect(darkConfig.signalColors.constErrorColor, equals(lightConfig.signalColors.constErrorColor));
        expect(darkConfig.signalColors.constSuccessColor, equals(lightConfig.signalColors.constSuccessColor));
      });

      timedTest('should have consistent fonts between light and dark themes', () {
        final darkConfig = DarkModeThemeConfig();
        final lightConfig = LightModeThemeConfig();
        
        expect(darkConfig.fonts.mainFont, equals(lightConfig.fonts.mainFont));
        expect(darkConfig.fonts.monoFont, equals(lightConfig.fonts.monoFont));
      });

      timedTest('should have contrasting primary colors between themes', () {
        final darkConfig = DarkModeThemeConfig();
        final lightConfig = LightModeThemeConfig();
        
        // Primary colors should be different between themes
        expect(darkConfig.constPrimaryColor, isNot(equals(lightConfig.constPrimaryColor)));
        
        // But both should be relatively dark (primary colors typically are)
        expect(darkConfig.constPrimaryColor.computeLuminance(), lessThan(0.5));
        expect(lightConfig.constPrimaryColor.computeLuminance(), lessThan(0.5));
      });

      timedTest('should have contrasting background colors between themes', () {
        final darkConfig = DarkModeThemeConfig();
        final lightConfig = LightModeThemeConfig();
        
        // Background colors should be very different
        expect(darkConfig.constBackgroundColor, isNot(equals(lightConfig.constBackgroundColor)));
        
        // Dark theme background should be dark, light theme should be light
        expect(darkConfig.constBackgroundColor.computeLuminance(), lessThan(0.3));
        expect(lightConfig.constBackgroundColor.computeLuminance(), greaterThan(0.7));
      });

      timedTest('should have appropriate contrast ratios', () {
        final darkConfig = DarkModeThemeConfig();
        final lightConfig = LightModeThemeConfig();
        
        // Test contrast between background and on-background colors
        final darkContrast = _calculateContrastRatio(
          darkConfig.constBackgroundColor,
          darkConfig.constOnBackgroundColor,
        );
        final lightContrast = _calculateContrastRatio(
          lightConfig.constBackgroundColor,
          lightConfig.constOnBackgroundColor,
        );
        
        // Both should meet WCAG AA standards (4.5:1 minimum)
        expect(darkContrast, greaterThan(4.5));
        expect(lightContrast, greaterThan(4.5));
      });
    });

    timedGroup('Color Modification', () {
      timedTest('should allow theme colors to be modified', () {
        final darkConfig = DarkModeThemeConfig();
        
        final originalPrimary = darkConfig.constPrimaryColor;
        darkConfig.constPrimaryColor = Colors.purple;
        
        expect(darkConfig.constPrimaryColor, equals(Colors.purple));
        expect(darkConfig.constPrimaryColor, isNot(equals(originalPrimary)));
      });

      timedTest('should allow independent modification of theme instances', () {
        final darkConfig1 = DarkModeThemeConfig();
        final darkConfig2 = DarkModeThemeConfig();
        
        darkConfig1.constPrimaryColor = Colors.red;
        darkConfig2.constPrimaryColor = Colors.blue;
        
        expect(darkConfig1.constPrimaryColor, equals(Colors.red));
        expect(darkConfig2.constPrimaryColor, equals(Colors.blue));
        expect(darkConfig1.constPrimaryColor, isNot(equals(darkConfig2.constPrimaryColor)));
      });
    });
  });
}

// Helper function to calculate contrast ratio between two colors
double _calculateContrastRatio(Color color1, Color color2) {
  final luminance1 = color1.computeLuminance();
  final luminance2 = color2.computeLuminance();
  
  final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
  final darkest = luminance1 < luminance2 ? luminance1 : luminance2;
  
  return (brightest + 0.05) / (darkest + 0.05);
}