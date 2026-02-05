import '../../../exports.dart';

/// GitHub user search page with filters and cached results.
class GitHubSearchPage extends ConsumerStatefulWidget {
  const GitHubSearchPage({super.key});

  @override
  ConsumerState<GitHubSearchPage> createState() => _GitHubSearchPageState();
}

class _GitHubSearchPageState extends ConsumerState<GitHubSearchPage> {
  final _usernameController = TextEditingController();
  final _locationController = TextEditingController();
  final _languageController = TextEditingController();
  final _followersController = TextEditingController();
  final _reposController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _locationFocus = FocusNode();
  final _languageFocus = FocusNode();
  final _followersFocus = FocusNode();
  final _reposFocus = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _locationController.dispose();
    _languageController.dispose();
    _followersController.dispose();
    _reposController.dispose();
    _usernameFocus.dispose();
    _locationFocus.dispose();
    _languageFocus.dispose();
    _followersFocus.dispose();
    _reposFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gitHubSearchFiltersProvider, (previous, next) {
      _syncControllers(previous, next);
    });

    final filters = ref.watch(gitHubSearchFiltersProvider);
    final results = ref.watch(gitHubSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Users'),
        actions: [
          IconButton(
            onPressed: () => AppRouter.go(context, RouterNames.githubHistoryPage),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(gitHubSearchProvider.notifier).search(forceRefresh: true);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth > 720 ? 720.0 : constraints.maxWidth;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Buscar usuarios do GitHub', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(
                            'Busque por username e refine com filtros. '
                            'Os resultados ficam em cache por 24h.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _usernameController,
                            focusNode: _usernameFocus,
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              hintText: 'ex: torvalds',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onSubmitted: (_) => _performSearch(),
                          ),
                          const SizedBox(height: 16),
                          ExpansionTile(
                            title: const Text('Filtros avancados'),
                            childrenPadding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
                            children: [
                              TextField(
                                controller: _locationController,
                                focusNode: _locationFocus,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Localizacao',
                                  hintText: 'ex: Brazil',
                                  prefixIcon: Icon(Icons.place),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _languageController,
                                focusNode: _languageFocus,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Linguagem',
                                  hintText: 'ex: Dart',
                                  prefixIcon: Icon(Icons.code),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _followersController,
                                      focusNode: _followersFocus,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(labelText: 'Min. seguidores'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _reposController,
                                      focusNode: _reposFocus,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(labelText: 'Min. repos'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _performSearch,
                                  icon: const Icon(Icons.search),
                                  label: const Text('Buscar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(onPressed: _resetFilters, child: const Text('Limpar')),
                            ],
                          ),
                          const SizedBox(height: 24),
                          results.when(
                            data: (users) => users.isEmpty
                                ? _EmptyState(filters: filters)
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => GitHubUserCard(user: users[index]),
                                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                                    itemCount: users.length,
                                  ),
                            loading: () => const Center(
                              child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
                            ),
                            error: (error, _) => _ErrorState(message: error.toString()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _syncControllers(GitHubSearchFilters? previous, GitHubSearchFilters next) {
    if (!_usernameFocus.hasFocus && _usernameController.text != next.username) {
      _usernameController.text = next.username;
    }
    if (!_locationFocus.hasFocus && _locationController.text != (next.location ?? '')) {
      _locationController.text = next.location ?? '';
    }
    if (!_languageFocus.hasFocus && _languageController.text != (next.language ?? '')) {
      _languageController.text = next.language ?? '';
    }
    if (!_followersFocus.hasFocus && _followersController.text != (next.minFollowers?.toString() ?? '')) {
      _followersController.text = next.minFollowers?.toString() ?? '';
    }
    if (!_reposFocus.hasFocus && _reposController.text != (next.minRepos?.toString() ?? '')) {
      _reposController.text = next.minRepos?.toString() ?? '';
    }
  }

  void _performSearch() {
    ref.read(gitHubSearchFiltersProvider.notifier)
      ..updateUsername(_usernameController.text)
      ..updateLocation(_locationController.text)
      ..updateLanguage(_languageController.text)
      ..updateMinFollowers(_followersController.text)
      ..updateMinRepos(_reposController.text);

    ref.read(gitHubSearchProvider.notifier).search();
  }

  void _resetFilters() {
    ref.read(gitHubSearchFiltersProvider.notifier).reset();
    _usernameController.clear();
    _locationController.clear();
    _languageController.clear();
    _followersController.clear();
    _reposController.clear();
    ref.read(gitHubSearchProvider.notifier).search();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filters});

  final GitHubSearchFilters filters;

  @override
  Widget build(BuildContext context) {
    final message = filters.isValid
        ? 'Nenhum usuario encontrado para os filtros.'
        : 'Informe um username para iniciar a busca.';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(child: Text(message, style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
