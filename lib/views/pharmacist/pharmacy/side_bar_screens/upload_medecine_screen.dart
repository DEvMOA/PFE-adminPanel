import 'package:flutter/material.dart';

class UploadMedecineScreen extends StatelessWidget {
  const UploadMedecineScreen({super.key});
  static const String routeName = '/uploadScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Upload Medecine',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
