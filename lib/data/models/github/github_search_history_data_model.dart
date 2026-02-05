import 'github_search_query_data_model.dart';

/// Data model for GitHub search history entries.
class GitHubSearchHistoryDataModel {
  const GitHubSearchHistoryDataModel({required this.query, required this.searchedAt});

  final GitHubSearchQueryDataModel query;
  final DateTime searchedAt;

  Map<String, dynamic> toJson() => {'query': query.toJson(), 'searchedAt': searchedAt.toIso8601String()};

  factory GitHubSearchHistoryDataModel.fromJson(Map<String, dynamic> json) => GitHubSearchHistoryDataModel(
    query: GitHubSearchQueryDataModel.fromJson(json['query'] as Map<String, dynamic>? ?? {}),
    searchedAt: DateTime.tryParse(json['searchedAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
  );
}
