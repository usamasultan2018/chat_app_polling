import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/services/navigation_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    await _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = context.read<AuthProvider>();

    try {
      final isLoggedIn = await authProvider.checkAuthStatus();

      if (!mounted) return;

      NavigationService.navigateToAndRemoveUntil(
        isLoggedIn ? AppRoutes.userList : AppRoutes.login,
      );
    } catch (_) {
      if (!mounted) return;
      NavigationService.navigateToAndRemoveUntil(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_rounded, size: 80.sp, color: colors.primary),
            16.verticalSpace,

            Text(
              'Chat App',
              style: text.headlineMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.verticalSpace,

            Text(
              'Connect & Communicate',
              style: text.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            32.verticalSpace,

            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colors.primary),
                strokeWidth: 3.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
