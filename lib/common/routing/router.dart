import 'package:go_router/go_router.dart';

import '../../exports.dart';

class AppRouter {
  static BuildContext _resolveContext(BuildContext context) => routerNavigatorKey.currentContext ?? context;

  static Future<T?> go<T>(
    BuildContext context,
    RouterNames routerName, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    final safeContext = _resolveContext(context);
    return GoRouter.of(safeContext).pushNamed<T>(routerName.name, pathParameters: pathParameters, extra: extra);
  }

  static void goNamed<T>(
    BuildContext context,
    RouterNames routerName, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    final safeContext = _resolveContext(context);
    GoRouter.of(safeContext).goNamed(routerName.name, pathParameters: pathParameters, extra: extra);
  }

  static void pop(BuildContext context) {
    final safeContext = _resolveContext(context);
    GoRouter.of(safeContext).pop();
  }

  static Provider<GoRouter> config = routerConfig;
}
