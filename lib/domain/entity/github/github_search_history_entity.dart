import '../../../exports.dart';

/// Domain entity for search history entries.
class GitHubSearchHistoryEntity {
  const GitHubSearchHistoryEntity({
    required this.type,
    required this.searchedAt,
    this.filters,
    this.profileLogin,
    this.profileName,
  });

  final GitHubHistoryType type;
  final GitHubSearchFiltersEntity? filters;
  final String? profileLogin;
  final String? profileName;
  final DateTime searchedAt;

  factory GitHubSearchHistoryEntity.fromDataModel(GitHubSearchHistoryDataModel dataModel) => GitHubSearchHistoryEntity(
    type: dataModel.type,
    filters: dataModel.query == null ? null : GitHubSearchFiltersEntity.fromDataModel(dataModel.query!),
    profileLogin: dataModel.profileLogin,
    profileName: dataModel.profileName,
    searchedAt: dataModel.searchedAt,
  );
}
