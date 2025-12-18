import 'package:daily_sales_app/core/network/client/api_client.dart';
import 'package:daily_sales_app/core/provider/theme_provider.dart';
import 'package:daily_sales_app/core/token_repository.dart';
import 'package:daily_sales_app/features/auth/data/repositories/auth_repository.dart';
import 'package:daily_sales_app/features/auth/providers/auth_provider.dart';
import 'package:daily_sales_app/features/chat/data/repository/chat_repository.dart';
import 'package:daily_sales_app/features/chat/provider/chat_provider.dart';
import 'package:daily_sales_app/features/users/data/repository/user_list_repository.dart';
import 'package:daily_sales_app/features/users/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/services/navigation_service.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) =>
              AuthProvider(AuthRepository(ApiClient(), TokenRepository())),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => UserListProvider(
            UserListRepository(ApiClient(), TokenRepository()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(ChatRepository(ApiClient())),
        ),
        // ➕ add more providers here
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeProvider = context.watch<ThemeProvider>();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Daily Sales App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            navigatorKey: NavigationService.navigatorKey,
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
