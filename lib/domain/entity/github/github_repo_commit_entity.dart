import '../../../exports.dart';

/// Domain entity for repository commit totals.
class GitHubRepoCommitEntity {
  const GitHubRepoCommitEntity({required this.repoName, required this.commitCount});

  final String repoName;
  final int commitCount;

  factory GitHubRepoCommitEntity.fromDataModel(GitHubRepoCommitDataModel dataModel) =>
      GitHubRepoCommitEntity(repoName: dataModel.repoName, commitCount: dataModel.commitCount);
}
