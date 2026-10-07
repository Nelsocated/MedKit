import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/medicine_provider.dart';
import 'routes.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final provider = MedicineProvider(StorageService());
            provider.loadMedicines();
            return provider;
          },
        ),
      ],
      child: const MedKitApp(),
    ),
  );
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
