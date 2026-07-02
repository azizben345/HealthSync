import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This stream acts as a listener. It yells out whenever the user logs in or out.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Get the current logged-in user
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
      rethrow; // Pass the error to the UI so we can show a snackbar
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