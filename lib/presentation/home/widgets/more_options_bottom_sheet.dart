import 'dart:io';

import '../../../exports.dart';

class MoreOptionsBottomSheet extends ConsumerWidget {
  const MoreOptionsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MoreOptionsBottomSheet(),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) {
      return '';
    }
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = 'Usuário';
    final initials = _getInitials(userName);
    final platform = Theme.of(context).platform;
    final isIos = platform == TargetPlatform.iOS;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isIos ? 20 : 10),
      topRight: Radius.circular(isIos ? 20 : 10),
    );

    return SafeArea(
      top: false,
      bottom: Platform.isAndroid,
      child: Container(
        height: 418 + bottomInset,
        decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.only(top: 24, right: 24),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xFFE22B1F),
                  ),
                ),
              ),

              // Profile section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: Color(0xFFD9D9D9), shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF0277BD),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User name
                    Text(
                      userName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Container(height: 1, color: const Color(0xFFD8D8D8)),
              ),

              // Menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.search,
                      label: 'GitHub Users',
                      onTap: () {
                        Navigator.of(context).pop();
                        AppRouter.go(context, RouterNames.githubSearchPage);
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF323232)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Color(0xFF323232),
          ),
        ),
      ],
    ),
  );
}
