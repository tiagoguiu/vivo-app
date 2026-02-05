import 'package:intl/intl.dart';

import '../../../exports.dart';

/// Page that shows GitHub user profile details.
class GitHubUserDetailsPage extends ConsumerWidget {
  const GitHubUserDetailsPage({super.key, required this.login});

  final String login;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(gitHubUserDetailsProvider(login));

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do GitHub')),
      body: SafeArea(
        child: userAsync.when(
          data: (user) => _ProfileContent(user: user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const _ProfileErrorState(),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final GitHubUserEntity user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(56),
              child: Image.network(
                user.avatarUrl,
                width: 112,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 112),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return const SizedBox(width: 112, height: 112, child: Center(child: CircularProgressIndicator()));
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user.name ?? user.login,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('@${user.login}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
          ),
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(user.bio!, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 20),
          _ProfileRow(label: 'Localizacao', value: user.location ?? 'Nao informada'),
          const SizedBox(height: 12),
          _ProfileRow(label: 'Seguidores', value: NumberFormat.compact().format(user.followers)),
          const SizedBox(height: 12),
          _ProfileRow(label: 'Repositorios', value: NumberFormat.compact().format(user.publicRepos)),
          const SizedBox(height: 12),
          _ProfileRow(label: 'Perfil', value: user.profileUrl),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: theme.textTheme.labelLarge?.copyWith(color: Colors.black54)),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Falha ao carregar o perfil.'));
}
