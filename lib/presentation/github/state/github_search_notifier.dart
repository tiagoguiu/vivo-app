import '../../../exports.dart';

/// Notifier responsible for executing GitHub searches.
class GitHubSearchNotifier extends AsyncNotifier<List<GitHubUserEntity>> {
  @override
  Future<List<GitHubUserEntity>> build() async => [];

  Future<void> search({bool forceRefresh = false}) async {
    final filters = ref.read(gitHubSearchFiltersProvider);
    if (!filters.isValid) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gitHubSearchUseCaseProvider).searchUsers(filters.toEntity(), forceRefresh: forceRefresh),
    );

    ref.invalidate(gitHubHistoryProvider);
  }
}

/// Provider for GitHub search results.
final gitHubSearchProvider = AsyncNotifierProvider.autoDispose<GitHubSearchNotifier, List<GitHubUserEntity>>(
  GitHubSearchNotifier.new,
);
