import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/components/auth/decorations.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('AuthDecorations', () {
    timedTest('headerImage returns a valid HeaderBuilder', () {
      final builder = headerImage('assets/images/logo.png');
      expect(builder, isA<Function>());
    });

    timedTest('headerIcon returns a valid HeaderBuilder', () {
      final builder = headerIcon(Icons.person);
      expect(builder, isA<Function>());
    });

    timedTest('sideImage returns a valid SideBuilder', () {
      final builder = sideImage('assets/images/logo.png');
      expect(builder, isA<Function>());
    });

    timedTest('sideIcon returns a valid SideBuilder', () {
      final builder = sideIcon(Icons.person);
      expect(builder, isA<Function>());
    });
  });
}