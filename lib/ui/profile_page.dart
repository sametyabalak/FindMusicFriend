import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key key, this.userId}) : super(key: key);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  //
  String url;
  bool _status = true;
  //
  final FocusNode myFocusNode = FocusNode();
  //
  File _pickedImage;
  final picker = ImagePicker();
  //
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  final _name = new TextEditingController();
  final _email = new TextEditingController();
  final _username = new TextEditingController();
  final _statu = new TextEditingController();
  final _birthday = new TextEditingController();
  //
  DateTime _dateTime;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  //
  Firestore _firestore = Firestore.instance;
  DocumentReference _ref;
  //
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  void initState() {
    super.initState();
    _ref = _firestore.collection("users").document(widget.userId);
    _storageReference = _firebaseStorage
        .ref()
        .child("users")
        .child(widget.userId)
        .child("profileImage.png");
    getUserInfo();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
    _name.dispose();
    _email.dispose();
    _username.dispose();
    _statu.dispose();
    _birthday.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: new Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: new Text('PROFILE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Stack(
                            fit: StackFit.loose,
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: _pickedImage == null
                                            ? url == null
                                                ? new ExactAssetImage(
                                                    'assets/images/as.png')
                                                : NetworkImage(url)
                                            : FileImage(_pickedImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap:
                                          _status ? null : pickImageFromCamera,
                                      child: new CircleAvatar(
                                        backgroundColor:
                                            _status ? Colors.grey : Colors.red,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, left: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap:
                                          _status ? null : pickImageFromGalery,
                                      child: new CircleAvatar(
                                        backgroundColor:
                                            _status ? Colors.grey : Colors.red,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.photo_library,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Edit Your Info',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: _name,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return "Lütfen Adınızı Boş Bırakmayınız";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Enter Your Name",
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Username',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: _username,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return "Lütfen Kullanıcı Adınızı Boş Bırakmayınız";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Your Username"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: _email,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return "Lütfen Email Alanını Boş Bırakmayınız";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Your Email "),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Birthday',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: _status
                                            ? new TextFormField(
                                                controller: _birthday,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "Enter BDay"),
                                                enabled: !_status,
                                              )
                                            : RaisedButton(
                                                elevation: 10,
                                                color: Colors.white,
                                                disabledColor: Colors.white,
                                                onPressed: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1960),
                                                    lastDate: DateTime(2021),
                                                  ).then((value) => {
                                                        setState(() {
                                                          _dateTime = value;
                                                        }),
                                                      });
                                                },
                                                child: _dateTime == null
                                                    ? Text(
                                                        _birthday.text,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      )
                                                    : Text(
                                                        _dateTime.toString(),
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                              ),
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: new TextFormField(
                                        controller: _statu,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return "Lütfen Durum Bilginizi Boş Bırakmayınız";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Status"),
                                        enabled: !_status,
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            !_status ? _getActionButtons() : new Container(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                    //
                    addInformation(
                      _name.text,
                      _email.text,
                      _username.text,
                      _dateTime,
                      _statu.text,
                      _pickedImage,
                    );
                    // _name.clear();
                    // _email.clear();
                    // _username.clear();
                    // _statu.clear();
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _dateTime = null;
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Future<void> addInformation(String name, String email, String username,
      DateTime time, String status, File profileImage) async {
    if (profileImage != null) {
      StorageUploadTask uploadTask = _storageReference.putFile(profileImage);
      await uploadTask.onComplete;
      var url = await _storageReference.getDownloadURL();
      _ref.setData({
        "profileImageUrl": url,
      }, merge: true);
    }

    if (time != null) {
      _ref.setData({
        "name": name,
        "email": email,
        "username": username,
        "birthday": time,
        "state": status,
      }, merge: true).whenComplete(() => {
            _displaySnackBar(context),
          });
    } else {
      _ref.setData({
        "name": name,
        "email": email,
        "username": username,
        "state": status,
      }, merge: true).whenComplete(() => {
            _displaySnackBar(context),
          });
    }
  }

  Future<void> getUserInfo() async {
    await _ref.get().then((value) {
      var time;
      setState(() {
        _name.text = value.data["name"];
        _email.text = value.data["email"];
        _username.text = value.data["username"];
        _statu.text = value.data["state"];
        //
        if (value.data["birthday"] != null) {
          time = value.data["birthday"].toDate();
          _birthday.text = df.format(time).toString();
        }
        //
        if (value.data["profileImageUrl"] != null) {
          url = value.data["profileImageUrl"];
        }
      });
    });
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Row(
      children: <Widget>[
        Text('Saved'),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.thumb_up,
          color: Colors.white,
        )
      ],
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> pickImageFromGalery() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final image = await picker.getImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }
}
