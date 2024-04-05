import 'package:flutter/material.dart';
import 'package:ms_admin/widgets/pharmacy_name_widget.dart';

class UploadMedecineScreen extends StatelessWidget {
  const UploadMedecineScreen({super.key});
  static const String routeName = '/uploadScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
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
          const Divider(color: Colors.grey),
          const SizedBox(
            height: 20,
          ),
          const PharmacyNameWidget(),
          const SizedBox(
            height: 20,
          ),
          //const UploadMedWidget(),
        ],
      ),
    );
  }
}
