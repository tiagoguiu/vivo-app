import 'package:go_router/go_router.dart';

import '../../exports.dart';

/// Global navigator key for overlay access.
final routerNavigatorKey = GlobalKey<NavigatorState>();

/// Router configuration provider for GitHub User Search app.
final routerConfig = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: routerNavigatorKey,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouterNames.githubSearchPage.name,
        builder: (context, state) => const GitHubSearchPage(),
        routes: [
          GoRoute(
            path: 'history',
            name: RouterNames.githubHistoryPage.name,
            builder: (context, state) => const GitHubHistoryPage(),
          ),
        ],
      ),
    ],
  );
});
