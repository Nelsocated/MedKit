import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'models/medicine.dart';
import 'providers/drug_info_provider.dart';
import 'providers/medicine_provider.dart';
import 'routes.dart';
import 'screens/drug_info_screen.dart';
import 'screens/home_screen.dart';
import 'screens/medicine_detail_screen.dart';
import 'screens/medicine_form_screen.dart';
import 'services/drug_info_service.dart';
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
        ChangeNotifierProvider(
          create: (context) => DrugInfoProvider(DrugInfoService(http.Client())),
        ),
      ],
      child: const MedKitApp(),
    ),
  );
}

class MedKitApp extends StatelessWidget {
  const MedKitApp({super.key});

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.medicineDetail) {
      final argument = settings.arguments;
      if (argument is int) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MedicineDetailScreen(medicineId: argument),
        );
      }
    }

    if (settings.name == Routes.medicineForm) {
      final argument = settings.arguments;
      if (argument == null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const MedicineFormScreen(),
        );
      }
      if (argument is Medicine) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MedicineFormScreen(medicine: argument),
        );
      }
    }

    if (settings.name == Routes.drugInfo) {
      final argument = settings.arguments;
      if (argument is String) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ChangeNotifierProvider(
            create: (context) =>
                DrugInfoProvider(DrugInfoService(http.Client())),
            child: DrugInfoScreen(initialQuery: argument, showAppBar: true),
          ),
        );
      }
    }

    return MaterialPageRoute(
      settings: const RouteSettings(name: Routes.home),
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
