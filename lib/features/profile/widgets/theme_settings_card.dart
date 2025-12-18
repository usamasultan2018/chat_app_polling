import 'package:daily_sales_app/core/provider/theme_provider.dart';
import 'package:flutter/material.dart';

class ThemeSettingsCard extends StatelessWidget {
  final ThemeProvider themeProvider;

  const ThemeSettingsCard({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              _getThemeIcon(themeProvider.themeMode),
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Theme Mode'),
            subtitle: Text(_getThemeLabel(themeProvider.themeMode)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: Icon(
              Icons.brightness_6,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Quick Toggle'),
            subtitle: const Text('Switch between light and dark'),
            value: themeProvider.isDark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              subtitle: const Text('Always use light theme'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (_) {
                themeProvider.setLightMode();
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              subtitle: const Text('Always use dark theme'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (_) {
                themeProvider.setDarkMode();
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              subtitle: const Text('Follow system settings'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (_) {
                themeProvider.setSystemMode();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
