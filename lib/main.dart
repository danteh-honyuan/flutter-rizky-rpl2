
import 'package:flutter/material.dart';
import 'package:hello/routes/app_routes.dart';
import 'package:hello/services/auth_service.dart';
import 'package:hello/widgets/global_back_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await AuthService().getToken();

  runApp(
    MyApp(isLoggedIn: token != null),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({
    super.key,
    required this.isLoggedIn,
  });

  // Global navigator key
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Global navigation key
      navigatorKey: navigatorKey,

      // Connect all registered pages
      routes: AppRoutes.routes,

      // Initial page based on login status
      initialRoute: isLoggedIn
          ? AppRoutes.home
          : AppRoutes.login,

      // Global bottom back button
      builder: (context, child) {
        return GlobalBackButton(
          navigatorKey: navigatorKey,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
