import '../../../exports.dart';

/// Provider that fetches a GitHub user profile by login.
final gitHubUserDetailsProvider = FutureProvider.autoDispose.family<GitHubUserEntity, String>(
  (ref, login) => ref.read(gitHubSearchUseCaseProvider).getUser(login),
);
