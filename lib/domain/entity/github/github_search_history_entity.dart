import '../../../exports.dart';

/// Domain entity for search history entries.
class GitHubSearchHistoryEntity {
  const GitHubSearchHistoryEntity({required this.filters, required this.searchedAt});

  final GitHubSearchFiltersEntity filters;
  final DateTime searchedAt;

  factory GitHubSearchHistoryEntity.fromDataModel(GitHubSearchHistoryDataModel dataModel) => GitHubSearchHistoryEntity(
    filters: GitHubSearchFiltersEntity.fromDataModel(dataModel.query),
    searchedAt: dataModel.searchedAt,
  );
}
