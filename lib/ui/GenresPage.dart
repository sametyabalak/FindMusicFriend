import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp_flutter/ui/playing_music.dart';

class GenresPage extends StatefulWidget {
  final String title;
  final String userId;
  final String profileImgUrl;

  const GenresPage({Key key, this.title, this.userId, this.profileImgUrl})
      : super(key: key);
  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  Firestore _firestore = Firestore.instance;
  CollectionReference _reference;

  @override
  void initState() {
    super.initState();
    _reference = _firestore.collection("songs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 25),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: new Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: new Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: _reference
                        .where("mode", isEqualTo: widget.title)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      // print(snapshot.data.documents.map((e) => print(e)));
                      return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                        ),
                        scrollDirection: Axis.vertical,
                        children: snapshot.data.documents
                            .map(
                              (e) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        DocumentReference reference = _firestore
                                            .collection("users")
                                            .document(widget.userId)
                                            .collection("playingNow")
                                            .document("playingMusicDatas");

                                        await reference.get().then((value) {
                                          value.data.forEach((key, value) {
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
                                                      profileImgUrl:
                                                          widget.profileImgUrl,
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
                                                      profileImgUrl:
                                                          widget.profileImgUrl,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        });

                                        //

                                        CollectionReference
                                            _collectionReference = _firestore
                                                .collection("users")
                                                .document(widget.userId)
                                                .collection("lastPlayed");
                                        DateTime now = DateTime.now();
                                        await _collectionReference
                                            .document(e.documentID)
                                            .get()
                                            .then((value) {
                                          if (value.exists) {
                                            value.data.forEach((key, value) {
                                              if (key == "listenCounter") {
                                                // print(value.runtimeType);
                                                _collectionReference
                                                    .document(e.documentID)
                                                    .setData({
                                                  "dowloadUrl":
                                                      e["downloadUrl"],
                                                  "artist": e["artist"],
                                                  "imgUrl": e["imgUrl"],
                                                  "name": e["name"],
                                                  "musicId": e.documentID,
                                                  "time": now,
                                                  "listenCounter": value + 1,
                                                  "mode": e["mode"],
                                                });
                                              }
                                            });
                                          } else {
                                            _collectionReference
                                                .document(e.documentID)
                                                .setData({
                                              "dowloadUrl": e["downloadUrl"],
                                              "artist": e["artist"],
                                              "imgUrl": e["imgUrl"],
                                              "name": e["name"],
                                              "musicId": e.documentID,
                                              "time": now,
                                              "listenCounter": 1,
                                              "mode": e["mode"],
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: AspectRatio(
                                          aspectRatio: 1.5 / 1.2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              e["imgUrl"],
                                              alignment: Alignment.center,
                                              fit: BoxFit.fill,
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
                                              : e["name"].substring(0, 12) +
                                                  "...",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          (e["artist"]).length < 15
                                              ? e["artist"]
                                              : e["artist"].substring(0, 12) +
                                                  "...",
                                          style:
                                              TextStyle(color: Colors.white60),
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
            ],
          ),
        ),
      ),
    );
  }
}
