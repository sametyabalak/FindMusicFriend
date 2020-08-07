import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicapp_flutter/ui/GenresPage.dart';
// import 'dart:convert';
// import 'package:http/http.dart';
// import 'package:musicapp_flutter/core/services/authservice.dart';
import 'package:musicapp_flutter/ui/playing_music.dart';

class ExplorePage extends StatefulWidget {
  final String userId;
  final String userPhone;
  final String profileImgUrl;

  const ExplorePage({Key key, this.userId, this.userPhone, this.profileImgUrl})
      : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  //
  List userLikedSong;
  String mode = "";
  //
  Firestore _db = Firestore.instance;

  DocumentReference _reference;

  StreamSubscription _userLikes;

  // String cUserUid = "";
  // String cUserPhone = "";

  @override
  void initState() {
    super.initState();
    _reference = _db.collection("users").document(widget.userId);
    getUserLikes();
    findSimilarToFavorite();
    // getCurrentInfo();
  }

  Future<void> findSimilarToFavorite() async {
    await _db
        .collection("users")
        .document(widget.userId)
        .collection("lastPlayed")
        .orderBy("listenCounter", descending: true)
        .limit(1)
        .getDocuments()
        .then((value) {
      value.documents.forEach((doc) {
        setState(() {
          mode = doc.data["mode"];
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userLikes.cancel();
  }

  // Future<void> getCurrentInfo() async {
  //   var user = await AuthService().getCurrentUser();
  //   setState(() {
  //     this.cUserUid = user.uid;
  //     this.cUserPhone = user.phoneNumber;
  //   });
  // }

  void getUserLikes() {
    _userLikes = _reference.snapshots().listen((songIds) {
      if (songIds.data["userLikes"] != null) {
        setState(() {
          userLikedSong = songIds.data["userLikes"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      // decoration: BoxDecoration(
      //   // gradient: LinearGradient(
      //   //   begin: Alignment.topCenter,
      //   //   end: Alignment.bottomCenter,
      //   //   colors: [
      //   //     Color(0xFFF6a09a),
      //   //     Color(0xFF9a1f1d),
      //   //   ],
      //   //   stops: [0, 0.5],
      //   // ),
      // ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                // color: Colors.black,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Genres Of Music",
                          textScaleFactor: 1.8,
                          style: TextStyle(
                              color: Colors.grey[100],
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.4),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 4,
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 10),
                        children: <Widget>[
                          //
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenresPage(
                                    profileImgUrl: widget.profileImgUrl,
                                    userId: widget.userId,
                                    title: "Deep House",
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Deep House",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          //
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenresPage(
                                    profileImgUrl: widget.profileImgUrl,
                                    userId: widget.userId,
                                    title: "Pop",
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Pop",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          //
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenresPage(
                                    profileImgUrl: widget.profileImgUrl,
                                    userId: widget.userId,
                                    title: "Rock",
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Rock & Metal",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Hip-Hop",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Relax",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Blues",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  "Similar To Your Favorite Genres",
                  textScaleFactor: 1.4,
                  style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.4),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: _db
                    .collection("songs")
                    .where("mode", isEqualTo: mode)
                    .orderBy("name")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data.documents
                        .map(
                          (doc) => ListTile(
                            leading: CircleAvatar(
                              maxRadius: 30,
                              backgroundImage: NetworkImage(doc["imgUrl"]),
                            ),
                            title: Text(doc["name"]),
                            subtitle: Text(doc["artist"]),
                            onTap: () async {
                              DocumentReference documentReference = _db
                                  .collection("conversations")
                                  .document(doc.documentID);
                              DocumentSnapshot documentSnapshot =
                                  await documentReference.get();
                              if (documentSnapshot.data != null) {
                                documentReference.updateData({
                                  "members":
                                      FieldValue.arrayUnion([widget.userId])
                                });
                              } else {
                                documentReference.setData({
                                  "members":
                                      FieldValue.arrayUnion([widget.userId])
                                });
                              }

                              //

                              DocumentReference referenceLp = _db
                                  .collection("users")
                                  .document(widget.userId);
                              DateTime now = DateTime.now();
                              await referenceLp
                                  .collection("lastPlayed")
                                  .document(doc.documentID)
                                  .get()
                                  .then((value) {
                                if (value.exists) {
                                  value.data.forEach((key, value) {
                                    if (key == "listenCounter") {
                                      // print(value.runtimeType);
                                      referenceLp
                                          .collection("lastPlayed")
                                          .document(doc.documentID)
                                          .setData({
                                        "dowloadUrl": doc["downloadUrl"],
                                        "artist": doc["artist"],
                                        "imgUrl": doc["imgUrl"],
                                        "name": doc["name"],
                                        "musicId": doc.documentID,
                                        "time": now,
                                        "listenCounter": value + 1,
                                        "mode": doc["mode"],
                                      });
                                    }
                                  });
                                } else {
                                  referenceLp
                                      .collection("lastPlayed")
                                      .document(doc.documentID)
                                      .setData({
                                    "dowloadUrl": doc["downloadUrl"],
                                    "artist": doc["artist"],
                                    "imgUrl": doc["imgUrl"],
                                    "name": doc["name"],
                                    "musicId": doc.documentID,
                                    "time": now,
                                    "listenCounter": 1,
                                    "mode": doc["mode"],
                                  });
                                }
                              });

                              //

                              DocumentReference reference = _db
                                  .collection("users")
                                  .document(widget.userId)
                                  .collection("playingNow")
                                  .document("playingMusicDatas");

                              await reference.get().then((value) {
                                value.data.forEach((key, value) {
                                  if (key == "musicId") {
                                    if (value == doc.documentID) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MusicPage(
                                            tag: widget.userId,
                                            docId: doc.documentID,
                                            pNowId: true,
                                            profileImgUrl: widget.profileImgUrl,
                                          ),
                                        ),
                                      );
                                    } else if (value != doc.documentID) {
                                      reference.setData({
                                        "musicId": doc.documentID,
                                        "playing": "playing"
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MusicPage(
                                            tag: widget.userId,
                                            docId: doc.documentID,
                                            pNowId: false,
                                            profileImgUrl: widget.profileImgUrl,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                });
                              });

                              //artı olarak buraya sarkıyı başlatma fonk siyonu eklenecek
                            },
                            trailing: InkWell(
                              onTap: () async {
                                //
                                DocumentSnapshot snapshot =
                                    await _reference.get();

                                if (snapshot.data["userLikes"] == null) {
                                  await _reference.setData({
                                    "userLikes": FieldValue.arrayUnion(
                                      [doc.documentID],
                                    ),
                                  }, merge: true);
                                } else {
                                  List favSongs = snapshot.data["userLikes"];

                                  if (favSongs.contains(doc.documentID) ==
                                      true) {
                                    await _reference.updateData({
                                      "userLikes": FieldValue.arrayRemove(
                                        [doc.documentID],
                                      ),
                                    });
                                  } else {
                                    await _reference.updateData({
                                      "userLikes": FieldValue.arrayUnion(
                                        [doc.documentID],
                                      ),
                                    });
                                  }
                                }
                                //
                                DocumentReference docRef = _db
                                    .collection("songs")
                                    .document(doc.documentID);
                                DocumentSnapshot documentSnapshot =
                                    await docRef.get();

                                if (documentSnapshot.data["favoriteUsers"] ==
                                    null) {
                                  await docRef.setData({
                                    "favoriteUsers": FieldValue.arrayUnion(
                                      [widget.userId],
                                    ),
                                  }, merge: true);
                                } else {
                                  List favUsers =
                                      documentSnapshot.data["favoriteUsers"];

                                  if (favUsers.contains(widget.userId) ==
                                      true) {
                                    await docRef.updateData({
                                      "favoriteUsers": FieldValue.arrayRemove(
                                          [widget.userId])
                                    });
                                  } else {
                                    await docRef.updateData({
                                      "favoriteUsers":
                                          FieldValue.arrayUnion([widget.userId])
                                    });
                                  }
                                }
                              },
                              child: userLikedSong != null
                                  ? userLikedSong.contains(doc.documentID)
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border)
                                  : Icon(Icons.favorite_border),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

// fncFavState(length, doc, userid) {
//   bool favState = false;
//   for (var i = 0; i < length; i++) {
//     if (doc.data["favoriteUsers"][i] == userid) {
//       favState = true;
//     } else if (doc.data["favoriteUsers"][i] != userid) {
//       favState = false;
//     }
//   }
//   return favState;
// }
