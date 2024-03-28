import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ms_admin/views/admin/admin_main_screen.dart';
import 'package:ms_admin/views/authentification/login_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ms_admin/views/pharmacist/pharmacy/pharmacy_main_screen.dart';
import 'package:ms_admin/views/pharmacist/profile/pharmacy_location_screen.dart';
import 'package:ms_admin/views/pharmacist/profile/profile_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyB96xbDJ44l9KbfAHdofeXijhrX8hP4kS0",
    projectId: "magani-shop",
    messagingSenderId: "1027510130145",
    storageBucket: "magani-shop.appspot.com",
    appId: "1:1027510130145:web:5294d080e50336b6ae2ea0",
  ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      builder: EasyLoading.init(),
      routes: {
        '/adminHomeScreen': (context) => const AdminMainScreen(),
        '/profileHomeScreen': (context) => const ProfileMainScreen(),
        '/pharmacyLocationScreen': (context) => const PharmacyLocationScreen(),
        '/pharmacyHomeScreen': (context) => const PharmacyMainScreen(),
      },
    );
  }
}
