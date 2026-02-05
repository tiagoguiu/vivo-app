/// Data model for a GitHub search result item.
class GitHubSearchItemDataModel {
  const GitHubSearchItemDataModel({required this.login});

  final String login;

  factory GitHubSearchItemDataModel.fromJson(Map<String, dynamic> json) =>
      GitHubSearchItemDataModel(login: json['login'] as String? ?? '');
}
