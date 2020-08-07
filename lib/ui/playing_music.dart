import 'dart:async';
import 'dart:math';
// import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp_flutter/core/services/authservice.dart';
// import 'package:musicapp_flutter/models/musicmodel.dart';
import 'package:audioplayer/audioplayer.dart';
// import 'package:http/http.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class MusicPage extends StatefulWidget {
  final String tag;
  final String docId;
  final bool pNowId;
  final String profileImgUrl;

  const MusicPage(
      {Key key, this.tag, this.docId, this.pNowId, this.profileImgUrl})
      : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;
  TextEditingController _editingController = new TextEditingController();
  bool chatStateActive = false;
  Firestore ref = Firestore.instance;
  var membersCount = 0;

  PlayerState playerState;

  String imgUrl, artist, cUserUid, cUserPhone, title, downloadUrl;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    getMusicDatas();
    getCurrentInfo();
    // updateUserProfileImage();
    initAudioPlayer();
    getPlayingState();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    // audioPlayer.stop();
    super.dispose();
  }

  // Future<String> getUserProfileImage(String userId) async {
  //   DocumentSnapshot documentSnapshot =
  //       await ref.collection("users").document(userId).get();
  //   if (documentSnapshot.data["profileImageUrl"] != null) {
  //     return documentSnapshot.data["profileImageUrl"];
  //   } else
  //     return null;
  // }

  Future<void> getCurrentInfo() async {
    var user = await AuthService().getCurrentUser();
    setState(() {
      this.cUserUid = user.uid;
      this.cUserPhone = user.phoneNumber;
    });
  }

//
  // Future<void> updateUserProfileImage() async {
  //   await getCurrentInfo();
  //   await ref
  //       .collection("conversation")
  //       .document(widget.docId)
  //       .collection("messages")
  //       .where("senderId", isEqualTo: cUserUid)
  //       .getDocuments()
  //       .then((value) {
  //     value.documents.forEach((doc) {
  //       print(doc.documentID);
  //       // ref
  //       //     .collection("conversations")
  //       //     .document(widget.docId)
  //       //     .collection("messages")
  //       //     .document(doc.documentID)
  //       //     .updateData({
  //       //   "profileImgUrl": widget.profileImgUrl,
  //       // });
  //     });
  //   });
  // }

//
  Future<void> getMusicDatas() async {
    await ref.collection("songs").document(widget.docId).get().then((value) {
      value.data.forEach((key, value) {
        if (key == "name") {
          setState(() {
            this.title = value;
          });
        }
        if (key == "downloadUrl") {
          setState(() {
            this.downloadUrl = value;
          });
        }
        if (key == "artist") {
          setState(() {
            this.artist = value;
          });
        }
        if (key == "imgUrl") {
          setState(() {
            this.imgUrl = value;
          });
        }
      });
    });
  }

//
  // int getMembersCount() {
  //   _membersStateSubscription = ref
  //       .collection("conversations")
  //       .document(widget.docId)
  //       .snapshots()
  //       .listen((event) {
  //     List members = event.data["members"];
  //     setState(() {
  //       membersCount = members.length;
  //     });
  //   });
  //   return membersCount;
  // }

