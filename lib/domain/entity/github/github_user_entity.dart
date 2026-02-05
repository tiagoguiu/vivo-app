import '../../../exports.dart';

/// Domain entity for a GitHub user profile.
class GitHubUserEntity {
  const GitHubUserEntity({
    required this.login,
    required this.name,
    required this.bio,
    required this.location,
    required this.followers,
    required this.publicRepos,
    required this.avatarUrl,
    required this.profileUrl,
  });

  final String login;
  final String? name;
  final String? bio;
  final String? location;
  final int followers;
  final int publicRepos;
  final String avatarUrl;
  final String profileUrl;

  factory GitHubUserEntity.fromDataModel(GitHubUserDataModel dataModel) => GitHubUserEntity(
    login: dataModel.login,
    name: dataModel.name,
    bio: dataModel.bio,
    location: dataModel.location,
    followers: dataModel.followers,
    publicRepos: dataModel.publicRepos,
    avatarUrl: dataModel.avatarUrl,
    profileUrl: dataModel.htmlUrl,
  );
}
