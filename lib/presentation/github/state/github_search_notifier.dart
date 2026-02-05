import '../../../exports.dart';

@immutable
class GitHubSearchState {
  const GitHubSearchState({
    required this.users,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
  });

  final List<GitHubUserEntity> users;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const GitHubSearchState.initial() : users = const [], page = 1, hasMore = false, isLoadingMore = false;

  GitHubSearchState copyWith({List<GitHubUserEntity>? users, int? page, bool? hasMore, bool? isLoadingMore}) =>
      GitHubSearchState(
        users: users ?? this.users,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

/// Notifier responsible for executing GitHub searches.
class GitHubSearchNotifier extends AsyncNotifier<GitHubSearchState> {
  static const int _perPage = 20;

  @override
  Future<GitHubSearchState> build() async => const GitHubSearchState.initial();

  Future<void> search({bool forceRefresh = false}) async {
    final filters = ref.read(gitHubSearchFiltersProvider);
    if (!filters.isValid) {
      state = const AsyncValue.data(GitHubSearchState.initial());
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final results = await ref
          .read(gitHubSearchUseCaseProvider)
          .searchUsers(filters.toEntity(), page: 1, perPage: _perPage, forceRefresh: forceRefresh);
      return GitHubSearchState(users: results, page: 1, hasMore: results.length == _perPage, isLoadingMore: false);
    });

    ref.invalidate(gitHubHistoryProvider);
  }

  Future<void> loadMore() async {
    final filters = ref.read(gitHubSearchFiltersProvider);
    final current = state.asData?.value;
    if (current == null || current.isLoadingMore || !current.hasMore || !filters.isValid) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    final nextPage = current.page + 1;

    try {
      final results = await ref
          .read(gitHubSearchUseCaseProvider)
          .searchUsers(filters.toEntity(), page: nextPage, perPage: _perPage);

      final merged = <String, GitHubUserEntity>{
        for (final user in current.users) user.login: user,
        for (final user in results) user.login: user,
      }.values.toList();

      state = AsyncValue.data(
        current.copyWith(users: merged, page: nextPage, hasMore: results.length == _perPage, isLoadingMore: false),
      );
    } catch (_) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: false, hasMore: false));
    }
  }
}

/// Provider for GitHub search results.
final gitHubSearchProvider = AsyncNotifierProvider.autoDispose<GitHubSearchNotifier, GitHubSearchState>(
  GitHubSearchNotifier.new,
);
