import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ms_admin/views/admin/side_bar_screens/banner_screen.dart';
import 'package:ms_admin/views/admin/side_bar_screens/category_screen.dart';
import 'package:ms_admin/views/admin/side_bar_screens/dashboard_screen.dart';
import 'package:ms_admin/views/admin/side_bar_screens/patient_screen.dart';
import 'package:ms_admin/views/admin/side_bar_screens/pharmacist_screen.dart';
import 'package:ms_admin/views/admin/side_bar_screens/product_screen.dart';

enum SideBarItem {
  dashboard(
      value: 'Dashboard', iconData: Icons.dashboard, body: DashboardScreen()),
  pharmacist(
      value: 'Pharmacists',
      iconData: Icons.local_pharmacy,
      body: PharmacistScreen()),
  patient(value: 'Patients', iconData: Icons.person, body: PatientScreen()),
  category(
      value: 'Categories', iconData: Icons.category, body: CategoryScreen()),
  product(value: 'Products', iconData: Icons.shop, body: ProductScreen()),
  banner(value: 'Upload Banners', iconData: Icons.add, body: BannerScreen());

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

class AdminMainScreen extends ConsumerWidget {
  const AdminMainScreen({super.key});

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
    final sideBarItem = ref.watch(sideBarItemProvider);
    final sideBarkey = ValueKey(Random().nextInt(1000000));
    const String stringParam = 'String parameter';
    const int intParam = 1000000;
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Row(
          children: [
            Padding(
              //Logo
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            //Text
            Text(
              'MAGANI',
              style: TextStyle(
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
