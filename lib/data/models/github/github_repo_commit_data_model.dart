/// Data model for commit totals by repository.
class GitHubRepoCommitDataModel {
  const GitHubRepoCommitDataModel({required this.repoName, required this.commitCount});

  final String repoName;
  final int commitCount;

  Map<String, dynamic> toJson() => {'repoName': repoName, 'commitCount': commitCount};

  factory GitHubRepoCommitDataModel.fromJson(Map<String, dynamic> json) => GitHubRepoCommitDataModel(
    repoName: json['repoName'] as String? ?? '',
    commitCount: json['commitCount'] as int? ?? 0,
  );
}
