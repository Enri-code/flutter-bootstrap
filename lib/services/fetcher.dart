// Function typedefs
// ----------------------------

import 'package:bootstrap/core.dart';

/// Function that reads data from local storage/cache.
typedef LocalRead<R> = Future<R?> Function();

/// Function that writes data to local storage/cache.
typedef LocalWrite<R> = Future<void> Function(R value);

/// Function that fetches data from a remote source.
typedef RemoteFetch<R> = Future<R> Function();

/// The source of fetched data.
enum DataSource {
  /// Data came from local cache/storage.
  local,

  /// Data came from remote API/server.
  remote
}

/// Response from a Fetcher operation including the data and its source.
class FetcherResponse<R> {
  const FetcherResponse(this.data, this.source);

  final R data;
  final DataSource source;
}

/// A utility for managing data fetching with local caching.
///
/// Provides multiple strategies for fetching data:
/// - Remote first with local fallback
/// - Local first with remote fallback
/// - Remote only
/// - Local only
/// - Local then remote (stream)
///
/// Example:
/// ```dart
/// final userFetcher = Fetcher<User>(
///   fetchRemote: () => api.getUser(),
///   readLocal: () => cache.getUser(),
///   writeLocal: (user) => cache.saveUser(user),
/// );
///
/// // Try remote first, fall back to cache if network fails
/// final response = await userFetcher.remoteOrLocal();
/// ```
class Fetcher<R> {
  /// Creates a Fetcher with remote and optional local storage.
  Fetcher({
    required RemoteFetch<R> fetchRemote,
    LocalRead<R?>? readLocal,
    LocalWrite<R>? writeLocal,
    Logger? log,
  })  : _readLocal = readLocal,
        _writeLocal = writeLocal,
        _fetchRemote = fetchRemote,
        _logger = log;

  final LocalRead<R>? _readLocal;
  final LocalWrite<R>? _writeLocal;
  final RemoteFetch<R> _fetchRemote;

  final Logger? _logger;

  Future<void> _writeToLocal(R data) async => await _writeLocal?.call(data);

  Future<FetcherResponse<R>> remoteOrLocal({
    bool writeLocal = true,
  }) async {
    // Remote first
    try {
      final data = await _fetchRemote();
      _logger?.debug('remote_success: $data');

      if (writeLocal) await _writeToLocal(data);
      return FetcherResponse<R>(data, DataSource.remote);
    } catch (e) {
      // Remote failed; try local fallback
      _logger?.warn('remote_failure: $e');
      final readLocal = _readLocal;
      if (readLocal != null) {
        final localRes = await readLocal();
        if (localRes != null) {
          _logger?.info('cache_hit_fallback');
          return FetcherResponse<R>(localRes, DataSource.local);
        }
      }

      // No fallback available - rethrow
      rethrow;
    }
  }

  Future<FetcherResponse<R>> localOrRemote({
    bool writeLocal = true,
  }) async {
    // Local first
    final readLocal = _readLocal;
    if (readLocal != null) {
      final localRes = await readLocal();
      if (localRes != null) {
        _logger?.info('cache_hit_immediate');
        return FetcherResponse<R>(localRes, DataSource.local);
      }
    }

    // Fetch remote data (may throw)
    final data = await _fetchRemote();
    _logger?.debug('remote_success: $data');

    if (writeLocal) await _writeToLocal(data);
    return FetcherResponse<R>(data, DataSource.remote);
  }

  Future<R> remote({bool writeLocal = true}) async {
    final data = await _fetchRemote();
    _logger?.debug('remote_success: $data');

    if (writeLocal) await _writeToLocal(data);
    return data;
  }

  Future<R?> local() async => _readLocal?.call();

  /// Returns local data immediately if available, then fetches remote data
  /// and returns it. This provides fast initial load with fresh data update.
  /// Throws errors from remote fetch.
  Stream<FetcherResponse<R>> localThenRemote({
    bool writeLocal = true,
  }) async* {
    // First, yield local data if available
    final readLocal = _readLocal;
    if (readLocal != null) {
      final localRes = await readLocal();
      if (localRes != null) {
        _logger?.info('cache_hit_immediate');
        yield FetcherResponse<R>(localRes, DataSource.local);
      }
    }

    // Then fetch remote data (may throw)
    final data = await _fetchRemote();
    _logger?.debug('remote_success: $data');

    if (writeLocal) await _writeToLocal(data);
    yield FetcherResponse<R>(data, DataSource.remote);
  }
}
