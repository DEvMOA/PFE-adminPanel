import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PharmacyListWidget extends StatelessWidget {
  PharmacyListWidget({Key? key}) : super(key: key);
  final String pharmacistId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Pharmacies')
          .where('pharmacistId', isEqualTo: pharmacistId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            final pharmacyData = snapshot.data!.docs[index];
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(pharmacyData['name']),
                    ),
                    const SizedBox(
                        width:
                            8), // Ajouter de l'espace entre les détails et les boutons
                    Expanded(
                      flex: 1,
                      child: Text(pharmacyData['reference']),
                    ),
                    const SizedBox(
                        width:
                            8), // Ajouter de l'espace entre les détails et les boutons
                    const Expanded(
                      flex: 1,
                      child: Text("Adresse"),
                    ),
                    const SizedBox(
                        width:
                            8), // Ajouter de l'espace entre les détails et les boutons
                    Expanded(
                      flex: 1,
                      child: Text(pharmacyData['creationDate']),
                    ),
                    const SizedBox(
                        width:
                            8), // Ajouter de l'espace entre les détails et les boutons
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String pharmacyName = pharmacyData['name'];
                        Navigator.pushNamed(context, "/pharmacyHomeScreen",
                            arguments: pharmacyName);
                      },
                      child: const Text('Gerer'),
                    ),
                    const SizedBox(
                        width: 8), // Ajouter de l'espace entre les boutons
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.red.withOpacity(
                                  0.1); // Rouge transparent lors du survol
                            }
                            return null; // Aucun effet de survol par défaut
                          },
                        ),
                      ),
                      child: const Text(
                        'Supprimer',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
