import 'package:flutter/material.dart';
import 'package:ms_admin/widgets/pharmacist_list_widget.dart';

class PharmacistScreen extends StatelessWidget {
  const PharmacistScreen({super.key});
  static const String routeName = '/PharmacistScreen';
  Widget _rowHeader(String text, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green.shade700),
              color: const Color(0xFFEEEEEE)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Pharmacists',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Row(
            children: [
              _rowHeader('PHARMACIST NAME', 1),
              _rowHeader('REFERENCE NUMBER', 1),
              _rowHeader('PHONE NUMBER', 1),
              _rowHeader('SEXE', 1),
              _rowHeader('ACTION', 1),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const PharmacistWidget(),
        ],
      ),
    );
  }
}
