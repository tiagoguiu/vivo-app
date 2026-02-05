import 'package:mocktail/mocktail.dart';
import 'package:vivo_app/exports.dart';

class MockGitHubRemoteDataSource extends Mock implements GitHubRemoteDataSource {}

class MockGitHubLocalDataSource extends Mock implements GitHubLocalDataSource {}

class MockGitHubRepository extends Mock implements GitHubRepository {}

class MockGitHubSearchUseCase extends Mock implements GitHubSearchUseCase {}

GitHubUserDataModel buildUserData({String login = 'octocat', String? name = 'Octo Cat'}) {
  return GitHubUserDataModel(
    login: login,
    name: name,
    avatarUrl: 'https://example.com/avatar.png',
    htmlUrl: 'https://github.com/$login',
    bio: 'Bio',
    location: 'Nowhere',
    followers: 10,
    publicRepos: 2,
  );
}

GitHubUserEntity buildUserEntity({String login = 'octocat', String? name = 'Octo Cat'}) {
  return GitHubUserEntity(
    login: login,
    name: name,
    avatarUrl: 'https://example.com/avatar.png',
    profileUrl: '',
    bio: 'Bio',
    location: 'Nowhere',
    followers: 10,
    publicRepos: 2,
  );
}

GitHubSearchQueryDataModel buildQuery({String username = 'octocat', int page = 1, int perPage = 20}) {
  return GitHubSearchQueryDataModel(username: username, page: page, perPage: perPage);
}

GitHubSearchFiltersEntity buildFilters({String username = 'octocat'}) {
  return GitHubSearchFiltersEntity(username: username);
}

void registerFallbackValues() {
  registerFallbackValue(buildQuery());
  registerFallbackValue(
    GitHubSearchCacheDataModel(cacheKey: 'fallback', cachedAt: DateTime(2024, 1, 1), users: [buildUserData()]),
  );
  registerFallbackValue(
    GitHubSearchHistoryDataModel(type: GitHubHistoryType.search, query: buildQuery(), searchedAt: DateTime(2024, 1, 1)),
  );
  registerFallbackValue(buildUserData());
  registerFallbackValue(buildFilters());
}
