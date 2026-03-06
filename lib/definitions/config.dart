/// Base configuration interface for application environments.
/// Implement this interface to provide environment-specific configurations.
abstract class AppConfig {
  /// The current environment (dev, staging, production)
  Environment get env;
}

/// Application environment types
enum Environment {
  /// Development environment
  dev,

  /// Staging environment
  stg,

  /// Production environment
  prod;

  /// Creates an Environment from a string value.
  /// Throws [ArgumentError] if the value doesn't match any environment.
  factory Environment.fromString(String value) {
    final result = Environment.values.cast<Environment?>().firstWhere(
      (e) => e?.name == value.toLowerCase(),
      orElse: () => null,
    );

    if (result == null) {
      final validValues =
          Environment.values.map((e) => e.name).join(', ');
      throw ArgumentError(
        'Invalid environment: $value. Valid values are: $validValues',
      );
    }

    return result;
  }

  /// Safely creates an Environment from a string value.
  /// Returns null if the value doesn't match any environment.
  static Environment? tryFromString(String value) {
    return Environment.values.cast<Environment?>().firstWhere(
      (e) => e?.name == value.toLowerCase(),
      orElse: () => null,
    );
  }

  bool get isDev => this == dev;
  bool get isStg => this == stg;
  bool get isProd => this == prod;
}
