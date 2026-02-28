import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymai/core/theme/app_theme.dart';

/// The main tab shell with a custom bottom navigation bar.
/// The center Dashboard tab is elevated and highlighted.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, required this.currentIndex, super.key});

  final Widget child;
  final int currentIndex;

  static const _routes = ['/diary', '/dashboard', '/profile'];

  void _onTap(BuildContext context, int index) {
    if (index != currentIndex) {
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _GymAIBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}

class _GymAIBottomNav extends StatelessWidget {
  const _GymAIBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(
            color: AppColors.surfaceVariant,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Diary tab
              _NavItem(
                icon: Icons.book_outlined,
                activeIcon: Icons.book,
                label: 'Diary',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),

              // Dashboard tab – elevated center FAB-style (OverflowBox lets it float above the bar)
              Expanded(
                child: OverflowBox(
                  maxHeight: 80,
                  alignment: Alignment.bottomCenter,
                  child: _CenterNavItem(
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                ),
              ),

              // Profile tab
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceMuted;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The promoted center dashboard button — floats above the nav bar.
class _CenterNavItem extends StatelessWidget {
  const _CenterNavItem({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Elevated circle button
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              transform: Matrix4.translationValues(
                0,
                isSelected ? -10 : -4,
                0,
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isSelected
                        ? [
                            AppColors.primary,
                            AppColors.accent,
                          ]
                        : [
                            AppColors.surfaceVariant,
                            AppColors.surfaceVariant,
                          ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Icon(
                  isSelected
                      ? Icons.dashboard_rounded
                      : Icons.dashboard_outlined,
                  color: isSelected
                      ? Colors.white
                      : AppColors.onSurfaceMuted,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.onSurfaceMuted,
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: const Text('Dashboard'),
            ),
          ],
        ),
    );
  }
}
