import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mi_trabajo/providers/global_variables_provider.dart';
import 'package:mi_trabajo/widgets/bn_navigation.dart';
import 'package:mi_trabajo/screens/login_screen.dart';
import 'package:mi_trabajo/services/db_service.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
import 'package:mi_trabajo/services/snackbar_service.dart';

enum AuthStatus {
  notAuthenticated,
  authenticating,
  authenticated,
  userNotFound,
  registering,
  error,
}

const List<String> scopes = <String>['email', 'profile', 'openid'];

class AuthProvider extends ChangeNotifier {
  User? user;

  static AuthProvider instance = AuthProvider();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus? status;

  AuthProvider() {
    _checkCurrentUserIsAuthenticated();
  }

  Future<void> _authoLogin() async {
    if (user != null) {
      return NavigationService.instance
          .navigateToReplacementName(BNavigation.routeName);
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    // ignore: await_only_futures
    user = await _auth.currentUser;
    if (user != null) {
      notifyListeners();
      await _authoLogin();
    } else {
      //notifyListeners();
      return NavigationService.instance
          .navigateToReplacementName(LoginScreen.routeName);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    status = AuthStatus.authenticating;
    notifyListeners();

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        user = result.user;
        status = AuthStatus.authenticated;
        notifyListeners();

        NavigationService.instance
            .navigateToReplacementName(BNavigation.routeName);
      });
    } catch (e) {
      status = AuthStatus.error;
      notifyListeners();
      user = null;
      SnackBarService.instance.showSnackBar("Error al autenticar", false);
    }
  }

  void registerUserWithEmailAndPassword(String email, String password,
      Future<void> Function(String uid) onSuccess) async {
    status = AuthStatus.registering;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      status = AuthStatus.notAuthenticated;
      await onSuccess(user!.uid);
      SnackBarService.instance
          .showSnackBar("Inicia sesión, ${user!.email}", true);
      NavigationService.instance.goBack();
      //Navigate to HomePage
    } catch (e) {
      status = AuthStatus.notAuthenticated;
      user = null;

      if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        SnackBarService.instance
            .showSnackBar("El usuario ya está registrado", false);
      } else {
        SnackBarService.instance.showSnackBar("Error Registering user", false);
      }
      // ignore: avoid_print
      print(e);
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      user = null;
      status = AuthStatus.notAuthenticated;
      GlobalVariables.instance.index = 1;
      await NavigationService.instance
          .navigateToReplacementName(LoginScreen.routeName);
    } catch (e) {
      SnackBarService.instance.showSnackBar("Error al cerrar sesión", false);
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    status = AuthStatus.authenticating;
    notifyListeners();

    try {
      // being interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      //finally lets sign in
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = result.user;

      if (await DBService.instance.existUserInDatabase(user!.uid)) {
        // ignore: avoid_print
        print('El usuario ${user!.displayName} ya existe');
      } else {
        String phoneNumber = user!.phoneNumber ?? 'SN';

        await DBService.instance.createdUserInDB(
          user!.uid,
          user!.displayName!,
          user!.email!,
          phoneNumber,
          user!.photoURL!,
        );
      }

      status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      status = AuthStatus.notAuthenticated;
      user = null;
      SnackBarService.instance.showSnackBar("Error Registering user", false);
      // ignore: avoid_print
      print("**************** $e");
    }
    notifyListeners();
  }
}
