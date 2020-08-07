import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musicapp_flutter/core/services/authservice.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String verificationId, smsCode, phoneNumber;
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Welcome MusChat",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: codeSent
                            ? Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              )
                            : Border(),
                      ),
                      child: TextFormField(
                        initialValue: "",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Burası Boş Bırakılamaz";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.8)),
                          hintText: "Phone number",
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.phoneNumber = val;
                          });
                        },
                      ),
                    ),
                    codeSent
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]))),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (validator) {
                                if (validator.isEmpty) {
                                  return "Burası boş bırakılamaz";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(.8)),
                                hintText: "Verification Code",
                              ),
                              onChanged: (val) {
                                setState(() {
                                  this.smsCode = val;
                                });
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState.validate()) {
                      codeSent
                          ? AuthService().signInWithOTP(smsCode, verificationId)
                          : verifyPhone(phoneNumber);
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      // AuthService().signIn(authResult); //otomatik girişi sağlıyor elle girmekten se
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: Duration(seconds: 5),
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
