import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ms_admin/views/admin/side_bar_screens/pharmacist_screen.dart';
import 'package:ms_admin/views/pharmacist/profile/side_bar_screens/pharmacy_screen.dart';
import 'package:ms_admin/views/pharmacist/profile/side_bar_screens/profile_screen.dart';
import 'package:ms_admin/views/pharmacist/profile/side_bar_screens/setting_screen.dart';

enum SideBarItem {
  pharmacy(
      value: 'Pharmacy',
      iconData: Icons.local_pharmacy,
      body: PharmacyScreen()),
  profile(value: 'Profile', iconData: Icons.person, body: ProfileScreen()),
  settings(value: 'Settings', iconData: Icons.settings, body: SettingsScreen()),
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
    StateProvider<SideBarItem>((ref) => SideBarItem.pharmacy);

class ProfileMainScreen extends ConsumerWidget {
  const ProfileMainScreen({super.key});

  SideBarItem getSideBarItem(AdminMenuItem item) {
    for (var value in SideBarItem.values) {
      if (item.route == value.name) {
        return value;
      }
    }
    return SideBarItem.pharmacy;
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              //Logo
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.person_add,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            //Text
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const Text('Aucune donnée trouvée');
                }
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return Text(
                  userData['fullName'],
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              },
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
    return const PharmacistScreen();
  }
}
