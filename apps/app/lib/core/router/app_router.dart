import 'package:go_router/go_router.dart';
import 'package:gymai/core/widgets/app_shell.dart';
import 'package:gymai/features/auth/presentation/screens/login_screen.dart';
import 'package:gymai/features/auth/presentation/screens/splash_screen.dart';
import 'package:gymai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gymai/features/diary/presentation/screens/diary_screen.dart';
import 'package:gymai/features/profile/presentation/screens/profile_screen.dart';

part 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginScreen(),
    ),

    // Tabbed shell — preserves each branch's nav stack independently
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(
        currentIndex: navigationShell.currentIndex,
        child: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.diary,
              name: AppRoutes.diaryName,
              builder: (context, state) => const DiaryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: AppRoutes.dashboardName,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: AppRoutes.profileName,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
