// Test file để kiểm tra import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  print('Testing Firebase and Google Sign-In imports');
  
  // Test Firebase Auth
  final auth = FirebaseAuth.instance;
  print('Firebase Auth instance: $auth');
  
  // Test Google Sign-In với phiên bản 6.x
  final googleSignIn = GoogleSignIn();
  print('Google Sign-In instance: $googleSignIn');
}
