import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vivo_app/exports.dart';

import '../test_mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('GitHubRepository', () {
    late MockGitHubRemoteDataSource remote;
    late MockGitHubLocalDataSource local;
    late GitHubRepository repository;

    setUp(() {
      remote = MockGitHubRemoteDataSource();
      local = MockGitHubLocalDataSource();
      repository = GitHubRepositoryImpl(remoteDataSource: remote, localDataSource: local);
    });

    test('returns cached users and saves history for first page', () async {
      final query = buildQuery(page: 1);
      final cache = GitHubSearchCacheDataModel(
        cacheKey: query.cacheKey,
        cachedAt: DateTime.now(),
        users: [buildUserData(login: 'cached')],
      );

      when(() => local.getCache(query.cacheKey)).thenAnswer((_) async => cache);
      when(() => local.saveHistory(any())).thenAnswer((_) async {});

      final results = await repository.searchUsers(query);

      expect(results.first.login, 'cached');
      verify(() => local.saveHistory(any())).called(1);
      verifyNever(() => remote.searchUsers(any()));
    });

    test('fetches remote users and saves cache/history when cache missing', () async {
      final query = buildQuery(page: 1);
      when(() => local.getCache(query.cacheKey)).thenAnswer((_) async => null);
      when(() => remote.searchUsers(query)).thenAnswer((_) async => [buildUserData(login: 'remote')]);
      when(() => local.saveCache(any())).thenAnswer((_) async {});
      when(() => local.saveHistory(any())).thenAnswer((_) async {});

      final results = await repository.searchUsers(query);

      expect(results.first.login, 'remote');
      verify(() => local.saveCache(any())).called(1);
      verify(() => local.saveHistory(any())).called(1);
    });

    test('does not save history for non-first pages', () async {
      final query = buildQuery(page: 2);
      when(() => local.getCache(query.cacheKey)).thenAnswer((_) async => null);
      when(() => remote.searchUsers(query)).thenAnswer((_) async => [buildUserData(login: 'remote')]);
      when(() => local.saveCache(any())).thenAnswer((_) async {});

      await repository.searchUsers(query);

      verifyNever(() => local.saveHistory(any()));
    });

    test('saves profile history', () async {
      when(() => local.saveHistory(any())).thenAnswer((_) async {});

      await repository.saveProfileHistory('octo', name: 'Octo');

      final captured = verify(() => local.saveHistory(captureAny())).captured.single as GitHubSearchHistoryDataModel;
      expect(captured.type, GitHubHistoryType.profile);
      expect(captured.profileLogin, 'octo');
      expect(captured.profileName, 'Octo');
    });

    test('loads recent repo commits in parallel order', () async {
      when(() => remote.fetchRecentRepos('octo', count: 12)).thenAnswer(
        (_) async => [
          const GitHubRepoDataModel(name: 'r1', fullName: 'octo/r1', ownerLogin: 'octo'),
          const GitHubRepoDataModel(name: 'r2', fullName: 'octo/r2', ownerLogin: 'octo'),
        ],
      );
      when(() => remote.fetchCommitActivity(owner: 'octo', repo: 'r1')).thenAnswer((_) async => 3);
      when(() => remote.fetchCommitActivity(owner: 'octo', repo: 'r2')).thenAnswer((_) async => 5);

      final results = await repository.getRecentRepoCommits('octo', count: 12);

      expect(results.map((e) => e.repoName).toList(), ['r1', 'r2']);
      expect(results.map((e) => e.commitCount).toList(), [3, 5]);
    });
  });
}
