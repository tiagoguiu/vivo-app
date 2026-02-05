/// Data model for a GitHub user profile.
class GitHubUserDataModel {
  const GitHubUserDataModel({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.bio,
    required this.location,
    required this.followers,
    required this.publicRepos,
  });

  final String login;
  final String? name;
  final String avatarUrl;
  final String htmlUrl;
  final String? bio;
  final String? location;
  final int followers;
  final int publicRepos;

  Map<String, dynamic> toJson() => {
    'login': login,
    'name': name,
    'avatar_url': avatarUrl,
    'html_url': htmlUrl,
    'bio': bio,
    'location': location,
    'followers': followers,
    'public_repos': publicRepos,
  };

  factory GitHubUserDataModel.fromJson(Map<String, dynamic> json) => GitHubUserDataModel(
    login: json['login'] as String? ?? '',
    name: json['name'] as String?,
    avatarUrl: json['avatar_url'] as String? ?? '',
    htmlUrl: json['html_url'] as String? ?? '',
    bio: json['bio'] as String?,
    location: json['location'] as String?,
    followers: json['followers'] as int? ?? 0,
    publicRepos: json['public_repos'] as int? ?? 0,
  );
}
