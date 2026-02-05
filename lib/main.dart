import 'package:intl/date_symbol_data_local.dart';

import 'exports.dart';

/// Entry point for GitHub User Search application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([initializeDateFormatting('pt_BR'), LocalStorageService.init()]);

  runApp(const ProviderScope(child: GitHubUserSearchApp()));
}

/// Main application widget for GitHub User Search.
class GitHubUserSearchApp extends ConsumerWidget {
  const GitHubUserSearchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'GitHub User Search',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightThemeData,
    themeMode: ThemeMode.light,
    routerConfig: ref.watch(routerConfig),
    builder: (context, child) => UnfocusWidget(child: child!),
  );
}

/// Widget that dismisses keyboard when tapping outside.
class UnfocusWidget extends StatelessWidget {
  final Widget child;
  const UnfocusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () => FocusScope.of(context).unfocus(), child: child);
}
