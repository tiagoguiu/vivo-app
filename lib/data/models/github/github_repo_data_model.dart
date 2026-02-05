/// Data model for a GitHub repository summary.
class GitHubRepoDataModel {
  const GitHubRepoDataModel({required this.name, required this.fullName, required this.ownerLogin});

  final String name;
  final String fullName;
  final String ownerLogin;

  factory GitHubRepoDataModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    return GitHubRepoDataModel(
      name: json['name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      ownerLogin: owner['login'] as String? ?? '',
    );
  }
}