//
  Future<void> getPlayingState() async {
    await getCurrentInfo();
    await ref
        .collection("users")
        .document(cUserUid)
        .collection("playingNow")
        .document("playingMusicDatas")
        .get()
        .then((value) {
      value.data.forEach((key, value) async {
        if (widget.pNowId == false) {
          stop();
          play();
        } else if (widget.pNowId == true) {
          if (key == "playing") {
            if (value == "playing") {
              setState(() {
                playerState = PlayerState.playing;
              });
            } else if (value == "paused") {
              setState(() {
                playerState = PlayerState.paused;
              });
            } else if (value == "stopped") {
              setState(() {
                playerState = PlayerState.stopped;
              });
            }
          }
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

//
  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(downloadUrl);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  //indirme işlemleri...
  // Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
  //   Uint8List bytes;
  //   try {
  //     bytes = await readBytes(url);
  //   } on ClientException {
  //     rethrow;
  //   }
  //   return bytes;
  // }

  // Future _loadFile() async {
  //   final bytes = await _loadFileBytes(kUrl,
  //       onError: (Exception exception) =>
  //           print('_loadFile => exception $exception'));

  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');

  //   await file.writeAsBytes(bytes);
  //   if (await file.exists())
  //     setState(() {
  //       localFilePath = file.path;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.tag,
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  /*  Color(0xFFE3BDE5),
                  Color(0xFFED765E), */
                  Color(0xFFF6a09a),
                  Color(0xFF9a1f1d),
                  /*  Color(0xFFe65758),
                  Color(0xFf771d32), */
                ],
                stops: [0, 0.5],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Transform.rotate(
                                    angle: -pi / 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Now Playing",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFF6a09a),
                                    Color(0xFF9a1f1d),
                                  ],
                                  stops: [0, 0.6],
                                ),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.9),
                                    spreadRadius: 5,
                                    blurRadius: 21,
                                    offset: Offset(14, 14),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(.6),
                                    spreadRadius: -1,
                                    blurRadius: 21,
                                    offset: Offset(-5, -5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: imgUrl == null
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Image.network(
                                          imgUrl,
                                          fit: BoxFit.cover,
                                          width: 280,
                                          alignment: Alignment.bottomLeft,
                                        )),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite_border,
                                          color: Colors.white70,
                                        ),
                                        Expanded(
                                          //burada yazılar kayan hale getirilecek.
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              title == null
                                                  ? CircularProgressIndicator()
                                                  : Text(
                                                      title,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              artist == null
                                                  ? CircularProgressIndicator()
                                                  : Text(
                                                      artist,
                                                      style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.queue_music,
                                          color: Colors.white70,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (duration != null)
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 3,
                                      ),
                                      child: Slider(
                                        value: position?.inMilliseconds
                                                ?.toDouble() ??
                                            0.0,
                                        activeColor:
                                            Color.fromRGBO(255, 255, 255, .9),
                                        inactiveColor:
                                            Color.fromRGBO(220, 220, 222, .2),
                                        onChanged: (double value) {
                                          return audioPlayer.seek(
                                              (value / 1000).roundToDouble());
                                        },
                                        min: 0.0,
                                        max: duration.inMilliseconds.toDouble(),
                                      ),
                                    ),
                                  Transform.translate(
                                    offset: Offset(0, -3),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            positionText != null
                                                ? "${positionText ?? ''}"
                                                : "0.00",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            positionText != null
                                                ? "${durationText ?? ''}"
                                                : "0.00",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            ref
                                                .collection("users")
                                                .document(cUserUid)
                                                .collection("playingNow")
                                                .document("playingMusicDatas")
                                                .updateData(
                                                    {"playing": "stopped"});
                                            stop();
                                          },
                                          child: Icon(
                                            Icons.stop,
                                            color: Colors.white70,
                                            size: 25,
                                          ),
                                        ),
                                        Icon(
                                          Icons.skip_previous,
                                          color: Colors.white70,
                                          size: 35,
                                        ),
                                        if (playerState == PlayerState.paused ||
                                            playerState == PlayerState.stopped)
                                          InkWell(
                                            onTap: isPlaying
                                                ? null
                                                : () {
                                                    ref
                                                        .collection("users")
                                                        .document(cUserUid)
                                                        .collection(
                                                            "playingNow")
                                                        .document(
                                                            "playingMusicDatas")
                                                        .updateData({
                                                      "playing": "playing"
                                                    });
                                                    play();
                                                  },
                                            // ref
                                            //     .collection("songs")
                                            //     .getDocuments().then((value) {
                                            //       value.documents.forEach((f) {
                                            //         print('${f.documentID}');
                                            //       });
                                            //     });

                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        if (playerState == PlayerState.playing)
                                          InkWell(
                                            onTap: isPlaying
                                                ? () {
                                                    ref
                                                        .collection("users")
                                                        .document(cUserUid)
                                                        .collection(
                                                            "playingNow")
                                                        .document(
                                                            "playingMusicDatas")
                                                        .updateData({
                                                      "playing": "paused"
                                                    });
                                                    pause();
                                                  }
                                                : null,
                                            //
                                            child: Icon(
                                              Icons.pause,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        Icon(
                                          Icons.skip_next,
                                          color: Colors.white70,
                                          size: 35,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.shuffle,
                                            color: Colors.white70,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //positined düzenlenecek istediğim gibi değil içi
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onVerticalDragEnd: (DragEndDetails details) {
                        if (details.velocity.pixelsPerSecond.dy < 0) {
                          _positionSubscription.pause();
                          setState(() {
                            chatStateActive = true;
                          });
                        } else if (details.velocity.pixelsPerSecond.dy > 0) {
                          setState(() {
                            chatStateActive = false;
                          });
                        }
                      },
                      onTap: () {
                        if (chatStateActive == false) {
                          _positionSubscription.pause();
                          setState(() {
                            chatStateActive = true;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        height: chatStateActive == false ? 60 : 450,
                        decoration: BoxDecoration(
                          color: chatStateActive == false
                              ? Colors.black.withOpacity(.7)
                              : Colors.black,
                          borderRadius: chatStateActive == false
                              ? BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                )
                              : BorderRadius.vertical(
                                  top: Radius.circular(20),
                                  // bottom: Radius.circular(20),
                                ),
                        ),
                        child: chatStateActive == false
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.chat,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: VerticalDivider(
                                        width: 2,
                                        color: Colors.white30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Chat Page ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_drop_up,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              )
                            : NestedScrollView(
                                headerSliverBuilder: (BuildContext context,
                                    bool innerBoxIsScrolled) {
                                  return [
                                    SliverAppBar(
                                      backgroundColor: Colors.grey[600],
                                      automaticallyImplyLeading: false,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.people),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(" Active"),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              _positionSubscription.resume();
                                              setState(() {
                                                chatStateActive = false;
                                              });
                                            },
                                            child: Icon(Icons.arrow_downward)),
                                        SizedBox(
                                          width: 13,
                                        )
                                      ],
                                      floating: true,
                                      expandedHeight: 60,
                                    ),
                                  ];
                                },
                                body: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: StreamBuilder(
                                          stream: ref
                                              .collection("conversations")
                                              .document(widget.docId)
                                              .collection("messages")
                                              .orderBy('date')
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
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            return ListView(
                                              children: snapshot.data.documents
                                                  .map(
                                                    (doc) => ListTile(
                                                      dense: true,
                                                      leading: cUserUid !=
                                                              doc["senderId"]
                                                          ? CircleAvatar(
                                                              backgroundImage: doc[
                                                                          "profileImgUrl"] !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      doc["profileImgUrl"])
                                                                  : null,
                                                              backgroundColor:
                                                                  Colors
                                                                      .red[800],
                                                              child:
                                                                  doc["profileImgUrl"] ==
                                                                          null
                                                                      ? Text(
                                                                          "SY")
                                                                      : null,
                                                            )
                                                          : null,
                                                      title: Align(
                                                        alignment: cUserUid !=
                                                                doc["senderId"]
                                                            ? Alignment
                                                                .centerLeft
                                                            : Alignment
                                                                .centerRight,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[700],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Text(
                                                            doc["message"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: cUserUid ==
                                                              doc["senderId"]
                                                          ? CircleAvatar(
                                                              backgroundImage: doc[
                                                                          "profileImgUrl"] !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      doc["profileImgUrl"])
                                                                  : null,
                                                              backgroundColor:
                                                                  Colors
                                                                      .red[800],
                                                              child:
                                                                  doc["profileImgUrl"] ==
                                                                          null
                                                                      ? Text(
                                                                          "SY")
                                                                      : null,
                                                            )
                                                          : null,
                                                    ),
                                                  )
                                                  .toList(),
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.tag_faces,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          _editingController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Type a message",
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[700],
                                            ),
                                            child: IconButton(
                                              icon: Center(
                                                child: Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (widget
                                                    .profileImgUrl.isEmpty) {
                                                  await ref
                                                      .collection(
                                                          "conversations")
                                                      .document(widget.docId)
                                                      .collection("messages")
                                                      .add({
                                                    'senderId': cUserUid,
                                                    'message':
                                                        _editingController.text,
                                                    'date': DateTime.now(),
                                                  });
                                                  _editingController.text = '';
                                                } else {
                                                  await ref
                                                      .collection(
                                                          "conversations")
                                                      .document(widget.docId)
                                                      .collection("messages")
                                                      .add({
                                                    'profileImgUrl':
                                                        widget.profileImgUrl,
                                                    'senderId': cUserUid,
                                                    'message':
                                                        _editingController.text,
                                                    'date': DateTime.now(),
                                                  });
                                                  _editingController.text = '';
                                                }
                                              },
                                            ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
