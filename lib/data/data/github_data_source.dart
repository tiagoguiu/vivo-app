import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import '../../exports.dart';

/// Remote data source for GitHub REST API.
class GitHubRemoteDataSource {
  static const String _baseUrl = 'https://api.github.com';
  static const String _apiVersion = '2022-11-28';
  static const String _token = String.fromEnvironment('GITHUB_TOKEN');
  static const Map<String, String> _baseHeaders = {
    'Accept': 'application/vnd.github+json',
    'User-Agent': 'vivo-app',
    'X-GitHub-Api-Version': _apiVersion,
  };

  Map<String, String> get _headers {
    if (_token.isEmpty) {
      return _baseHeaders;
    }
    return {..._baseHeaders, 'Authorization': 'Bearer $_token'};
  }

  /// Search users through the GitHub search API.
  Future<List<GitHubUserDataModel>> searchUsers(GitHubSearchQueryDataModel query) async {
    final response = await ApiService.request<GitHubSearchResponseDataModel>(
      url: '$_baseUrl/search/users',
      method: HttpMethod.get,
      isAuthenticated: false,
      enqueueIfOffline: false,
      headers: _headers,
      queryParameters: {'q': query.toSearchQuery(), 'page': query.page, 'per_page': query.perPage},
      fromJson: (data) => GitHubSearchResponseDataModel.fromJson(data as Map<String, dynamic>),
    );

    final items = response.data?.items ?? [];
    final logins = items.map((item) => item.login).where((l) => l.isNotEmpty);
    final uniqueLogins = logins.toSet().toList();

    final futures = uniqueLogins.map(_fetchUser);
    return Future.wait(futures);
  }

  Future<GitHubUserDataModel> _fetchUser(String login) async {
    final response = await ApiService.request<GitHubUserDataModel>(
      url: '$_baseUrl/users/$login',
      method: HttpMethod.get,
      isAuthenticated: false,
      enqueueIfOffline: false,
      headers: _headers,
      fromJson: (data) => GitHubUserDataModel.fromJson(data as Map<String, dynamic>),
    );

    final user = response.data;
    if (user != null) {
      return user;
    }
    throw Exception('Falha ao buscar usuario do GitHub.');
  }

  /// Fetch a GitHub user profile by login.
  Future<GitHubUserDataModel> fetchUser(String login) => _fetchUser(login);

  /// Fetch most recently updated repositories for a user.
  Future<List<GitHubRepoDataModel>> fetchRecentRepos(String username, {int count = 12}) async {
    final response = await ApiService.request<List<GitHubRepoDataModel>>(
      url: '$_baseUrl/users/$username/repos',
      method: HttpMethod.get,
      isAuthenticated: false,
      enqueueIfOffline: false,
      headers: _headers,
      queryParameters: {'per_page': count, 'sort': 'updated'},
      fromJson: (data) => (data as List).whereType<Map<String, dynamic>>().map(GitHubRepoDataModel.fromJson).toList(),
    );

    return response.data ?? [];
  }

  /// Fetch commit activity totals for a repository (last 52 weeks).
  Future<int> fetchCommitActivity({required String owner, required String repo}) async {
    const maxAttempts = 3;
    var attempt = 0;
    while (attempt < maxAttempts) {
      attempt += 1;
      final response = await ApiService.request<List<dynamic>>(
        url: '$_baseUrl/repos/$owner/$repo/stats/commit_activity',
        method: HttpMethod.get,
        isAuthenticated: false,
        enqueueIfOffline: false,
        headers: _headers,
        fromJson: (data) => data as List<dynamic>,
      );

      final status = response.statusCode ?? 0;
      final raw = response.data;

      if (status == 202 || raw == null || raw.isEmpty) {
        if (attempt < maxAttempts) {
          await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
          continue;
        }
        developer.log(
          'Commit activity unavailable',
          name: 'github.search',
          error: {'owner': owner, 'repo': repo, 'status': status},
        );
        return 0;
      }

      if (status == 204 || status == 422) {
        return 0;
      }

      var total = 0;
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          total += item['total'] as int? ?? 0;
        }
      }
      return total;
    }

    return 0;
  }
}

/// Local data source for GitHub cache and history.
class GitHubLocalDataSource {
  GitHubLocalDataSource({this.ttl = const Duration(hours: 24)});

  final Duration ttl;

  /// Load a cached entry if it is still valid.
  Future<GitHubSearchCacheDataModel?> getCache(String cacheKey) async {
    final raw = LocalStorageService.getString(LocalStorageConstants.githubSearchCache);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final entry = decoded[cacheKey] as Map<String, dynamic>?;
    if (entry == null) {
      return null;
    }
    final cache = GitHubSearchCacheDataModel.fromJson(entry);
    if (cache.isExpired(ttl)) {
      await removeCache(cacheKey);
      return null;
    }
    return cache;
  }

  /// Persist a cache entry.
  Future<void> saveCache(GitHubSearchCacheDataModel cache) async {
    final raw = LocalStorageService.getString(LocalStorageConstants.githubSearchCache);
    final decoded = raw == null || raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;

    decoded[cache.cacheKey] = cache.toJson();
    await LocalStorageService.setString(LocalStorageConstants.githubSearchCache, jsonEncode(decoded));
  }

  /// Remove a cache entry by key.
  Future<void> removeCache(String cacheKey) async {
    final raw = LocalStorageService.getString(LocalStorageConstants.githubSearchCache);
    if (raw == null || raw.isEmpty) {
      return;
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    decoded.remove(cacheKey);
    await LocalStorageService.setString(LocalStorageConstants.githubSearchCache, jsonEncode(decoded));
  }

  /// Load stored search history.
  Future<List<GitHubSearchHistoryDataModel>> getHistory() async {
    final raw = LocalStorageService.getString(LocalStorageConstants.githubSearchHistory);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.whereType<Map<String, dynamic>>().map(GitHubSearchHistoryDataModel.fromJson).toList();
  }

  /// Persist a history entry and keep recent items.
  Future<void> saveHistory(GitHubSearchHistoryDataModel history) async {
    final current = await getHistory();
    final filtered = current.where((item) => item.query.cacheKey != history.query.cacheKey).toList();
    filtered.insert(0, history);
    if (filtered.length > 20) {
      filtered.removeRange(20, filtered.length);
    }

    await LocalStorageService.setString(
      LocalStorageConstants.githubSearchHistory,
      jsonEncode(filtered.map((item) => item.toJson()).toList()),
    );
  }

  /// Clear all stored history.
  Future<void> clearHistory() async {
    await LocalStorageService.remove(LocalStorageConstants.githubSearchHistory);
  }
}

/// Provider for the GitHub remote data source.
final gitHubRemoteDataSourceProvider = Provider<GitHubRemoteDataSource>((ref) => GitHubRemoteDataSource());

/// Provider for the GitHub local data source.
final gitHubLocalDataSourceProvider = Provider<GitHubLocalDataSource>((ref) => GitHubLocalDataSource());
