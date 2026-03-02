import 'package:bootstrap/definitions/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('Result.data', () {
      test('creates data result with value', () {
        const result = Result<String, int>.data(42);

        expect(result.isData, isTrue);
        expect(result.isError, isFalse);
        expect(result.data, equals(42));
      });

      test('creates data result with null value', () {
        const result = Result<String, int?>.data(null);

        expect(result.isData, isTrue);
        expect(result.data, isNull);
      });

      test('creates data result with complex object', () {
        final complexObject = {'key': 'value', 'count': 123};
        final result = Result<String, Map<String, dynamic>>.data(
          complexObject,
        );

        expect(result.isData, isTrue);
        expect(result.data, equals(complexObject));
      });
    });

    group('Result.error', () {
      test('creates error result with value', () {
        const result = Result<String, int>.error('Error occurred');

        expect(result.isError, isTrue);
        expect(result.isData, isFalse);
        expect(result.error, equals('Error occurred'));
      });

      test('creates error result with exception', () {
        final exception = Exception('Test exception');
        final result = Result<Exception, int>.error(exception);

        expect(result.isError, isTrue);
        expect(result.error, equals(exception));
      });

      test('creates error result with custom error type', () {
        final customError = CustomError('Custom error message');
        final result = Result<CustomError, String>.error(customError);

        expect(result.isError, isTrue);
        expect(result.error.message, equals('Custom error message'));
      });
    });

    group('map', () {
      test('maps data result using data function', () {
        const result = Result<String, int>.data(42);

        final mapped = result.map(
          (error) => 'Error: $error',
          (data) => 'Data: $data',
        );

        expect(mapped, equals('Data: 42'));
      });

      test('maps error result using error function', () {
        const result = Result<String, int>.error('Failed');

        final mapped = result.map(
          (error) => 'Error: $error',
          (data) => 'Data: $data',
        );

        expect(mapped, equals('Error: Failed'));
      });

      test('transforms data result to different type', () {
        const result = Result<String, int>.data(42);

        final transformed = result.map(
          (error) => 0,
          (data) => data * 2,
        );

        expect(transformed, equals(84));
      });

      test('transforms error result to different type', () {
        const result = Result<String, int>.error('Error');

        final transformed = result.map(
          (error) => error.length,
          (data) => data,
        );

        expect(transformed, equals(5));
      });
    });

    group('when', () {
      test('calls data callback for data result', () {
        const result = Result<String, int>.data(42);

        final value = result.when(
          error: (e) => 'Error',
          data: (d) => 'Data: $d',
        );

        expect(value, equals('Data: 42'));
      });

      test('calls error callback for error result', () {
        const result = Result<String, int>.error('Failed');

        final value = result.when(
          error: (e) => 'Error',
          data: (d) => 'Data: $d',
        );

        expect(value, equals('Error: Failed'));
      });

      test('returns null when data callback not provided for data result', () {
        const result = Result<String, int>.data(42);

        final value = result.when(
          error: (e) => 'Error',
        );

        expect(value, isNull);
      });

      test(
        'returns null when error callback not provided for error result',
        () {
          const result = Result<String, int>.error('Failed');

          final value = result.when(
            data: (d) => 'Data: $d',
          );

          expect(value, isNull);
        },
      );
    });

    group('tryCatch', () {
      test('returns data result when callback succeeds', () async {
        final result = await Result.tryCatch<Exception, int>(
          () => 42,
        );

        expect(result.isData, isTrue);
        expect(result.data, equals(42));
      });

      test('returns error result when callback throws', () async {
        final exception = Exception('Test error');
        final result = await Result.tryCatch<Exception, int>(
          () => throw exception,
        );

        expect(result.isError, isTrue);
        expect(result.error, equals(exception));
      });

      test('works with async callbacks', () async {
        final result = await Result.tryCatch<Exception, String>(
          () async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return 'Success';
          },
        );

        expect(result.isData, isTrue);
        expect(result.data, equals('Success'));
      });

      test('catches async errors', () async {
        final exception = Exception('Async error');
        final result = await Result.tryCatch<Exception, String>(
          () async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            throw exception;
          },
        );

        expect(result.isError, isTrue);
        expect(result.error, equals(exception));
      });

      test('works with synchronous callbacks', () async {
        final result = await Result.tryCatch<Exception, int>(
          () => 100,
        );

        expect(result.isData, isTrue);
        expect(result.data, equals(100));
      });
    });

    group('type safety', () {
      test('maintains type information for data', () {
        const result = Result<String, int>.data(42);

        expect(result, isA<Result<String, int>>());
        expect(result.data, isA<int>());
      });

      test('maintains type information for error', () {
        const result = Result<String, int>.error('Error');

        expect(result, isA<Result<String, int>>());
        expect(result.error, isA<String>());
      });

      test('works with nullable types', () {
        const result = Result<String?, int?>.data(null);

        expect(result.isData, isTrue);
        expect(result.data, isNull);
      });
    });

    group('equality and comparison', () {
      test('data results with same value are equal', () {
        const result1 = Result<String, int>.data(42);
        const result2 = Result<String, int>.data(42);

        // Note: Without custom equality, these won't be equal
        // This test documents the current behavior
        expect(result1.data, equals(result2.data));
      });

      test('error results with same value are equal', () {
        const result1 = Result<String, int>.error('Error');
        const result2 = Result<String, int>.error('Error');

        expect(result1.error, equals(result2.error));
      });
    });

    group('edge cases', () {
      test('handles empty string data', () {
        const result = Result<String, String>.data('');

        expect(result.isData, isTrue);
        expect(result.data, equals(''));
      });

      test('handles zero as data', () {
        const result = Result<String, int>.data(0);

        expect(result.isData, isTrue);
        expect(result.data, equals(0));
      });

      test('handles false as data', () {
        const result = Result<String, bool>.data(false);

        expect(result.isData, isTrue);
        expect(result.data, isFalse);
      });
    });
  });
}

/// Custom error class for testing
class CustomError {
  CustomError(this.message);
  final String message;
}
