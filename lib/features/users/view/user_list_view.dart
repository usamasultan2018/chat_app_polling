import 'package:daily_sales_app/features/users/provider/user_list_provider.dart';
import 'package:daily_sales_app/features/users/view/widgets/empty_state.dart';
import 'package:daily_sales_app/features/users/view/widgets/error_state.dart';
import 'package:daily_sales_app/features/users/view/widgets/user_card.dart';
import 'package:flutter/material.dart';

import 'package:daily_sales_app/app/routes.dart';
import 'package:provider/provider.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<UserListProvider>().fetchUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.myProfile);
            },
          ),
        ],
      ),
      body: Consumer<UserListProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading && provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return ErrorState(
              message: provider.errorMessage!,
              onRetry: provider.fetchUsers,
            );
          }

          if (provider.users.isEmpty) {
            return const EmptyState(
              title: 'No users found',
              subtitle: 'Pull to refresh',
              icon: Icons.people_outline,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshUsers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.users.length,
              itemBuilder: (_, i) {
                final user = provider.users[i];

                return UserCard(
                  user: user,

                  // ✅ CHAT NAVIGATION
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatConversation,
                      arguments: {
                        'userId': user.id,
                        'userName': user.name,
                        'isTargetUserAllowed': user.allowed,
                      },
                    );
                  },

                  // ✅ ADMIN ACTION
                  onLongPress: () =>
                      _showPermissionDialog(context, provider, user),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showPermissionDialog(
    BuildContext context,
    UserListProvider provider,
    user,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change User Status'),
        content: Text(
          user.allowed ? 'Block ${user.name}?' : 'Unblock ${user.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.toggleUserPermission(user.id);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
