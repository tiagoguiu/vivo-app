import '../../../exports.dart';

/// Notifier responsible for GitHub search history.
class GitHubHistoryNotifier extends AsyncNotifier<List<GitHubSearchHistoryEntity>> {
  @override
  Future<List<GitHubSearchHistoryEntity>> build() async => ref.read(gitHubSearchUseCaseProvider).getSearchHistory();

  Future<void> clearHistory() async {
    await ref.read(gitHubSearchUseCaseProvider).clearSearchHistory();
    state = const AsyncValue.data([]);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(gitHubSearchUseCaseProvider).getSearchHistory());
  }
}

/// Provider for GitHub search history.
final gitHubHistoryProvider = AsyncNotifierProvider.autoDispose<GitHubHistoryNotifier, List<GitHubSearchHistoryEntity>>(
  GitHubHistoryNotifier.new,
);
