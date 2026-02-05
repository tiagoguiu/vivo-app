import 'github_user_data_model.dart';

/// Cached GitHub search entry with timestamp.
class GitHubSearchCacheDataModel {
  const GitHubSearchCacheDataModel({required this.cacheKey, required this.cachedAt, required this.users});

  final String cacheKey;
  final DateTime cachedAt;
  final List<GitHubUserDataModel> users;

  bool isExpired(Duration ttl) => DateTime.now().difference(cachedAt) > ttl;

  Map<String, dynamic> toJson() => {
    'cacheKey': cacheKey,
    'cachedAt': cachedAt.toIso8601String(),
    'users': users.map((user) => user.toJson()).toList(),
  };

  factory GitHubSearchCacheDataModel.fromJson(Map<String, dynamic> json) => GitHubSearchCacheDataModel(
    cacheKey: json['cacheKey'] as String? ?? '',
    cachedAt: DateTime.tryParse(json['cachedAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
    users: (json['users'] as List? ?? []).whereType<Map<String, dynamic>>().map(GitHubUserDataModel.fromJson).toList(),
  );
}
