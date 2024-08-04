import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/core/model/purchase_model/purchase_model.dart';
import 'src/core/navigation/navigation.dart';
import 'src/core/service/storage_service.dart';
import 'src/core/service/subscription_service.dart';
import 'src/core/service/user_service.dart';
import 'src/ui/screens/splash/splash.dart';

late final StorageService storageService;
late final SubscriptionsController subscriptionsController;
late final UserController user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  storageService = HiveService();
  await storageService.init();

  user = UserController(const PurchaseModel());
  subscriptionsController = SubscriptionsController(InAppModel());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ai Image Generator',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigationKey,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
