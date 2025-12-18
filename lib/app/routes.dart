import 'package:daily_sales_app/features/profile/view/my_profile_view.dart';
import 'package:flutter/material.dart';

import 'package:daily_sales_app/features/splash/splash_view.dart';
import 'package:daily_sales_app/features/auth/view/login_view.dart';
import 'package:daily_sales_app/features/auth/view/register_view.dart';
import 'package:daily_sales_app/features/users/view/user_list_view.dart';
import 'package:daily_sales_app/features/chat/view/chat_coversaton_view.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const userList = '/user-list';
  static const chatConversation = '/chat-conversation';
  static const myProfile = '/my-profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterView());

      case userList:
        return MaterialPageRoute(builder: (_) => const UserListView());

      case myProfile:
        return MaterialPageRoute(builder: (_) => const MyProfileView());

      case chatConversation:
        final args = settings.arguments as Map<String, dynamic>?;

        if (args == null) {
          return _errorRoute('Missing chat arguments');
        }

        return MaterialPageRoute(
          builder: (_) => ChatConversationView(
            userId: args['userId'],
            userName: args['userName'],
            isTargetUserAllowed: args['isTargetUserAllowed'],
          ),
        );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(message, style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
