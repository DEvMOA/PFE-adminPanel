import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          height: 600,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(20),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center();
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const Text('Aucune donnée trouvée');
                }
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    const SizedBox(height: 20.0),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userData.containsKey('photoURL')
                          ? NetworkImage(userData['photoURL']!)
                          : null,
                      child: !userData.containsKey('photoURL')
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(height: 20.0),
                    ListTile(
                      title: Text(
                        userData['fullName'],
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Nom complet'),
                    ),
                    ListTile(
                      title: Text(
                        userData['referenceNumber'],
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Numéro de référence'),
                    ),
                    ListTile(
                      title: Text(
                        userData['email'],
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('E-mail'),
                    ),
                    ListTile(
                      title: Text(
                        userData['phoneNumber'].toString(),
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Numéro de téléphone'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
