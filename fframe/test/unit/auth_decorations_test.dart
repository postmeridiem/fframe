import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/components/auth/decorations.dart';

void main() {
  group('AuthDecorations', () {
    test('headerImage returns a valid HeaderBuilder', () {
      final builder = headerImage('assets/images/logo.png');
      expect(builder, isA<Function>());
    });

    test('headerIcon returns a valid HeaderBuilder', () {
      final builder = headerIcon(Icons.person);
      expect(builder, isA<Function>());
    });

    test('sideImage returns a valid SideBuilder', () {
      final builder = sideImage('assets/images/logo.png');
      expect(builder, isA<Function>());
    });

    test('sideIcon returns a valid SideBuilder', () {
      final builder = sideIcon(Icons.person);
      expect(builder, isA<Function>());
    });
  });
}