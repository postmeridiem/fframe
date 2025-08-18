import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';
import 'package:example/models/suggestion.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Suggestion Model', () {
    timedTest('should create Suggestion with all parameters', () {
      final creationDate = Timestamp.now();
      final followers = ['user1@example.com', 'user2@example.com'];
      
      final suggestion = Suggestion(
        id: 'test-suggestion-123',
        name: 'Test Suggestion',
        assignee: 'john.doe@example.com',
        followers: followers,
        status: 'open',
        active: true,
        icon: 'lightbulb',
        fieldTab1: 'Tab 1 Content',
        fieldTab2: 'Tab 2 Content', 
        fieldTab3: 'Tab 3 Content',
        creationDate: creationDate,
        createdBy: 'test-user',
        saveCount: 5.0,
        priority: 2.5,
      );
      
      expect(suggestion.id, equals('test-suggestion-123'));
      expect(suggestion.name, equals('Test Suggestion'));
      expect(suggestion.assignee, equals('john.doe@example.com'));
      expect(suggestion.followers, equals(followers));
      expect(suggestion.status, equals('open'));
      expect(suggestion.active, isTrue);
      expect(suggestion.icon, equals('lightbulb'));
      expect(suggestion.fieldTab1, equals('Tab 1 Content'));
      expect(suggestion.fieldTab2, equals('Tab 2 Content'));
      expect(suggestion.fieldTab3, equals('Tab 3 Content'));
      expect(suggestion.creationDate, equals(creationDate));
      expect(suggestion.createdBy, equals('test-user'));
      expect(suggestion.saveCount, equals(5.0));
      expect(suggestion.priority, equals(2.5));
    });

    timedTest('should create Suggestion with minimal parameters and defaults', () {
      final suggestion = Suggestion();
      
      expect(suggestion.id, isNull);
      expect(suggestion.name, isNull);
      expect(suggestion.assignee, isNull);
      expect(suggestion.followers, isNull);
      expect(suggestion.status, isNull);
      expect(suggestion.active, isNull);
      expect(suggestion.icon, isNull);
      expect(suggestion.fieldTab1, isNull);
      expect(suggestion.fieldTab2, isNull);
      expect(suggestion.fieldTab3, isNull);
      expect(suggestion.creationDate, isNull);
      expect(suggestion.createdBy, isNull);
      expect(suggestion.saveCount, equals(0)); // Default value
      expect(suggestion.priority, equals(3.0)); // Default value
    });

    timedTest('should use correct default values', () {
      final suggestion1 = Suggestion();
      final suggestion2 = Suggestion(saveCount: 10.0, priority: 1.0);
      
      // Test defaults
      expect(suggestion1.saveCount, equals(0));
      expect(suggestion1.priority, equals(3.0));
      
      // Test override defaults
      expect(suggestion2.saveCount, equals(10.0));
      expect(suggestion2.priority, equals(1.0));
    });

    timedTest('should allow all mutable properties to be changed', () {
      final suggestion = Suggestion(
        name: 'Initial Suggestion',
        status: 'draft',
        active: true,
        saveCount: 1.0,
        priority: 5.0,
      );
      
      // Test mutability of all properties
      suggestion.id = 'updated-id';
      suggestion.name = 'Updated Suggestion';
      suggestion.trackerId = 'tracker-123';
      suggestion.linkedPath = '/suggestions/123';
      suggestion.linkedDocumentId = 'doc-456';
      suggestion.status = 'in-progress';
      suggestion.assignee = 'new.assignee@example.com';
      suggestion.followers = ['follower1@example.com'];
      suggestion.description = 'Updated description';
      suggestion.active = false;
      suggestion.icon = 'new_icon';
      suggestion.fieldTab1 = 'New Tab 1';
      suggestion.fieldTab2 = 'New Tab 2';
      suggestion.fieldTab3 = 'New Tab 3';
      suggestion.creationDate = Timestamp.now();
      suggestion.assignmentTime = Timestamp.now();
      suggestion.dueTime = Timestamp.now();
      suggestion.createdBy = 'new-creator';
      suggestion.saveCount = 10.0;
      suggestion.priority = 1.0;
      
      expect(suggestion.id, equals('updated-id'));
      expect(suggestion.name, equals('Updated Suggestion'));
      expect(suggestion.trackerId, equals('tracker-123'));
      expect(suggestion.linkedPath, equals('/suggestions/123'));
      expect(suggestion.linkedDocumentId, equals('doc-456'));
      expect(suggestion.status, equals('in-progress'));
      expect(suggestion.assignee, equals('new.assignee@example.com'));
      expect(suggestion.followers, equals(['follower1@example.com']));
      expect(suggestion.description, equals('Updated description'));
      expect(suggestion.active, isFalse);
      expect(suggestion.icon, equals('new_icon'));
      expect(suggestion.fieldTab1, equals('New Tab 1'));
      expect(suggestion.fieldTab2, equals('New Tab 2'));
      expect(suggestion.fieldTab3, equals('New Tab 3'));
      expect(suggestion.creationDate, isNotNull);
      expect(suggestion.assignmentTime, isNotNull);
      expect(suggestion.dueTime, isNotNull);
      expect(suggestion.createdBy, equals('new-creator'));
      expect(suggestion.saveCount, equals(10.0));
      expect(suggestion.priority, equals(1.0));
    });

    timedTest('should handle null values correctly', () {
      final suggestion = Suggestion(
        id: null,
        name: null,
        assignee: null,
        followers: null,
        status: null,
        active: null,
        icon: null,
        fieldTab1: null,
        fieldTab2: null,
        fieldTab3: null,
        creationDate: null,
        createdBy: null,
      );
      
      expect(suggestion.id, isNull);
      expect(suggestion.name, isNull);
      expect(suggestion.assignee, isNull);
      expect(suggestion.followers, isNull);
      expect(suggestion.status, isNull);
      expect(suggestion.active, isNull);
      expect(suggestion.icon, isNull);
      expect(suggestion.fieldTab1, isNull);
      expect(suggestion.fieldTab2, isNull);
      expect(suggestion.fieldTab3, isNull);
      expect(suggestion.creationDate, isNull);
      expect(suggestion.createdBy, isNull);
    });

    timedTest('should handle empty collections correctly', () {
      final suggestion = Suggestion(followers: []);
      
      expect(suggestion.followers, isEmpty);
      expect(suggestion.followers, isA<List<String>>());
    });

    timedTest('should handle complex followers list', () {
      final complexFollowers = [
        'user1@example.com',
        'user2@company.co.uk',
        'very-long-email-address@subdomain.domain.com',
        'user+tag@example.org',
        'user.name@example.net',
      ];
      
      final suggestion = Suggestion(followers: complexFollowers);
      
      expect(suggestion.followers, equals(complexFollowers));
      expect(suggestion.followers?.length, equals(5));
      expect(suggestion.followers?[0], equals('user1@example.com'));
      expect(suggestion.followers?[4], equals('user.name@example.net'));
    });

    timedTest('should handle various status values', () {
      final statusValues = ['draft', 'open', 'in-progress', 'completed', 'cancelled', 'archived'];
      
      for (final status in statusValues) {
        final suggestion = Suggestion(status: status);
        expect(suggestion.status, equals(status));
      }
    });

    timedTest('should handle boolean active field correctly', () {
      final activeSuggestion = Suggestion(active: true);
      final inactiveSuggestion = Suggestion(active: false);
      final undefinedSuggestion = Suggestion();
      
      expect(activeSuggestion.active, isTrue);
      expect(inactiveSuggestion.active, isFalse);
      expect(undefinedSuggestion.active, isNull);
    });

    timedTest('should handle numeric fields correctly', () {
      final suggestion = Suggestion(
        saveCount: 42.5,
        priority: 1.75,
      );
      
      expect(suggestion.saveCount, equals(42.5));
      expect(suggestion.priority, equals(1.75));
      expect(suggestion.saveCount, isA<double>());
      expect(suggestion.priority, isA<double>());
    });

    timedTest('should handle negative numeric values', () {
      final suggestion = Suggestion(
        saveCount: -5.0,
        priority: -1.0,
      );
      
      expect(suggestion.saveCount, equals(-5.0));
      expect(suggestion.priority, equals(-1.0));
    });

    timedTest('should handle zero numeric values', () {
      final suggestion = Suggestion(
        saveCount: 0.0,
        priority: 0.0,
      );
      
      expect(suggestion.saveCount, equals(0.0));
      expect(suggestion.priority, equals(0.0));
    });

    timedTest('should handle large numeric values', () {
      final suggestion = Suggestion(
        saveCount: 999999.99,
        priority: 100000.0,
      );
      
      expect(suggestion.saveCount, equals(999999.99));
      expect(suggestion.priority, equals(100000.0));
    });

    timedTest('should handle multiple timestamp fields', () {
      final creation = Timestamp.fromDate(DateTime(2023, 1, 1));
      final assignment = Timestamp.fromDate(DateTime(2023, 6, 15));
      final due = Timestamp.fromDate(DateTime(2023, 12, 31));
      
      final suggestion = Suggestion(creationDate: creation);
      suggestion.assignmentTime = assignment;
      suggestion.dueTime = due;
      
      expect(suggestion.creationDate, equals(creation));
      expect(suggestion.assignmentTime, equals(assignment));
      expect(suggestion.dueTime, equals(due));
    });

    timedTest('should handle special characters in string fields', () {
      final suggestion = Suggestion(
        name: 'Suggestion with émojis 🚀 and åccénts',
        assignee: 'user.name+tag@émàil.co.uk',
        status: 'in-progress-éñ',
        icon: 'icon_with_underscores',
        fieldTab1: 'Tab with "quotes" and \'apostrophes\'',
        fieldTab2: 'Tab with newlines\nand\ttabs',
        fieldTab3: 'Tab with special chars: @#\$%^&*()',
        createdBy: 'Ñame with ñ and café',
      );
      
      expect(suggestion.name, contains('🚀'));
      expect(suggestion.assignee, contains('émàil'));
      expect(suggestion.status, contains('éñ'));
      expect(suggestion.fieldTab1, contains('"quotes"'));
      expect(suggestion.fieldTab2, contains('\n'));
      expect(suggestion.fieldTab3, contains('@#\$%'));
      expect(suggestion.createdBy, contains('café'));
    });
  });
}