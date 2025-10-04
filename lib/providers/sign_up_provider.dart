import 'package:campuswhisper/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignUpProvider extends ChangeNotifier {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  // State
  bool isLoading = false;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Set loading state
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Upload data to Firebase
  Future<void> submitForm(BuildContext context) async {
    try {
      setLoading(true);

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final String uid = credential.user!.uid;
      final user = UserModel(
        uid: uid,
        id: idController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        department: "CSE",
        university: "Independent Unviersity, Bangladesh",
        xp: 0,
        contributions: 0,
        role: 'student',
        
      );

      // Upload to Firestore
      await _firestore.collection('users').doc(user.id).set(user.toMap());

      // Optionally: clear fields or show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User registered successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setLoading(false);
    }
  }

  // Dispose controllers
  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    idController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
