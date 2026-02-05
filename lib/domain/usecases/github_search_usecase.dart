import '../../exports.dart';

/// Use case for GitHub user search and history.
abstract interface class GitHubSearchUseCase {
  Future<List<GitHubUserEntity>> searchUsers(GitHubSearchFiltersEntity filters, {bool forceRefresh = false});

  Future<List<GitHubSearchHistoryEntity>> getSearchHistory();

  Future<void> clearSearchHistory();

  Future<List<GitHubRepoCommitEntity>> getRecentRepoCommits(String username, {int count = 5});
}

/// Default implementation for GitHub search use case.
class _GitHubSearchUseCase implements GitHubSearchUseCase {
  const _GitHubSearchUseCase(this._repository);

  final GitHubRepository _repository;

  @override
  Future<List<GitHubUserEntity>> searchUsers(GitHubSearchFiltersEntity filters, {bool forceRefresh = false}) async {
    final dataModel = filters.toDataModel();
    final results = await _repository.searchUsers(dataModel, forceRefresh: forceRefresh);
    return results.map(GitHubUserEntity.fromDataModel).toList();
  }

  @override
  Future<List<GitHubSearchHistoryEntity>> getSearchHistory() async {
    final history = await _repository.getSearchHistory();
    return history.map(GitHubSearchHistoryEntity.fromDataModel).toList();
  }

  @override
  Future<void> clearSearchHistory() => _repository.clearSearchHistory();

  @override
  Future<List<GitHubRepoCommitEntity>> getRecentRepoCommits(String username, {int count = 5}) async {
    final dataModels = await _repository.getRecentRepoCommits(username, count: count);
    return dataModels.map(GitHubRepoCommitEntity.fromDataModel).toList();
  }
}

/// Provider for the GitHub search use case.
final gitHubSearchUseCaseProvider = Provider<GitHubSearchUseCase>(
  (ref) => _GitHubSearchUseCase(ref.watch(gitHubRepositoryProvider)),
);
