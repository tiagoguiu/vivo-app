import '../../exports.dart';

/// Contract for GitHub data access and caching.
abstract interface class GitHubRepository {
  /// Search GitHub users with caching support.
  Future<List<GitHubUserDataModel>> searchUsers(GitHubSearchQueryDataModel query, {bool forceRefresh = false});

  /// Load stored search history.
  Future<List<GitHubSearchHistoryDataModel>> getSearchHistory();

  /// Clear stored search history.
  Future<void> clearSearchHistory();

  /// Save a history entry for a user search.
  Future<void> saveSearchHistory(GitHubSearchQueryDataModel query);

  /// Get a GitHub user profile by login.
  Future<GitHubUserDataModel> getUser(String login);

  /// Get commit totals for recent repositories.
  Future<List<GitHubRepoCommitDataModel>> getRecentRepoCommits(String username, {int count = 5});
}
