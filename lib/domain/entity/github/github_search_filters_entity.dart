import '../../../exports.dart';

/// Domain entity for GitHub search filters.
class GitHubSearchFiltersEntity {
  const GitHubSearchFiltersEntity({
    required this.username,
    this.location,
    this.language,
    this.minFollowers,
    this.minRepos,
  });

  final String username;
  final String? location;
  final String? language;
  final int? minFollowers;
  final int? minRepos;

  GitHubSearchQueryDataModel toDataModel({int page = 1, int perPage = 20}) => GitHubSearchQueryDataModel(
    username: username,
    location: location,
    language: language,
    minFollowers: minFollowers,
    minRepos: minRepos,
    page: page,
    perPage: perPage,
  );

  factory GitHubSearchFiltersEntity.fromDataModel(GitHubSearchQueryDataModel dataModel) => GitHubSearchFiltersEntity(
    username: dataModel.username,
    location: dataModel.location,
    language: dataModel.language,
    minFollowers: dataModel.minFollowers,
    minRepos: dataModel.minRepos,
  );
}
