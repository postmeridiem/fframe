import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:fframe/fframe.dart';
import 'package:example/models/fframe_page.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);

  timedGroup('FframePage Model', () {
    timedTest('should create FframePage with all parameters', () {
      final timestamp = Timestamp.now();

      final fframePage = FframePage(
        id: 'test-page-123',
        active: true,
        public: false,
        name: 'Test Page',
        body: 'This is the page body content with HTML tags',
        icon: 'page',
        creationDate: timestamp,
        createdBy: 'test-user',
        saveCount: 5.0,
      );

      expect(fframePage.id, equals('test-page-123'));
      expect(fframePage.active, isTrue);
      expect(fframePage.public, isFalse);
      expect(fframePage.name, equals('Test Page'));
      expect(fframePage.body, equals('This is the page body content with HTML tags'));
      expect(fframePage.icon, equals('page'));
      expect(fframePage.creationDate, equals(timestamp));
      expect(fframePage.createdBy, equals('test-user'));
      expect(fframePage.saveCount, equals(5.0));
    });

    timedTest('should create FframePage with minimal parameters and defaults', () {
      final fframePage = FframePage();

      expect(fframePage.id, isNull);
      expect(fframePage.active, isNull);
      expect(fframePage.public, isNull);
      expect(fframePage.name, isNull);
      expect(fframePage.body, isNull);
      expect(fframePage.icon, isNull);
      expect(fframePage.creationDate, isNull);
      expect(fframePage.createdBy, isNull);
      expect(fframePage.saveCount, equals(0)); // Default value
    });

    timedTest('should use correct default value for saveCount', () {
      final fframePage1 = FframePage();
      final fframePage2 = FframePage(saveCount: 10.0);

      // Test default
      expect(fframePage1.saveCount, equals(0));

      // Test override default
      expect(fframePage2.saveCount, equals(10.0));
    });

    timedTest('should be a ChangeNotifier', () {
      final fframePage = FframePage();
      expect(fframePage, isA<ChangeNotifier>());
    });

    timedTest('should allow all mutable properties to be changed', () {
      final fframePage = FframePage(
        name: 'Initial Page',
        active: true,
        public: false,
        saveCount: 1.0,
      );

      // Test mutability of all properties
      fframePage.id = 'updated-id';
      fframePage.active = false;
      fframePage.public = true;
      fframePage.name = 'Updated Page';
      fframePage.body = 'Updated body content';
      fframePage.icon = 'updated_icon';
      fframePage.creationDate = Timestamp.now();
      fframePage.createdBy = 'updated-user';
      fframePage.saveCount = 10.0;

      expect(fframePage.id, equals('updated-id'));
      expect(fframePage.active, isFalse);
      expect(fframePage.public, isTrue);
      expect(fframePage.name, equals('Updated Page'));
      expect(fframePage.body, equals('Updated body content'));
      expect(fframePage.icon, equals('updated_icon'));
      expect(fframePage.creationDate, isNotNull);
      expect(fframePage.createdBy, equals('updated-user'));
      expect(fframePage.saveCount, equals(10.0));
    });

    timedTest('should handle null values correctly', () {
      final fframePage = FframePage(
        id: null,
        active: null,
        public: null,
        name: null,
        body: null,
        icon: null,
        creationDate: null,
        createdBy: null,
      );

      expect(fframePage.id, isNull);
      expect(fframePage.active, isNull);
      expect(fframePage.public, isNull);
      expect(fframePage.name, isNull);
      expect(fframePage.body, isNull);
      expect(fframePage.icon, isNull);
      expect(fframePage.creationDate, isNull);
      expect(fframePage.createdBy, isNull);
    });

    timedTest('should handle empty string values', () {
      final fframePage = FframePage(
        id: '',
        name: '',
        body: '',
        icon: '',
        createdBy: '',
      );

      expect(fframePage.id, equals(''));
      expect(fframePage.name, equals(''));
      expect(fframePage.body, equals(''));
      expect(fframePage.icon, equals(''));
      expect(fframePage.createdBy, equals(''));
    });

    timedTest('should handle boolean active field correctly', () {
      final activePage = FframePage(active: true);
      final inactivePage = FframePage(active: false);
      final undefinedPage = FframePage();

      expect(activePage.active, isTrue);
      expect(inactivePage.active, isFalse);
      expect(undefinedPage.active, isNull);
    });

    timedTest('should handle boolean public field correctly', () {
      final publicPage = FframePage(public: true);
      final privatePage = FframePage(public: false);
      final undefinedPage = FframePage();

      expect(publicPage.public, isTrue);
      expect(privatePage.public, isFalse);
      expect(undefinedPage.public, isNull);
    });

    timedTest('should handle both boolean fields together', () {
      const combinations = [
        [true, true], // active: true, public: true
        [true, false], // active: true, public: false
        [false, true], // active: false, public: true
        [false, false], // active: false, public: false
      ];

      for (final combo in combinations) {
        final fframePage = FframePage(active: combo[0], public: combo[1]);
        expect(fframePage.active, equals(combo[0]));
        expect(fframePage.public, equals(combo[1]));
      }
    });

    timedTest('should handle numeric saveCount field correctly', () {
      const testValues = [0.0, 1.0, 42.5, 999.99, -5.0, 0.001, 1000000.0];

      for (final value in testValues) {
        final fframePage = FframePage(saveCount: value);
        expect(fframePage.saveCount, equals(value));
        expect(fframePage.saveCount, isA<double>());
      }
    });

    timedTest('should handle large body content', () {
      final largeBody = '''
        <html>
          <head><title>Large Page Content</title></head>
          <body>
            <h1>Large Content Test</h1>
            <p>This is a very large body content that might be used in some real-world scenarios. ''' *
              100 +
          '''
            </p>
            <div>More content here...</div>
          </body>
        </html>
      ''';

      final fframePage = FframePage(body: largeBody);

      expect(fframePage.body, equals(largeBody));
      expect(fframePage.body!.length, greaterThan(10000));
      expect(fframePage.body, contains('<html>'));
      expect(fframePage.body, contains('Large Content Test'));
    });

    timedTest('should handle HTML content in body', () {
      const htmlBody = '''
        <div class="container">
          <h1>Page Title</h1>
          <p>Paragraph with <strong>bold</strong> and <em>italic</em> text.</p>
          <ul>
            <li>List item 1</li>
            <li>List item 2</li>
          </ul>
          <a href="https://example.com">External link</a>
          <img src="/images/test.jpg" alt="Test image" />
        </div>
      ''';

      final fframePage = FframePage(body: htmlBody);

      expect(fframePage.body, contains('<div class="container">'));
      expect(fframePage.body, contains('<strong>bold</strong>'));
      expect(fframePage.body, contains('<a href="https://example.com">'));
      expect(fframePage.body, contains('<img src="/images/test.jpg"'));
    });

    timedTest('should handle various icon values', () {
      const iconValues = [
        'page',
        'article',
        'description',
        'document',
        'file_present',
        'note',
        'text_snippet',
      ];

      for (final iconValue in iconValues) {
        final fframePage = FframePage(icon: iconValue);
        expect(fframePage.icon, equals(iconValue));
      }
    });

    timedTest('should handle timestamp creation dates', () {
      final pastDate = Timestamp.fromDate(DateTime(2020, 1, 1));
      final currentDate = Timestamp.now();
      final futureDate = Timestamp.fromDate(DateTime(2030, 12, 31));

      final pastPage = FframePage(creationDate: pastDate);
      final currentPage = FframePage(creationDate: currentDate);
      final futurePage = FframePage(creationDate: futureDate);

      expect(pastPage.creationDate, equals(pastDate));
      expect(currentPage.creationDate, equals(currentDate));
      expect(futurePage.creationDate, equals(futureDate));
    });

    timedTest('should handle various createdBy user strings', () {
      const userNames = [
        'John Doe',
        'jane.smith@example.com',
        'content-creator-123',
        'Anonymous',
        'System Admin',
        'user-with-special_chars@domain.co.uk',
      ];

      for (final userName in userNames) {
        final fframePage = FframePage(createdBy: userName);
        expect(fframePage.createdBy, equals(userName));
      }
    });

    timedTest('should handle special characters in string fields', () {
      final fframePage = FframePage(
        id: 'test-page-with-special-chars-123!@#',
        name: 'Page with émojis 📄 and åccénts',
        body: '''
          <h1>Special content with émojis 🚀</h1>
          <p>Text with international characters: café, niño, Москва</p>
          <div>Content with "quotes" and 'apostrophes'</div>
        ''',
        icon: 'icon_with_underscores',
        createdBy: 'Ñame with ñ and café',
      );

      expect(fframePage.id, equals('test-page-with-special-chars-123!@#'));
      expect(fframePage.name, contains('📄'));
      expect(fframePage.name, contains('åccénts'));
      expect(fframePage.body, contains('🚀'));
      expect(fframePage.body, contains('café'));
      expect(fframePage.body, contains('Москва'));
      expect(fframePage.body, contains('"quotes"'));
      expect(fframePage.icon, equals('icon_with_underscores'));
      expect(fframePage.createdBy, contains('café'));
    });

    timedTest('should handle markdown content in body', () {
      const markdownBody = '''
        # Main Title
        
        ## Subtitle
        
        This is a paragraph with **bold text** and *italic text*.
        
        ### List Example
        
        - Item 1
        - Item 2
        - Item 3
        
        ### Code Example
        
        ```dart
        void main() {
          print('Hello World!');
        }
        ```
        
        [Link to example](https://example.com)
      ''';

      final fframePage = FframePage(body: markdownBody);

      expect(fframePage.body, contains('# Main Title'));
      expect(fframePage.body, contains('**bold text**'));
      expect(fframePage.body, contains('```dart'));
      expect(fframePage.body, contains('[Link to example]'));
    });

    timedTest('should handle body with newlines and whitespace', () {
      const bodyWithWhitespace = '''
        
        
        Content with multiple newlines
        
        
        And   multiple   spaces   between   words
        
        	And tabs between content
        
        
      ''';

      final fframePage = FframePage(body: bodyWithWhitespace);

      expect(fframePage.body, contains('multiple newlines'));
      expect(fframePage.body, contains('   '));
      expect(fframePage.body, contains('\t'));
      expect(fframePage.body, contains('multiple newlines'));
    });
  });
}
