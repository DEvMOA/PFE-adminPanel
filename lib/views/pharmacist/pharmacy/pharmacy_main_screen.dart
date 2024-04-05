import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ms_admin/views/pharmacist/pharmacy/side_bar_screens/category_screen.dart';
import 'package:ms_admin/views/pharmacist/pharmacy/side_bar_screens/dashbord_screen.dart';
import 'package:ms_admin/views/pharmacist/pharmacy/side_bar_screens/medecine_screen.dart';
import 'package:ms_admin/views/pharmacist/pharmacy/side_bar_screens/upload_medecine_screen.dart';
import 'package:ms_admin/widgets/pharmacy_name_widget.dart';

enum SideBarItem {
  dashboard(
      value: 'Dashboard', iconData: Icons.dashboard, body: DashboardScreen()),
  medecine(
      value: 'Medecine',
      iconData: Icons.medical_services,
      body: MedecineScreen()),
  uploadMedecine(
      value: 'Upload Medecine',
      iconData: Icons.medical_services_outlined,
      body: UploadMedecineScreen()),
  uploadCategory(
      value: 'Upload category', iconData: Icons.add, body: CategoryScreen()),
  ;

  const SideBarItem({
    required this.value,
    required this.iconData,
    required this.body,
  });

  final String value;
  final IconData iconData;
  final Widget body;
}

final sideBarItemProvider =
    StateProvider<SideBarItem>((ref) => SideBarItem.dashboard);

class PharmacyMainScreen extends ConsumerWidget {
  const PharmacyMainScreen({super.key});

  SideBarItem getSideBarItem(AdminMenuItem item) {
    for (var value in SideBarItem.values) {
      if (item.route == value.name) {
        return value;
      }
    }
    return SideBarItem.dashboard;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String pharmacyName =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';
    final sideBarItem = ref.watch(sideBarItemProvider);
    final sideBarkey = ValueKey(Random().nextInt(1000000));
    const String stringParam = 'String parameter';
    const int intParam = 1000000;
    PharmacyNameWidget.enteredValue.value = pharmacyName;

    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              //Logo
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.local_pharmacy,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            //Text
            Text(
              pharmacyName,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      sideBar: SideBar(
        key: sideBarkey,
        header: Container(
          height: 50,
          width: double.infinity,
          color: Colors.grey,
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
        activeBackgroundColor: const Color.fromRGBO(0, 255, 0, 0.2),
        activeIconColor: const Color(0xFF006400),
        activeTextStyle: const TextStyle(),
        onSelected: (item) => ref
            .read(sideBarItemProvider.notifier)
            .update((state) => getSideBarItem(item)),
        items: SideBarItem.values
            .map((e) => AdminMenuItem(
                  title: e.value,
                  icon: e.iconData,
                  route: e.name,
                ))
            .toList(),
        selectedRoute: sideBarItem.name,
      ),
      body: ProviderScope(
        overrides: [paramProvider.overrideWithValue((stringParam, intParam))],
        child: sideBarItem.body,
      ),
    );
  }
}

final paramProvider = Provider<(String, int)>((ref) {
  throw UnimplementedError();
});

class Screen extends ConsumerWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(paramProvider);
    return const DashboardScreen();
  }
}
