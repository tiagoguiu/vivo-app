import '../../exports.dart';

/// Repository that combines GitHub remote and local data sources.
class GitHubRepositoryImpl implements GitHubRepository {
  const GitHubRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  final GitHubRemoteDataSource remoteDataSource;
  final GitHubLocalDataSource localDataSource;

  @override
  Future<List<GitHubUserDataModel>> searchUsers(GitHubSearchQueryDataModel query, {bool forceRefresh = false}) async {
    final isFirstPage = query.page <= 1;
    if (!forceRefresh) {
      final cache = await localDataSource.getCache(query.cacheKey);
      if (cache != null) {
        if (isFirstPage) {
          await localDataSource.saveHistory(
            GitHubSearchHistoryDataModel(type: GitHubHistoryType.search, query: query, searchedAt: DateTime.now()),
          );
        }
        return cache.users;
      }
    }

    final users = await remoteDataSource.searchUsers(query);
    await localDataSource.saveCache(
      GitHubSearchCacheDataModel(cacheKey: query.cacheKey, cachedAt: DateTime.now(), users: users),
    );
    if (isFirstPage) {
      await localDataSource.saveHistory(
        GitHubSearchHistoryDataModel(type: GitHubHistoryType.search, query: query, searchedAt: DateTime.now()),
      );
    }
    return users;
  }

  @override
  Future<List<GitHubSearchHistoryDataModel>> getSearchHistory() => localDataSource.getHistory();

  @override
  Future<void> clearSearchHistory() => localDataSource.clearHistory();

  @override
  Future<void> saveProfileHistory(String login, {String? name}) async {
    await localDataSource.saveHistory(
      GitHubSearchHistoryDataModel(
        type: GitHubHistoryType.profile,
        profileLogin: login,
        profileName: name,
        searchedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<GitHubUserDataModel> getUser(String login) => remoteDataSource.fetchUser(login);

  @override
  Future<List<GitHubRepoCommitDataModel>> getRecentRepoCommits(String username, {int count = 12}) async {
    final repos = await remoteDataSource.fetchRecentRepos(username, count: count);

    final futures = repos.map((repo) async {
      final commits = await remoteDataSource.fetchCommitActivity(owner: repo.ownerLogin, repo: repo.name);
      return GitHubRepoCommitDataModel(repoName: repo.name, commitCount: commits);
    });

    return Future.wait(futures);
  }
}

/// Provider for the GitHub repository.
final gitHubRepositoryProvider = Provider<GitHubRepository>(
  (ref) => GitHubRepositoryImpl(
    remoteDataSource: ref.watch(gitHubRemoteDataSourceProvider),
    localDataSource: ref.watch(gitHubLocalDataSourceProvider),
  ),
);
