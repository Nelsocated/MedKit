import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MedKitApp());
}

class MedKitApp extends StatelessWidget {
  const MedKitApp({super.key});

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedKit',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
