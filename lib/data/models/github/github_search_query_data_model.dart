/// Data model that holds GitHub search filters.
class GitHubSearchQueryDataModel {
  const GitHubSearchQueryDataModel({
    required this.username,
    this.location,
    this.language,
    this.minFollowers,
    this.minRepos,
    this.page = 1,
    this.perPage = 10,
  });

  final String username;
  final String? location;
  final String? language;
  final int? minFollowers;
  final int? minRepos;
  final int page;
  final int perPage;

  String get cacheKey => [
    username.trim().toLowerCase(),
    location?.trim().toLowerCase() ?? '',
    language?.trim().toLowerCase() ?? '',
    minFollowers?.toString() ?? '',
    minRepos?.toString() ?? '',
    page.toString(),
    perPage.toString(),
  ].join('|');

  String toSearchQuery() {
    final terms = <String>[];
    final trimmedUsername = username.trim();
    if (trimmedUsername.isNotEmpty) {
      terms.add('$trimmedUsername in:login');
    }
    final trimmedLocation = location?.trim();
    if (trimmedLocation != null && trimmedLocation.isNotEmpty) {
      final safeLocation = trimmedLocation.replaceAll('"', '\\"');
      terms.add('location:"$safeLocation"');
    }
    final trimmedLanguage = language?.trim();
    if (trimmedLanguage != null && trimmedLanguage.isNotEmpty) {
      terms.add('language:$trimmedLanguage');
    }
    if (minFollowers != null && minFollowers! >= 0) {
      terms.add('followers:>=$minFollowers');
    }
    if (minRepos != null && minRepos! >= 0) {
      terms.add('repos:>=$minRepos');
    }
    return terms.join(' ');
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'location': location,
    'language': language,
    'minFollowers': minFollowers,
    'minRepos': minRepos,
    'page': page,
    'perPage': perPage,
  };

  factory GitHubSearchQueryDataModel.fromJson(Map<String, dynamic> json) => GitHubSearchQueryDataModel(
    username: json['username'] as String? ?? '',
    location: json['location'] as String?,
    language: json['language'] as String?,
    minFollowers: json['minFollowers'] as int?,
    minRepos: json['minRepos'] as int?,
    page: json['page'] as int? ?? 1,
    perPage: json['perPage'] as int? ?? 10,
  );
}
