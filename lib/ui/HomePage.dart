import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:musicapp_flutter/ui/makeBottomNavBar.dart';
import 'package:musicapp_flutter/ui/makeCarosel.dart';

class HomePage extends StatefulWidget {
  final userId;

  const HomePage({Key key, this.userId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firestore _firestore = Firestore.instance;
  CollectionReference _collectionReference;
  @override
  void initState() {
    super.initState();
    _collectionReference = _firestore
        .collection("users")
        .document(widget.userId)
        .collection("lastPlayed");

    // print(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // SizedBox(
          //   height: 50,
          // ),
          MakeCarosel(),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Most Listened This Week",
                      textScaleFactor: 1.9,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(),
                    child: StreamBuilder(
                        stream: _collectionReference
                            .orderBy("listenCounter", descending: true)
                            .limit(5)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.documents
                                .map(
                                  (e) => makeCategory(
                                    artist: (e["artist"]).length < 15
                                        ? e["artist"]
                                        : e["artist"].substring(0, 12) + "...",
                                    title: (e["name"]).length < 15
                                        ? e["name"]
                                        : e["name"].substring(0, 15) + "...",
                                    image: e["imgUrl"],
                                    counter: e["listenCounter"],
                                  ),
                                )
                                .toList(),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  // Widget buildWidgetCatologAspect({catalogTitle}) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     height: 250,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             SizedBox(
  //               width: 30,
  //             ),
  //             Text(
  //               catalogTitle,
  //               textScaleFactor: 1.9,
  //               style: TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 15,
  //         ),
  //         Expanded(
  //           child: Container(
  //             padding: EdgeInsets.only(left: 15),
  //             decoration: BoxDecoration(),
  //             child: ListView.builder(
  //               itemBuilder: (BuildContext context, int index) {
  //                 var music = musics[index];
  //                 return makeCategory(
  //                   artist: music.artsit.toString(),
  //                   title: music.title.toString(),
  //                   image: music.imageUrl.toString(),
  //                 );
  //               },
  //               itemCount: musics.length,
  //               scrollDirection: Axis.horizontal,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget makeCategory({image, title, artist, counter}) {
    return AspectRatio(
      aspectRatio: 1.75 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 12),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        artist,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Spacer(),
                      Icon(
                        Icons.repeat,
                        color: Colors.white54,
                        size: 15,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "$counter",
                        style: TextStyle(color: Colors.white54),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
