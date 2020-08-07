import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikedSongs extends StatefulWidget {
  final String userId;
  final String userPhone;

  const LikedSongs({Key key, this.userId, this.userPhone}) : super(key: key);
  @override
  _LikedSongsState createState() => _LikedSongsState();
}

class _LikedSongsState extends State<LikedSongs> {
  @override
  void initState() {
    super.initState();
    // getCurrentInfo();
  }

  Stream<Widget> createListTile() async* {}

  // Future<void> getCurrentInfo() async {
  //   var user = await AuthService().getCurrentUser();
  //   setState(() {
  //     this.cUserUid = user.uid;
  //     this.cUserPhone = user.phoneNumber;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
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
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("songs")
              .where('favoriteUsers', arrayContains: widget.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            try {
              if (snapshot.data.documents.isEmpty) {
                return Center(child: Text('Henüz hiç müzik beğenmediniz'));
              }
            } catch (e) {
              // print(e.toString());
            }
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
                      trailing: InkWell(
                          onTap: () {
                            //
                          },
                          child: Icon(Icons.play_arrow)),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
