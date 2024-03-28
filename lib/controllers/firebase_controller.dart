import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseController {
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> saveCategory(Map<String, dynamic> data) async {
    return categories.doc(data['name']).set(data);
  }
}
