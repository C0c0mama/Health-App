import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:health_app_thesis_project/services/auth_provider.dart';
import 'package:health_app_thesis_project/services/notification_provider.dart';
import 'package:health_app_thesis_project/screens/auth/login_screen.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
