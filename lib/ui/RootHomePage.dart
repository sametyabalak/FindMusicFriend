import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp_flutter/core/services/authservice.dart';
// import 'package:musicapp_flutter/core/services/databaseservice.dart';
import 'package:musicapp_flutter/ui/ExplorePage.dart';
import 'package:musicapp_flutter/ui/HomePage.dart';
import 'package:musicapp_flutter/ui/LikedSongs.dart';
import 'package:musicapp_flutter/ui/library.dart';
import 'package:musicapp_flutter/ui/playing_music.dart';
import 'package:musicapp_flutter/ui/profile_page.dart';

class RootHomePage extends StatefulWidget {
  @override
  _RootHomePageState createState() => _RootHomePageState();
}

// enum PlayerState { stopped, playing, paused }

class _RootHomePageState extends State<RootHomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool onTapArrow = false;
  bool visible = true;

  StreamSubscription _userInformations;

  String cUserUid = "";
  String cUserPhone = "";
  String email = "";
  String name = "";
  String profileImageUrl = "";
  String docId = "";
  Firestore _firestore = Firestore.instance;
  DocumentReference _ref;

  @override
  void initState() {
    super.initState();
    userCreateFirstEntry();
    getCurrentUserPersonelInfo();
    // getCurrentInfo(); diğerlerinin içinde var
  }

  @override
  void dispose() {
    _userInformations.cancel();
    super.dispose();
  }

  Future<void> getCurrentInfo() async {
    var user = await AuthService().getCurrentUser();
    setState(() {
      this.cUserUid = user.uid;
      this.cUserPhone = user.phoneNumber;
    });
    _ref = _firestore.collection("users").document(cUserUid);
  }

  void userCreateFirstEntry() async {
    await getCurrentInfo();

    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").document(cUserUid).get();

    if (documentSnapshot.exists) {
      print("dosya var");
      print("Birşey Yapamaya Gerek Yok ");
    } else {
      print("İlk User Create İşlemi");
      Firestore.instance
          .collection('users')
          .document(cUserUid)
          .setData({'phoneNumber': cUserPhone}, merge: true);
    }
  }

  getCurrentUserPersonelInfo() async {
    await getCurrentInfo();
    _userInformations = _ref.snapshots().listen((snapshot) {
      if (snapshot.data["name"] != null) {
        setState(() {
          this.name = snapshot.data["name"];
        });
      }
      if (snapshot.data["profileImageUrl"] != null) {
        setState(() {
          this.profileImageUrl = snapshot.data["profileImageUrl"];
        });
      }
      if (snapshot.data["email"] != null) {
        setState(() {
          this.email = snapshot.data["email"];
        });
      }
    });

    // then((snapshot) {
    //   if (snapshot.data["name"] != null) {
    //     setState(() {
    //       this.name = snapshot.data["name"];
    //     });
    //   }
    //   if (snapshot.data["profileImageUrl"] != null) {
    //     setState(() {
    //       this.profileImageUrl = snapshot.data["profileImageUrl"];
    //     });
    //   }
    //   if (snapshot.data["email"] != null) {
    //     setState(() {
    //       this.email = snapshot.data["email"];
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0xFFF6a09a),
            //     Color(0xFF9a1f1d),
            //   ],
            //   stops: [0, 0.5],
            // ),
          ),
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                margin: EdgeInsets.only(top: 3, left: 3, right: 2),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(.5),
                        blurRadius: 5,
                        offset: Offset(-3, 0),
                      ),
                      BoxShadow(
                        color: Colors.red.withOpacity(.5),
                        blurRadius: 5,
                        offset: Offset(-3, 0),
                      ),
                      // BoxShadow(
                      //   color: Colors.red.withOpacity(.5),
                      //   blurRadius: 5,
                      //   offset: Offset(0, 5),
                      // ),
                      // BoxShadow(
                      //   color: Colors.red.withOpacity(.5),
                      //   blurRadius: 5,
                      //   offset: Offset(0, 5),
                      // ),
                    ]),
                accountName: Text(
                    name.isNotEmpty ? name : "You must edit your profile..."),
                accountEmail: Text(
                    email.isNotEmpty ? email : "You must edit your profile..."),
                currentAccountPicture: profileImageUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profileImageUrl),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.red[900],
                        child: Text(
                          name.isNotEmpty
                              ? name.split(' ')[0].substring(0, 1) +
                                  name.split(' ')[1].substring(0, 1)
                              : "NN",
                          style: TextStyle(
                              color: Colors.grey[200],
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              userId: cUserUid,
                            ),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.all(8),
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[800],
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          letterSpacing: 1,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: 8,
                      endIndent: 10,
                      color: Colors.white54,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LibraryPage(
                              userId: cUserUid,
                            ),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.all(8),
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[800],
                        child: Icon(
                          Icons.playlist_play,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Playlists",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          letterSpacing: 1,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: 8,
                      endIndent: 10,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  centerTitle: true,
                  // pinned: true,
                  // stretch: true,
                  // floating: true,
                  // snap: true,
                  title: Text("MusicApp"),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        AuthService().signOut();
                      },
                      child: Icon(Icons.exit_to_app),
                    ),
                  ],
                )
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF6a09a),
                    Color(0xFF9a1f1d),
                  ],
                  stops: [0, 0.5],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  PageView(
                    controller: _pageController,
                    onPageChanged: (pageIndex) {
                      setState(() {
                        _selectedIndex = pageIndex;
                      });
                    },
                    children: <Widget>[
                      cUserUid.isEmpty
                          ? CircularProgressIndicator()
                          : HomePage(
                              userId: cUserUid,
                            ),
                      ExplorePage(
                        userId: cUserUid,
                        userPhone: cUserPhone,
                        profileImgUrl: profileImageUrl,
                      ),
                      LikedSongs(
                        userId: cUserUid,
                        userPhone: cUserPhone,
                      ),
                      LibraryPage(
                        userId: cUserUid,
                        profileImgUrl: profileImageUrl,
                      ),
                    ],
                  ),
                  visible ? buildMakeBottomBar() : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMakeBottomBar() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: onTapArrow == false ? 45 : 35,
          left: onTapArrow == false
              ? (MediaQuery.of(context).size.width / 2) - 20
              : 5,
          right: onTapArrow == false
              ? (MediaQuery.of(context).size.width / 2) - 20
              : 5,
          child: makePlayingSongBar(tag: cUserUid),
        ),
        Positioned(
          bottom: 2,
          left: 5,
          right: 5,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 1),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(.3),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: Offset(0, 2))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: _selectedIndex == 0
                        ? Colors.white.withOpacity(1)
                        : Colors.white.withOpacity(.5),
                    size: _selectedIndex == 0 ? 32 : 25,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    _pageController.jumpToPage(_selectedIndex);
                  },
                ),
                IconButton(
                    icon: Icon(
                      Icons.explore,
                      color: _selectedIndex == 1
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(.5),
                      size: _selectedIndex == 1 ? 32 : 25,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      _pageController.jumpToPage(_selectedIndex);
                    }),
                IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: _selectedIndex == 2
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(.5),
                      size: _selectedIndex == 2 ? 32 : 25,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      _pageController.jumpToPage(_selectedIndex);
                    }),
                IconButton(
                    icon: Icon(
                      Icons.library_music,
                      color: _selectedIndex == 3
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(.5),
                      size: _selectedIndex == 3 ? 32 : 25,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                      _pageController.jumpToPage(_selectedIndex);
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget makePlayingSongBar({tag}) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () {
          if (onTapArrow == true) {
            setState(() {
              onTapArrow = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MusicPage(
                  tag: tag,
                  docId: docId,
                  pNowId: true,
                  profileImgUrl: profileImageUrl,
                ),
              ),
            );
          }
        },
        onVerticalDragEnd: (DragEndDetails details) {
          if (details.velocity.pixelsPerSecond.dy < 0 && onTapArrow == true) {
            setState(() {
              onTapArrow = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MusicPage(
                  tag: tag,
                  docId: docId,
                  pNowId: true,
                  profileImgUrl: profileImageUrl,
                ),
              ),
            );
          } else if (details.velocity.pixelsPerSecond.dy > 0 &&
              onTapArrow == true) {
            setState(() {
              onTapArrow = false;
            });
          }
        },
        child: Material(
          color: Colors.transparent, //yoksa arkasında cercevesi görünüyordu
          child: AnimatedContainer(
            curve: Curves.bounceOut,
            duration: Duration(milliseconds: 500),
            height: onTapArrow == false ? 40 : 80,
            decoration: BoxDecoration(
                color: Colors.red[800],
                borderRadius: onTapArrow == false
                    ? BorderRadius.circular(50)
                    : BorderRadius.vertical(
                        top: Radius.circular(40),
                        // bottom: Radius.circular(300),
                      )
                // shape: BoxShape.circle,
                ),
            child: onTapArrow == false
                ? Transform.translate(
                    offset: Offset(0, -7),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          onTapArrow = true;
                        });
                      },
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        top: 5, left: 40, right: 35, bottom: 30),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.pause,
                                  color: Colors.grey[800],
                                  size: 26,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 13.5),
                                  child: StreamBuilder(
                                      stream: _firestore
                                          .collection("users")
                                          .document(cUserUid)
                                          .collection("playingNow")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Text(
                                              "LOADING...",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }

                                        return ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: snapshot.data.documents
                                              .map(
                                                (doc) => FutureBuilder(
                                                    future: _firestore
                                                        .collection("songs")
                                                        .document(
                                                            doc["musicId"])
                                                        .get(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot>
                                                            snapshot) {
                                                      docId = doc["musicId"];
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                            child: Text(
                                                                'Error: ${snapshot.error}'));
                                                      }
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                      return Row(
                                                        children: <Widget>[
                                                          Text(
                                                              snapshot
                                                                  .data["name"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "-",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                              snapshot.data[
                                                                  "artist"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200))
                                                        ],
                                                      );
                                                    }),
                                              )
                                              .toList(),
                                          // children: <Widget>[
                                          //   Text("",
                                          //       style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight:
                                          //               FontWeight.w500)),
                                          //   SizedBox(
                                          //     width: 3,
                                          //   ),
                                          //   Text(
                                          //     "-",
                                          //     style: TextStyle(
                                          //         color: Colors.white70),
                                          //   ),
                                          //   SizedBox(
                                          //     width: 3,
                                          //   ),
                                          //   Text("Halsey",
                                          //       style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight:
                                          //               FontWeight.w200))
                                          // ],
                                        );
                                      }),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.playlist_play,
                                size: 20,
                                color: Colors.grey[400],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Playing Now",
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
