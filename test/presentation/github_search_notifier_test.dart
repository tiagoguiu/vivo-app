import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vivo_app/exports.dart';

import '../test_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(registerFallbackValues);

  group('GitHubSearchNotifier', () {
    late MockGitHubSearchUseCase useCase;
    late ProviderContainer container;

    setUp(() {
      useCase = MockGitHubSearchUseCase();
      container = ProviderContainer(overrides: [gitHubSearchUseCaseProvider.overrideWithValue(useCase)]);
    });

    tearDown(() {
      container.dispose();
    });

    test('search returns initial state when filters are invalid', () async {
      final notifier = container.read(gitHubSearchProvider.notifier);

      await notifier.search();

      final state = container.read(gitHubSearchProvider).asData?.value;
      expect(state, isNotNull);
      expect(state!.users, isEmpty);
      expect(state.page, 1);
    });

    test('search loads first page and sets hasMore', () async {
      when(
        () => useCase.searchUsers(any(), page: 1, perPage: 20, forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => List.generate(20, (i) => buildUserEntity(login: 'u$i')));

      container.read(gitHubSearchFiltersProvider.notifier).updateUsername('octo');
      final notifier = container.read(gitHubSearchProvider.notifier);

      await notifier.search();

      final state = container.read(gitHubSearchProvider).asData?.value;
      expect(state, isNotNull);
      expect(state!.users.length, 20);
      expect(state.hasMore, isTrue);
    });

    test('loadMore appends unique users and updates page', () async {
      when(
        () => useCase.searchUsers(any(), page: 1, perPage: 20, forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => List.generate(20, (i) => buildUserEntity(login: 'u$i')));

      when(
        () => useCase.searchUsers(any(), page: 2, perPage: 20, forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => [buildUserEntity(login: 'u19'), buildUserEntity(login: 'u20')]);

      container.read(gitHubSearchFiltersProvider.notifier).updateUsername('octo');
      final notifier = container.read(gitHubSearchProvider.notifier);

      await notifier.search();
      await notifier.loadMore();

      final state = container.read(gitHubSearchProvider).asData?.value;
      expect(state, isNotNull);
      expect(state!.users.length, 21);
      expect(state.page, 2);
      expect(state.hasMore, isFalse);
    });

    test('loadMore does nothing when hasMore is false', () async {
      when(
        () => useCase.searchUsers(any(), page: 1, perPage: 20, forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => [buildUserEntity(login: 'u1')]);

      container.read(gitHubSearchFiltersProvider.notifier).updateUsername('octo');
      final notifier = container.read(gitHubSearchProvider.notifier);

      await notifier.search();
      await notifier.loadMore();

      verifyNever(() => useCase.searchUsers(any(), page: 2, perPage: 20, forceRefresh: any(named: 'forceRefresh')));
    });
  });
}
