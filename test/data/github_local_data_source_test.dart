import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivo_app/exports.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  group('GitHubLocalDataSource', () {
    test('returns null when cache is missing', () async {
      final dataSource = GitHubLocalDataSource();

      final cache = await dataSource.getCache('missing');

      expect(cache, isNull);
    });

    test('saves and loads cache when not expired', () async {
      final dataSource = GitHubLocalDataSource();
      final cache = GitHubSearchCacheDataModel(
        cacheKey: 'k1',
        cachedAt: DateTime.now().subtract(const Duration(hours: 1)),
        users: [
          GitHubUserDataModel(
            login: 'octo',
            name: 'Octo',
            avatarUrl: 'https://example.com/a.png',
            htmlUrl: 'https://github.com/octo',
            bio: 'Bio',
            location: 'Nowhere',
            followers: 1,
            publicRepos: 1,
          ),
        ],
      );

      await dataSource.saveCache(cache);
      final loaded = await dataSource.getCache('k1');

      expect(loaded, isNotNull);
      expect(loaded!.users.first.login, 'octo');
    });

    test('expired cache is removed', () async {
      final dataSource = GitHubLocalDataSource(ttl: const Duration(hours: 1));
      final cache = GitHubSearchCacheDataModel(
        cacheKey: 'k2',
        cachedAt: DateTime.now().subtract(const Duration(hours: 2)),
        users: const [],
      );

      await dataSource.saveCache(cache);
      final loaded = await dataSource.getCache('k2');

      expect(loaded, isNull);

      final raw = LocalStorageService.getString(LocalStorageConstants.githubSearchCache);
      expect(raw, isNotNull);
      final decoded = jsonDecode(raw!) as Map<String, dynamic>;
      expect(decoded.containsKey('k2'), isFalse);
    });

    test('saves history with de-duplication by unique key', () async {
      final dataSource = GitHubLocalDataSource();
      final query = GitHubSearchQueryDataModel(username: 'octo');

      await dataSource.saveHistory(
        GitHubSearchHistoryDataModel(type: GitHubHistoryType.search, query: query, searchedAt: DateTime(2024, 1, 1)),
      );
      await dataSource.saveHistory(
        GitHubSearchHistoryDataModel(type: GitHubHistoryType.search, query: query, searchedAt: DateTime(2024, 1, 2)),
      );

      final history = await dataSource.getHistory();
      expect(history.length, 1);
      expect(history.first.searchedAt, DateTime(2024, 1, 2));
    });

    test('keeps only the 20 most recent history entries', () async {
      final dataSource = GitHubLocalDataSource();

      for (var i = 0; i < 22; i += 1) {
        await dataSource.saveHistory(
          GitHubSearchHistoryDataModel(
            type: GitHubHistoryType.profile,
            profileLogin: 'user$i',
            searchedAt: DateTime(2024, 1, 1).add(Duration(minutes: i)),
          ),
        );
      }

      final history = await dataSource.getHistory();
      expect(history.length, 20);
      expect(history.first.profileLogin, 'user21');
    });

    test('clears history', () async {
      final dataSource = GitHubLocalDataSource();
      await dataSource.saveHistory(
        GitHubSearchHistoryDataModel(
          type: GitHubHistoryType.search,
          query: GitHubSearchQueryDataModel(username: 'octo'),
          searchedAt: DateTime(2024, 1, 1),
        ),
      );

      await dataSource.clearHistory();

      final history = await dataSource.getHistory();
      expect(history, isEmpty);
    });
  });
}
