import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicapp_flutter/ui/RootHomePage.dart';
import 'package:musicapp_flutter/ui/loginpage.dart';

class AuthService {
  // handles auth
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.done) {
          return RootHomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  //sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //sign in
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
      verificationId: verId,
      smsCode: smsCode,
    );
    signIn(authCredential);
  }

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // final uid = user.uid;
    return user;
    // Similarly we can get email as well
    //final uemail = user.email;
    //print(uemail);
  }
}
