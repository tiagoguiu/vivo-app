import '../../../exports.dart';

/// Provider for recent commit totals by GitHub user.
final gitHubCommitsProvider = FutureProvider.autoDispose.family<List<GitHubRepoCommitEntity>, String>(
  (ref, username) => ref.read(gitHubSearchUseCaseProvider).getRecentRepoCommits(username),
);
