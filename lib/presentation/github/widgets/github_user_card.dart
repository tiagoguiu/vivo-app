import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../exports.dart';

/// Card widget that displays GitHub user details and commits chart.
class GitHubUserCard extends ConsumerWidget {
  const GitHubUserCard({super.key, required this.user});

  final GitHubUserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;
    final bodyStyle = theme.textTheme.bodyMedium;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withSafeOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    user.avatarUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 64),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return const SizedBox(width: 64, height: 64, child: Center(child: CircularProgressIndicator()));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name ?? user.login, style: titleStyle?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('@${user.login}', style: bodyStyle?.copyWith(color: Colors.black54)),
                      if (user.location != null && user.location!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.place, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(user.location!, style: bodyStyle, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (user.bio != null && user.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(user.bio!, style: bodyStyle),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MetaChip(label: 'Seguidores', value: NumberFormat.compact().format(user.followers)),
                const SizedBox(width: 12),
                _MetaChip(label: 'Repos', value: NumberFormat.compact().format(user.publicRepos)),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showCommits(context, ref),
                icon: const Icon(Icons.bar_chart),
                label: const Text('Commits recentes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCommits(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _GitHubCommitsSheet(user: user),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(width: 6),
          Text(value, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _GitHubCommitsSheet extends ConsumerWidget {
  const _GitHubCommitsSheet({required this.user});

  final GitHubUserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commitsAsync = ref.watch(gitHubCommitsProvider(user.login));
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text('Commits recentes', style: theme.textTheme.titleLarge)),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 12),
            commitsAsync.when(
              data: (items) => items.isEmpty ? const _EmptyCommitsState() : _CommitsChart(items: items),
              loading: () => const Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
              error: (_, _) => const _ErrorCommitsState(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommitsChart extends StatelessWidget {
  const _CommitsChart({required this.items});

  final List<GitHubRepoCommitEntity> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = items
        .map((item) => item.commitCount)
        .fold<int>(0, (value, element) => value > element ? value : element);

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxValue == 0 ? 1 : maxValue).toDouble(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= items.length) {
                    return const SizedBox.shrink();
                  }
                  final name = items[index].repoName;
                  return SizedBox(
                    width: 32,
                    child: Text(name, style: theme.textTheme.labelSmall, overflow: TextOverflow.ellipsis),
                  );
                },
              ),
            ),
          ),
          barGroups: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.commitCount.toDouble(),
                  color: theme.colorScheme.primary,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EmptyCommitsState extends StatelessWidget {
  const _EmptyCommitsState();

  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.all(24), child: Text('Sem dados de commits para este usuario.'));
}

class _ErrorCommitsState extends StatelessWidget {
  const _ErrorCommitsState();

  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.all(24), child: Text('Falha ao carregar commits.'));
}
