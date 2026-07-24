import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // acts as a listener
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // get the current logged-in user
  User? get currentUser => _auth.currentUser;

  // Login
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    } catch (e) {
      rethrow; // Pass the error to the UI 
    }
  }

  // Register
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}