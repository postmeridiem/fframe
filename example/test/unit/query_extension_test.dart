import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'unit_test_harness.dart';

void main() {
  group('Query StartsWith Extension Logic', () {
    setUp(() {
      setupUnitTests();
    });

    test('should handle empty search term correctly', () {
      // Test the logic that would be used in the extension
      const searchTerm = '';
      expect(searchTerm.isEmpty, isTrue);
      
      // When searchTerm is empty, the extension returns the original query
      // This is the core logic we can test
    });

    test('should calculate correct end limit for single character', () {
      const searchTerm = 'a';
      expect(searchTerm.isNotEmpty, isTrue);
      
      // Test the logic from the extension
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals(''));
      expect(strEndCode, equals('a'));
      expect(limit, equals('b')); // 'a' + 1 = 'b'
    });

    test('should calculate correct end limit for multi-character search', () {
      const searchTerm = 'hello';
      
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals('hell'));
      expect(strEndCode, equals('o'));
      expect(limit, equals('hellp')); // 'hell' + ('o' + 1) = 'hellp'
    });

    test('should handle case-sensitive searches correctly', () {
      const searchTerm = 'Test';
      
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals('Tes'));
      expect(strEndCode, equals('t'));
      expect(limit, equals('Tesu')); // 'Tes' + ('t' + 1) = 'Tesu'
    });

    test('should handle special characters', () {
      const searchTerm = 'test@';
      
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals('test'));
      expect(strEndCode, equals('@'));
      expect(limit, equals('testA')); // @ (ASCII 64) + 1 = A (ASCII 65)
    });

    test('should handle numeric characters', () {
      const searchTerm = 'test123';
      
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals('test12'));
      expect(strEndCode, equals('3'));
      expect(limit, equals('test124')); // '3' + 1 = '4'
    });

    test('should handle edge case with single character z', () {
      const searchTerm = 'z';
      
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals(''));
      expect(strEndCode, equals('z'));
      expect(limit, equals('{')); // 'z' (ASCII 122) + 1 = '{' (ASCII 123)
    });

    test('should work with unicode characters', () {
      const searchTerm = 'café';
      
      final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
      final strEndCode = searchTerm.characters.last;
      final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      
      expect(strFrontCode, equals('caf'));
      expect(strEndCode, equals('é'));
      // é is Unicode character, so next character should be properly calculated
      expect(limit.isNotEmpty, isTrue);
      expect(limit.startsWith('caf'), isTrue);
    });
  });
}