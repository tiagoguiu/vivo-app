import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vivo_app/exports.dart';

import '../test_mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('GitHubSearchUseCase', () {
    late MockGitHubRepository repository;
    late GitHubSearchUseCase useCase;

    setUp(() {
      repository = MockGitHubRepository();
      useCase = GitHubSearchUseCaseImpl(repository);
    });

    test('searchUsers maps filters to data model with pagination', () async {
      when(
        () => repository.searchUsers(any(), forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => [buildUserData(login: 'u1')]);

      final results = await useCase.searchUsers(buildFilters(username: 'u1'), page: 2, perPage: 30);

      expect(results.first.login, 'u1');

      final captured =
          verify(() => repository.searchUsers(captureAny(), forceRefresh: any(named: 'forceRefresh'))).captured.single
              as GitHubSearchQueryDataModel;
      expect(captured.page, 2);
      expect(captured.perPage, 30);
    });

    test('getSearchHistory maps data models to entities', () async {
      when(() => repository.getSearchHistory()).thenAnswer(
        (_) async => [
          GitHubSearchHistoryDataModel(
            type: GitHubHistoryType.search,
            query: buildQuery(username: 'octo'),
            searchedAt: DateTime(2024, 1, 1),
          ),
        ],
      );

      final results = await useCase.getSearchHistory();

      expect(results.first.filters?.username, 'octo');
    });

    test('saveProfileHistory delegates to repository', () async {
      when(() => repository.saveProfileHistory(any(), name: any(named: 'name'))).thenAnswer((_) async {});

      await useCase.saveProfileHistory('octo', name: 'Octo');

      verify(() => repository.saveProfileHistory('octo', name: 'Octo')).called(1);
    });

    test('getUser maps data model to entity', () async {
      when(() => repository.getUser('octo')).thenAnswer((_) async => buildUserData(login: 'octo'));

      final result = await useCase.getUser('octo');

      expect(result.login, 'octo');
    });

    test('getRecentRepoCommits maps data models to entities', () async {
      when(
        () => repository.getRecentRepoCommits('octo', count: 12),
      ).thenAnswer((_) async => [const GitHubRepoCommitDataModel(repoName: 'r1', commitCount: 2)]);

      final results = await useCase.getRecentRepoCommits('octo', count: 12);

      expect(results.first.repoName, 'r1');
      expect(results.first.commitCount, 2);
    });
  });
}
