import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Đăng nhập bằng Google
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Đăng xuất trước để đảm bảo popup hiển thị
      await _googleSignIn.signOut();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return {
          'success': false,
          'error': 'Đăng nhập Google bị hủy',
        };
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return {
          'success': false,
          'error': 'Không thể lấy thông tin xác thực từ Google',
        };
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return {
          'success': false,
          'error': 'Không thể lấy thông tin người dùng từ Firebase',
        };
      }

      // Thông tin user từ Google
      final userInfo = {
        'uid': user.uid,
        'email': user.email ?? googleUser.email,
        'displayName': user.displayName ?? googleUser.displayName ?? '',
        'photoURL': user.photoURL ?? googleUser.photoUrl ?? '',
        'phoneNumber': user.phoneNumber ?? '',
      };

      debugPrint('✅ Google Sign In Success: ${userInfo['email']}');

      return {
        'success': true,
        'user': userInfo,
        'isNewUser': userCredential.additionalUserInfo?.isNewUser ?? false,
        'userId': user.uid,
      };
      
    } catch (e) {
      debugPrint('❌ Google Sign In Error: $e');
      return {
        'success': false,
        'error': 'Lỗi đăng nhập Google: ${e.toString()}',
      };
    }
  }

  /// Đăng xuất
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
      debugPrint('✅ Sign out successful');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
    }
  }

  /// Kiểm tra trạng thái đăng nhập
  static Future<bool> isSignedIn() async {
    try {
      return _auth.currentUser != null;
    } catch (e) {
      debugPrint('❌ Check sign in status error: $e');
      return false;
    }
  }

  /// Lấy thông tin user hiện tại
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final User? firebaseUser = _auth.currentUser;
      
      if (firebaseUser != null) {
        return {
          'uid': firebaseUser.uid,
          'email': firebaseUser.email ?? '',
          'displayName': firebaseUser.displayName ?? '',
          'photoURL': firebaseUser.photoURL ?? '',
          'phoneNumber': firebaseUser.phoneNumber ?? '',
        };
      }
      return null;
    } catch (e) {
      debugPrint('❌ Get current user error: $e');
      return null;
    }
  }
}
