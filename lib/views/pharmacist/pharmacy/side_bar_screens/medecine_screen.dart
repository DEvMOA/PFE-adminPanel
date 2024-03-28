import 'package:flutter/material.dart';

class MedecineScreen extends StatelessWidget {
  const MedecineScreen({super.key});
  static const String routeName = '/MedecineScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Medecine',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
