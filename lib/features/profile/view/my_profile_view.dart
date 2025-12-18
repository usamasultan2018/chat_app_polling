// features/profile/view/my_profile_view.dart
import 'package:daily_sales_app/core/provider/theme_provider.dart';
import 'package:daily_sales_app/features/auth/providers/auth_provider.dart';
import 'package:daily_sales_app/features/profile/widgets/profile_header.dart';
import 'package:daily_sales_app/features/profile/widgets/theme_settings_card.dart';
import 'package:daily_sales_app/features/profile/widgets/logout_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(user: user),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ThemeSettingsCard(themeProvider: themeProvider),
                  const SizedBox(height: 24),
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LogoutCard(authProvider: authProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
