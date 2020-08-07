import 'package:flutter/material.dart';
import 'package:musicapp_flutter/core/services/authservice.dart';
// import 'package:musicapp_flutter/ui/RootHomePage.dart';

void main() {
  // setupLocators();
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthService().handleAuth(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
    );
  }
}
