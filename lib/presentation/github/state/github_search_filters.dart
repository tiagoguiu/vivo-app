import '../../../exports.dart';

/// Presentation model for GitHub search filters.
@immutable
class GitHubSearchFilters {
  const GitHubSearchFilters({required this.username, this.location, this.language, this.minFollowers, this.minRepos});

  final String username;
  final String? location;
  final String? language;
  final int? minFollowers;
  final int? minRepos;

  bool get isValid => username.trim().isNotEmpty;

  GitHubSearchFilters copyWith({
    String? username,
    String? location,
    String? language,
    int? minFollowers,
    int? minRepos,
    bool clearLocation = false,
    bool clearLanguage = false,
    bool clearMinFollowers = false,
    bool clearMinRepos = false,
  }) => GitHubSearchFilters(
    username: username ?? this.username,
    location: clearLocation ? null : location ?? this.location,
    language: clearLanguage ? null : language ?? this.language,
    minFollowers: clearMinFollowers ? null : minFollowers ?? this.minFollowers,
    minRepos: clearMinRepos ? null : minRepos ?? this.minRepos,
  );

  GitHubSearchFiltersEntity toEntity() => GitHubSearchFiltersEntity(
    username: username,
    location: location,
    language: language,
    minFollowers: minFollowers,
    minRepos: minRepos,
  );

  String describe() {
    final parts = <String>[username.trim()];
    if (location != null && location!.trim().isNotEmpty) {
      parts.add('loc: ${location!.trim()}');
    }
    if (language != null && language!.trim().isNotEmpty) {
      parts.add('lang: ${language!.trim()}');
    }
    if (minFollowers != null) {
      parts.add('followers >= $minFollowers');
    }
    if (minRepos != null) {
      parts.add('repos >= $minRepos');
    }
    return parts.join(' | ');
  }
}

/// Notifier that owns GitHub search filter state.
class GitHubSearchFiltersNotifier extends Notifier<GitHubSearchFilters> {
  @override
  GitHubSearchFilters build() => const GitHubSearchFilters(username: '');

  void updateUsername(String value) => state = state.copyWith(username: value);

  void updateLocation(String value) =>
      state = value.trim().isEmpty ? state.copyWith(clearLocation: true) : state.copyWith(location: value);

  void updateLanguage(String value) =>
      state = value.trim().isEmpty ? state.copyWith(clearLanguage: true) : state.copyWith(language: value);

  void updateMinFollowers(String value) {
    final parsed = int.tryParse(value);
    state = parsed == null ? state.copyWith(clearMinFollowers: true) : state.copyWith(minFollowers: parsed);
  }

  void updateMinRepos(String value) {
    final parsed = int.tryParse(value);
    state = parsed == null ? state.copyWith(clearMinRepos: true) : state.copyWith(minRepos: parsed);
  }

  void applyHistory(GitHubSearchHistoryEntity history) {
    state = GitHubSearchFilters(
      username: history.filters.username,
      location: history.filters.location,
      language: history.filters.language,
      minFollowers: history.filters.minFollowers,
      minRepos: history.filters.minRepos,
    );
  }

  void reset() => state = const GitHubSearchFilters(username: '');
}

/// Provider for GitHub search filters.
final gitHubSearchFiltersProvider = NotifierProvider.autoDispose<GitHubSearchFiltersNotifier, GitHubSearchFilters>(
  GitHubSearchFiltersNotifier.new,
);
