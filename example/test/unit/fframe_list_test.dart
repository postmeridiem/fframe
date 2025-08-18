import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:fframe/fframe.dart';
import 'package:example/models/fframe_list.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('FframeList Model', () {
    timedTest('should create FframeList with all parameters', () {
      final timestamp = Timestamp.now();
      final options = ['option1', 'option2', 'option3'];
      
      final fframeList = FframeList(
        id: 'test-list-123',
        name: 'Test List',
        type: 'dropdown',
        options: options,
        icon: 'list',
        creationDate: timestamp,
        createdBy: 'test-user',
      );
      
      expect(fframeList.id, equals('test-list-123'));
      expect(fframeList.name, equals('Test List'));
      expect(fframeList.type, equals('dropdown'));
      expect(fframeList.options, equals(options));
      expect(fframeList.icon, equals('list'));
      expect(fframeList.creationDate, equals(timestamp));
      expect(fframeList.createdBy, equals('test-user'));
    });

    timedTest('should create FframeList with minimal parameters', () {
      final fframeList = FframeList();
      
      expect(fframeList.id, isNull);
      expect(fframeList.name, isNull);
      expect(fframeList.type, isNull);
      expect(fframeList.options, isNull);
      expect(fframeList.icon, isNull);
      expect(fframeList.creationDate, isNull);
      expect(fframeList.createdBy, isNull);
    });

    timedTest('should be a ChangeNotifier', () {
      final fframeList = FframeList();
      expect(fframeList, isA<ChangeNotifier>());
    });

    timedTest('should allow all mutable properties to be changed', () {
      final fframeList = FframeList(
        name: 'Initial List',
        type: 'checkbox',
        icon: 'initial_icon',
      );
      
      // Test mutability of all properties
      fframeList.id = 'updated-id';
      fframeList.name = 'Updated List';
      fframeList.type = 'radio';
      fframeList.options = ['new', 'options'];
      fframeList.icon = 'updated_icon';
      fframeList.creationDate = Timestamp.now();
      fframeList.createdBy = 'updated-user';
      
      expect(fframeList.id, equals('updated-id'));
      expect(fframeList.name, equals('Updated List'));
      expect(fframeList.type, equals('radio'));
      expect(fframeList.options, equals(['new', 'options']));
      expect(fframeList.icon, equals('updated_icon'));
      expect(fframeList.creationDate, isNotNull);
      expect(fframeList.createdBy, equals('updated-user'));
    });

    timedTest('should handle null values correctly', () {
      final fframeList = FframeList(
        id: null,
        name: null,
        type: null,
        options: null,
        icon: null,
        creationDate: null,
        createdBy: null,
      );
      
      expect(fframeList.id, isNull);
      expect(fframeList.name, isNull);
      expect(fframeList.type, isNull);
      expect(fframeList.options, isNull);
      expect(fframeList.icon, isNull);
      expect(fframeList.creationDate, isNull);
      expect(fframeList.createdBy, isNull);
    });

    timedTest('should handle empty string values', () {
      final fframeList = FframeList(
        id: '',
        name: '',
        type: '',
        icon: '',
        createdBy: '',
      );
      
      expect(fframeList.id, equals(''));
      expect(fframeList.name, equals(''));
      expect(fframeList.type, equals(''));
      expect(fframeList.icon, equals(''));
      expect(fframeList.createdBy, equals(''));
    });

    timedTest('should handle empty list options', () {
      final fframeList = FframeList(options: []);
      
      expect(fframeList.options, isEmpty);
      expect(fframeList.options, isA<List>());
    });

    timedTest('should handle string list options', () {
      final stringOptions = ['Option A', 'Option B', 'Option C'];
      final fframeList = FframeList(options: stringOptions);
      
      expect(fframeList.options, equals(stringOptions));
      expect(fframeList.options?.length, equals(3));
      expect(fframeList.options?[0], equals('Option A'));
      expect(fframeList.options?[2], equals('Option C'));
    });

    timedTest('should handle mixed type list options', () {
      final mixedOptions = ['String', 42, true, {'key': 'value'}, [1, 2, 3]];
      final fframeList = FframeList(options: mixedOptions);
      
      expect(fframeList.options, equals(mixedOptions));
      expect(fframeList.options?.length, equals(5));
      expect(fframeList.options?[0], isA<String>());
      expect(fframeList.options?[1], isA<int>());
      expect(fframeList.options?[2], isA<bool>());
      expect(fframeList.options?[3], isA<Map>());
      expect(fframeList.options?[4], isA<List>());
    });

    timedTest('should handle complex nested options', () {
      final complexOptions = [
        {'label': 'First Option', 'value': 1, 'enabled': true},
        {'label': 'Second Option', 'value': 2, 'enabled': false},
        {'label': 'Third Option', 'value': 3, 'enabled': true, 'metadata': {'priority': 'high'}},
      ];
      final fframeList = FframeList(options: complexOptions);
      
      expect(fframeList.options, equals(complexOptions));
      expect(fframeList.options?.length, equals(3));
      
      final firstOption = fframeList.options?[0] as Map;
      expect(firstOption['label'], equals('First Option'));
      expect(firstOption['value'], equals(1));
      expect(firstOption['enabled'], isTrue);
      
      final thirdOption = fframeList.options?[2] as Map;
      expect(thirdOption['metadata'], isA<Map>());
    });

    timedTest('should handle various list type values', () {
      final listTypes = ['dropdown', 'checkbox', 'radio', 'multiselect', 'autocomplete', 'tags'];
      
      for (final listType in listTypes) {
        final fframeList = FframeList(type: listType);
        expect(fframeList.type, equals(listType));
      }
    });

    timedTest('should handle various icon values', () {
      final iconValues = [
        'list',
        'check_box',
        'radio_button_checked',
        'arrow_drop_down',
        'settings',
        'favorite',
        'star',
      ];
      
      for (final iconValue in iconValues) {
        final fframeList = FframeList(icon: iconValue);
        expect(fframeList.icon, equals(iconValue));
      }
    });

    timedTest('should handle timestamp creation dates', () {
      final pastDate = Timestamp.fromDate(DateTime(2020, 1, 1));
      final currentDate = Timestamp.now();
      final futureDate = Timestamp.fromDate(DateTime(2030, 12, 31));
      
      final pastList = FframeList(creationDate: pastDate);
      final currentList = FframeList(creationDate: currentDate);
      final futureList = FframeList(creationDate: futureDate);
      
      expect(pastList.creationDate, equals(pastDate));
      expect(currentList.creationDate, equals(currentDate));
      expect(futureList.creationDate, equals(futureDate));
    });

    timedTest('should handle various createdBy user strings', () {
      final userNames = [
        'John Doe',
        'jane.smith@example.com',
        'user123',
        'Anonymous',
        'System Admin',
        'user-with-special_chars@domain.co.uk',
      ];
      
      for (final userName in userNames) {
        final fframeList = FframeList(createdBy: userName);
        expect(fframeList.createdBy, equals(userName));
      }
    });

    timedTest('should handle large options list', () {
      final largeOptions = List.generate(1000, (index) => 'Option $index');
      final fframeList = FframeList(options: largeOptions);
      
      expect(fframeList.options?.length, equals(1000));
      expect(fframeList.options?[0], equals('Option 0'));
      expect(fframeList.options?[999], equals('Option 999'));
      expect(fframeList.options?[500], equals('Option 500'));
    });

    timedTest('should handle special characters in string fields', () {
      final fframeList = FframeList(
        id: 'test-id-with-special-chars-123!@#',
        name: 'List with émojis 📋 and åccénts',
        type: 'dropdown-éñ',
        icon: 'icon_with_underscores',
        createdBy: 'Ñame with ñ and café',
      );
      
      expect(fframeList.id, equals('test-id-with-special-chars-123!@#'));
      expect(fframeList.name, contains('📋'));
      expect(fframeList.name, contains('åccénts'));
      expect(fframeList.type, contains('éñ'));
      expect(fframeList.icon, equals('icon_with_underscores'));
      expect(fframeList.createdBy, contains('café'));
    });

    timedTest('should handle options with special characters', () {
      final specialOptions = [
        'Option with émojis 🎯',
        'Option with åccénts',
        'Option with "quotes" and \'apostrophes\'',
        'Option with newlines\nand\ttabs',
        'Option with special chars: @#\$%^&*()',
      ];
      final fframeList = FframeList(options: specialOptions);
      
      expect(fframeList.options?[0], contains('🎯'));
      expect(fframeList.options?[1], contains('åccénts'));
      expect(fframeList.options?[2], contains('"quotes"'));
      expect(fframeList.options?[3], contains('\n'));
      expect(fframeList.options?[4], contains('@#\$%'));
    });

    timedTest('should handle deeply nested options structure', () {
      final deepOptions = [
        {
          'level1': {
            'level2': {
              'level3': {
                'level4': ['deep', 'nested', 'values']
              }
            }
          }
        }
      ];
      final fframeList = FframeList(options: deepOptions);
      
      expect(fframeList.options, equals(deepOptions));
      final level1 = (fframeList.options?[0] as Map)['level1'] as Map;
      final level2 = level1['level2'] as Map;
      final level3 = level2['level3'] as Map;
      final level4 = level3['level4'] as List;
      
      expect(level4, equals(['deep', 'nested', 'values']));
    });
  });
}