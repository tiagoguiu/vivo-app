import 'package:intl/intl.dart';

import '../../../exports.dart';

/// Page that lists previous GitHub searches.
class GitHubHistoryPage extends ConsumerWidget {
  const GitHubHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(gitHubHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historico de buscas'),
        actions: [
          IconButton(
            onPressed: () => ref.read(gitHubHistoryProvider.notifier).clearHistory(),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: historyAsync.when(
          data: (history) => history.isEmpty
              ? const _EmptyHistoryState()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    final label = entry.filters.username;
                    final subtitle = entry.filters.location ?? 'Sem localizacao';
                    final date = DateFormat('dd/MM/yyyy HH:mm').format(entry.searchedAt.toLocal());
                    return ListTile(
                      title: Text(label),
                      subtitle: Text('$subtitle · $date'),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Repetir busca',
                        onPressed: () {
                          ref.read(gitHubSearchFiltersProvider.notifier).applyHistory(entry);
                          ref.read(gitHubSearchProvider.notifier).search();
                          AppRouter.go(context, RouterNames.githubSearchPage);
                        },
                      ),
                      onTap: () {
                        AppRouter.go(
                          context,
                          RouterNames.githubUserDetailsPage,
                          pathParameters: {'login': entry.filters.username},
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: history.length,
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const _ErrorHistoryState(),
        ),
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Sem buscas recentes.'));
}

class _ErrorHistoryState extends StatelessWidget {
  const _ErrorHistoryState();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Falha ao carregar historico.'));
}
