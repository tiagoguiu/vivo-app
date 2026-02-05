import 'github_search_item_data_model.dart';

/// Data model for a GitHub search response.
class GitHubSearchResponseDataModel {
  const GitHubSearchResponseDataModel({required this.items});

  final List<GitHubSearchItemDataModel> items;

  factory GitHubSearchResponseDataModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    return GitHubSearchResponseDataModel(
      items: rawItems.whereType<Map<String, dynamic>>().map(GitHubSearchItemDataModel.fromJson).toList(),
    );
  }
}
