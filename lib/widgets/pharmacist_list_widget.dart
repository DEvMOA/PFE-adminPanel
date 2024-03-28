import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PharmacistWidget extends StatelessWidget {
  const PharmacistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: '')
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
            final pharmacistData = snapshot.data!.docs[index];
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(child: Text(pharmacistData['fullName'])),
                    Expanded(child: Text(pharmacistData['referenceNumber'])),
                    Expanded(
                        child: Text(pharmacistData['phoneNumber'].toString())),
                    Expanded(child: Text(pharmacistData['sexe'])),
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
                        // Accéder au document spécifique que vous souhaitez mettre à jour
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(pharmacistData.id);

                        // Utiliser la méthode update pour mettre à jour le champ "role" à "approuvé"
                        docRef.update({
                          'role': 'pharmacien',
                        });
                      },
                      child: const Text('Approuver'),
                    ),
                    const SizedBox(
                        width: 8), // Ajouter de l'espace entre les boutons
                    ElevatedButton(
                      onPressed: () {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(pharmacistData.id);

                        docRef.update({
                          'role': 'refuse',
                        });
                      },
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
                        'Rejeter',
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
