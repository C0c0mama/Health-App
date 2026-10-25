import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'themes/app_theme.dart';
import 'services/auth_provider.dart';
import 'services/notification_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait — typical for healthcare mobile apps
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const BrgyHealthApp(),
    ),
  );
}

class BrgyHealthApp extends StatelessWidget {
  const BrgyHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrgyHealth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // ── Auth Gate ──────────────────────────────────────────────────────
      // Consumer rebuilds whenever AuthProvider notifies.
      //
      // Key insight: using a ValueKey on each screen forces Flutter to
      // REPLACE (not reuse) the widget when auth state changes. This
      // destroys the old navigator stack entirely so:
      //   • After logout  → back button exits the app, not back to MainShell
      //   • After login   → back button exits the app, not back to LoginScreen
      //
      // AnimatedSwitcher adds a smooth crossfade between the two states.
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: auth.isAuthenticated
                ? const MainShell(key: ValueKey('shell'))
                : const LoginScreen(key: ValueKey('login')),
          );
        },
      ),
    );
  }
}
