import 'package:flutter/material.dart';

class PharmacyLocationScreen extends StatefulWidget {
  const PharmacyLocationScreen({super.key});

  @override
  State<PharmacyLocationScreen> createState() => _PharmacyLocationScreenState();
}

class _PharmacyLocationScreenState extends State<PharmacyLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une pharmacie'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nom '),
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Numero de reference'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                //   // Soumettre le formulaire
                //   Navigator.of(context).pop();
                // }
              },
              child: const Text('suivant'),
            ),
          ],
        ),
      ),
    );
  }
}
