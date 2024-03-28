import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ms_admin/widgets/pharmacy_list_widget.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _pharmacyNameController = TextEditingController();
  final TextEditingController _pharmacyReferenceController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void addPharmacyDetails() async {
    if (_formKey.currentState!.validate()) {
      String name = _pharmacyNameController.text.trim();
      String reference = _pharmacyReferenceController.text.trim();
      String pharmacistId = FirebaseAuth.instance.currentUser?.uid ?? '';

      try {
        await FirebaseFirestore.instance.collection('Pharmacies').add({
          'name': name,
          'reference': reference,
          'creationDate': DateFormat('dd-MM-yyyy').format(DateTime.now()),
          'pharmacistId': pharmacistId,
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('Détails de la pharmacie ajoutés avec succès'),
            ),
          ),
        );
      } catch (e) {
        // Gestion des erreurs
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Manage Pharmacies',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
        const Divider(color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Ajouter une pharmacie'),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _pharmacyNameController,
                                decoration:
                                    const InputDecoration(labelText: 'Nom '),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Veuillez saisir le nom de la pharmacie';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _pharmacyReferenceController,
                                decoration: const InputDecoration(
                                    labelText: 'Numero de reference'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Veuillez saisir le numéro de référence';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: addPharmacyDetails,
                                child: const Text('Valider'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text('Ajouter une pharmacie'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            _rowHeader("Nom de la pharmacie", 2),
            _rowHeader("Numero de reference", 1),
            _rowHeader("Localité", 1),
            _rowHeader("Date de création", 1),
            _rowHeader("Actions", 1),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        PharmacyListWidget(),
      ],
    );
  }

  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: const Color(0xFFEEEEEE),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
