import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUpUser(
    String fullName,
    String email,
    String numReference,
    int phoneNumber,
    String sexe,
    String password,
    String confirmPassword,
  ) async {
    try {
      if (passwordConfirmed(password, confirmPassword)) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        String uid = userCredential.user!.uid;
        addUserDetails(fullName, email, numReference, phoneNumber, sexe, uid);
      }
    } catch (e) {
      //print(e);
    }
  }

  Future addUserDetails(String fullName, String email, String numReference,
      int number, String sexe, String uid) async {
    await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'fullName': fullName,
      'email': email,
      'referenceNumber': numReference,
      'phoneNumber': number,
      'sexe': sexe,
      'role': ''
    });
  }

  bool passwordConfirmed(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    } else {
      return false;
    }
  }
}
