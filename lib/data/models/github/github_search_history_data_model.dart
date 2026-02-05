import 'github_search_query_data_model.dart';

enum GitHubHistoryType { search, profile }

/// Data model for GitHub search history entries.
class GitHubSearchHistoryDataModel {
  const GitHubSearchHistoryDataModel({
    required this.type,
    required this.searchedAt,
    this.query,
    this.profileLogin,
    this.profileName,
  });

  final GitHubHistoryType type;
  final GitHubSearchQueryDataModel? query;
  final String? profileLogin;
  final String? profileName;
  final DateTime searchedAt;

  String get uniqueKey {
    if (type == GitHubHistoryType.profile) {
      return 'profile:${profileLogin ?? ''}';
    }
    return query?.cacheKey ?? '';
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'query': query?.toJson(),
    'profileLogin': profileLogin,
    'profileName': profileName,
    'searchedAt': searchedAt.toIso8601String(),
  };

  factory GitHubSearchHistoryDataModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type'] as String?;
    final type = rawType == 'profile' ? GitHubHistoryType.profile : GitHubHistoryType.search;
    return GitHubSearchHistoryDataModel(
      type: type,
      query: json['query'] == null
          ? null
          : GitHubSearchQueryDataModel.fromJson(json['query'] as Map<String, dynamic>? ?? {}),
      profileLogin: json['profileLogin'] as String?,
      profileName: json['profileName'] as String?,
      searchedAt: DateTime.tryParse(json['searchedAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
