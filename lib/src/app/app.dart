import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../pages/principal_page.dart';
import '../pages/escanear_page.dart';
import '../pages/configuracion_page.dart';
import 'providers.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(maxWidth: 448), // max-w-md (28rem = 448px)
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildPage(activeTab),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, ref, activeTab),
    );
  }

  Widget _buildPage(String tab) {
    switch (tab) {
      case 'escanear':
        return const EscanearPage(key: ValueKey('escanear'));
      case 'configuracion':
        return const ConfiguracionPage(key: ValueKey('configuracion'));
      case 'principal':
      default:
        return const PrincipalPage(key: ValueKey('principal'));
    }
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref, String activeTab) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accentColor : AppTheme.accentColorLight;

    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        border: Border(
          top: BorderSide(
            color: accentColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                ref: ref,
                icon: Icons.home,
                label: 'Principal',
                tabKey: 'principal',
                isActive: activeTab == 'principal',
              ),
              _buildNavItem(
                context: context,
                ref: ref,
                icon: Icons.bluetooth_searching,
                label: 'Escanear',
                tabKey: 'escanear',
                isActive: activeTab == 'escanear',
              ),
              _buildNavItem(
                context: context,
                ref: ref,
                icon: Icons.settings,
                label: 'Configuración',
                tabKey: 'configuracion',
                isActive: activeTab == 'configuracion',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String label,
    required String tabKey,
    required bool isActive,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ref.read(activeTabProvider.notifier).state = tabKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween(begin: 1.0, end: isActive ? 1.1 : 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Icon(
                        icon,
                        size: 24,
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
