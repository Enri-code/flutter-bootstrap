abstract class AppConfig {
  Environment get env;
}

enum Environment {
  dev,
  stg,
  prod;

  factory Environment.fromString(String value) {
    return Environment.values.firstWhere((e) => e.name == value.toLowerCase());
  }

  bool get isDev => this == dev;
  bool get isStg => this == stg;
  bool get isProd => this == prod;
}
