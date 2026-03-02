import 'package:bootstrap/definitions/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Environment', () {
    group('enum values', () {
      test('has all expected environments', () {
        expect(Environment.values, hasLength(3));
        expect(Environment.values, contains(Environment.dev));
        expect(Environment.values, contains(Environment.stg));
        expect(Environment.values, contains(Environment.prod));
      });
    });

    group('fromString', () {
      test('creates dev environment from string', () {
        expect(Environment.fromString('dev'), Environment.dev);
        expect(Environment.fromString('Dev'), Environment.dev);
        expect(Environment.fromString('DEV'), Environment.dev);
      });

      test('creates stg environment from string', () {
        expect(Environment.fromString('stg'), Environment.stg);
        expect(Environment.fromString('Stg'), Environment.stg);
        expect(Environment.fromString('STG'), Environment.stg);
      });

      test('creates prod environment from string', () {
        expect(Environment.fromString('prod'), Environment.prod);
        expect(Environment.fromString('Prod'), Environment.prod);
        expect(Environment.fromString('PROD'), Environment.prod);
      });

      test('is case insensitive', () {
        expect(Environment.fromString('dev'), Environment.fromString('DEV'));
        expect(Environment.fromString('stg'), Environment.fromString('STG'));
        expect(Environment.fromString('prod'), Environment.fromString('PROD'));
      });

      test('throws StateError for invalid environment string', () {
        expect(
          () => Environment.fromString('invalid'),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError for empty string', () {
        expect(
          () => Environment.fromString(''),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('isDev', () {
      test('returns true for dev environment', () {
        expect(Environment.dev.isDev, isTrue);
      });

      test('returns false for non-dev environments', () {
        expect(Environment.stg.isDev, isFalse);
        expect(Environment.prod.isDev, isFalse);
      });
    });

    group('isStg', () {
      test('returns true for stg environment', () {
        expect(Environment.stg.isStg, isTrue);
      });

      test('returns false for non-stg environments', () {
        expect(Environment.dev.isStg, isFalse);
        expect(Environment.prod.isStg, isFalse);
      });
    });

    group('isProd', () {
      test('returns true for prod environment', () {
        expect(Environment.prod.isProd, isTrue);
      });

      test('returns false for non-prod environments', () {
        expect(Environment.dev.isProd, isFalse);
        expect(Environment.stg.isProd, isFalse);
      });
    });

    group('environment helpers exclusivity', () {
      test('only one environment helper returns true at a time', () {
        for (final env in Environment.values) {
          final helpers = [env.isDev, env.isStg, env.isProd];
          final trueCount = helpers.where((h) => h).length;
          expect(trueCount, 1, reason: 'Only one helper should be true');
        }
      });
    });

    group('name property', () {
      test('dev environment has correct name', () {
        expect(Environment.dev.name, 'dev');
      });

      test('stg environment has correct name', () {
        expect(Environment.stg.name, 'stg');
      });

      test('prod environment has correct name', () {
        expect(Environment.prod.name, 'prod');
      });
    });
  });
}
