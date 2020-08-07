// import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp_flutter/ui/playing_music.dart';

class LibraryPage extends StatefulWidget {
  final String userId;
  final String profileImgUrl;

  const LibraryPage({Key key, this.userId, this.profileImgUrl})
      : super(key: key);
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Firestore _firestore = Firestore.instance;
  CollectionReference _collectionReference;

  @override
  void initState() {
    super.initState();
    _collectionReference = _firestore
        .collection("users")
        .document(widget.userId)
        .collection("lastPlayed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black87,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Last Played",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(right: 10),
                        //   child: Icon(
                        //     Icons.arrow_forward_ios,
                        //     color: Colors.white70,
                        //   ),
                        // ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: _collectionReference
                              .orderBy("time", descending: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            // print(snapshot.data.documents.map((e) => print(e)));
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.documents
                                  .map(
                                    (e) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              DocumentReference reference =
                                                  _firestore
                                                      .collection("users")
                                                      .document(widget.userId)
                                                      .collection("playingNow")
                                                      .document(
                                                          "playingMusicDatas");

                                              await reference
                                                  .get()
                                                  .then((value) {
                                                value.data
                                                    .forEach((key, value) {
                                                  if (key == "musicId") {
                                                    if (value == e.documentID) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MusicPage(
                                                            tag: widget.userId,
                                                            docId: e.documentID,
                                                            pNowId: true,
                                                            profileImgUrl: widget
                                                                .profileImgUrl,
                                                          ),
                                                        ),
                                                      );
                                                    } else if (value !=
                                                        e.documentID) {
                                                      reference.setData({
                                                        "musicId": e.documentID,
                                                        "playing": "playing"
                                                      });
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MusicPage(
                                                            tag: widget.userId,
                                                            docId: e.documentID,
                                                            pNowId: false,
                                                            profileImgUrl: widget
                                                                .profileImgUrl,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                });
                                              });

                                              //

                                              DateTime now = DateTime.now();
                                              await _collectionReference
                                                  .document(e.documentID)
                                                  .get()
                                                  .then((value) {
                                                value.data
                                                    .forEach((key, value) {
                                                  if (key == "listenCounter") {
                                                    _collectionReference
                                                        .document(e.documentID)
                                                        .setData({
                                                      "time": now,
                                                      "listenCounter":
                                                          value + 1,
                                                    }, merge: true);
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: AspectRatio(
                                                aspectRatio: 1.2 / 1.5,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    e["imgUrl"],
                                                    alignment: Alignment.center,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                (e["name"]).length < 15
                                                    ? e["name"]
                                                    : e["name"]
                                                            .substring(0, 14) +
                                                        "...",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                e["artist"],
                                                style: TextStyle(
                                                    color: Colors.white60),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            );
                          }),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.white70,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Your Playlist",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 20),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white60,
                                    size: 18,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.file_download,
                                    color: Colors.white70,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Downloads",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 20),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white60,
                                    size: 18,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.music_note,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Songs",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white60,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
