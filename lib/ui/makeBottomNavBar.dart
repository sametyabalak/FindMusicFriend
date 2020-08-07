// import 'package:flutter/material.dart';
// import 'package:musicapp_flutter/ui/playing_music.dart';

// class MakeBottomBar extends StatefulWidget {
//   final Function(int) onSelectedIndex;

//   MakeBottomBar({@required this.onSelectedIndex});

//   @override
//   _MakeBottomBarState createState() => _MakeBottomBarState();
// }

// class _MakeBottomBarState extends State<MakeBottomBar> {
//   bool onTapArrow = false;
//   int isSelected = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           bottom: onTapArrow == false ? 45 : 35,
//           left: onTapArrow == false
//               ? (MediaQuery.of(context).size.width / 2) - 20
//               : 5,
//           right: onTapArrow == false
//               ? (MediaQuery.of(context).size.width / 2) - 20
//               : 5,
//           child: makePlayingSongBar(tag: "music1"),
//         ),
//         Positioned(
//           bottom: 2,
//           left: 5,
//           right: 5,
//           child: Container(
//             height: 60,
//             decoration: BoxDecoration(
//                 color: Color.fromRGBO(0, 0, 0, 1),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.white.withOpacity(.3),
//                       blurRadius: 2,
//                       spreadRadius: 1,
//                       offset: Offset(0, 2))
//                 ]),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(
//                     Icons.home,
//                     color: isSelected == 0
//                         ? Colors.white.withOpacity(1)
//                         : Colors.white.withOpacity(.5),
//                     size: isSelected == 0 ? 32 : 25,
//                   ),
//                   onPressed: () {
//                     widget.onSelectedIndex(0);
//                     setState(() {
//                       isSelected = 0;
//                     });
//                   },
//                 ),
//                 IconButton(
//                     icon: Icon(
//                       Icons.search,
//                       color: isSelected == 1
//                           ? Colors.white.withOpacity(1)
//                           : Colors.white.withOpacity(.5),
//                       size: isSelected == 1 ? 32 : 25,
//                     ),
//                     onPressed: () {
//                       widget.onSelectedIndex(1);

//                       setState(() {
//                         isSelected = 1;
//                       });
//                     }),
//                 IconButton(
//                     icon: Icon(
//                       Icons.favorite,
//                       color: isSelected == 2
//                           ? Colors.white.withOpacity(1)
//                           : Colors.white.withOpacity(.5),
//                       size: isSelected == 2 ? 32 : 25,
//                     ),
//                     onPressed: () {
//                       widget.onSelectedIndex(2);

//                       setState(() {
//                         isSelected = 2;
//                       });
//                     }),
//                 IconButton(
//                     icon: Icon(
//                       Icons.library_music,
//                       color: isSelected == 3
//                           ? Colors.white.withOpacity(1)
//                           : Colors.white.withOpacity(.5),
//                       size: isSelected == 3 ? 32 : 25,
//                     ),
//                     onPressed: () {
//                       widget.onSelectedIndex(3);

//                       setState(() {
//                         isSelected = 3;
//                       });
//                     }),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget makePlayingSongBar({tag}) {
//     return Hero(
//       tag: tag,
//       child: GestureDetector(
//         onTap: () {
//           if (onTapArrow == true) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MusicPage(
//                   tag: tag,
//                 ),
//               ),
//             );
//           }
//         },
//         onVerticalDragEnd: (DragEndDetails details) {
//           if (details.velocity.pixelsPerSecond.dy < 0 && onTapArrow == true) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MusicPage(
//                   tag: tag,
//                 ),
//               ),
//             );
//           } else if (details.velocity.pixelsPerSecond.dy > 0 &&
//               onTapArrow == true) {
//             setState(() {
//               onTapArrow = false;
//             });
//           }
//         },
//         child: Material(
//           color: Colors.transparent, //yoksa arkasında cercevesi görünüyordu
//           child: AnimatedContainer(
//             curve: Curves.bounceOut,
//             duration: Duration(milliseconds: 500),
//             height: onTapArrow == false ? 40 : 80,
//             decoration: BoxDecoration(
//                 color: Colors.red[800],
//                 borderRadius: onTapArrow == false
//                     ? BorderRadius.circular(50)
//                     : BorderRadius.vertical(
//                         top: Radius.circular(40),
//                         // bottom: Radius.circular(300),
//                       )
//                 // shape: BoxShape.circle,
//                 ),
//             child: onTapArrow == false
//                 ? Transform.translate(
//                     offset: Offset(0, -7),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           onTapArrow = true;
//                         });
//                       },
//                       child: Icon(
//                         Icons.keyboard_arrow_up,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   )
//                 : Padding(
//                     padding: EdgeInsets.only(
//                         top: 5, left: 40, right: 35, bottom: 30),
//                     child: Container(
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Expanded(
//                             child: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.pause,
//                                   color: Colors.grey[800],
//                                   size: 26,
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Expanded(
//                                     child: Container(
//                                   margin: EdgeInsets.symmetric(vertical: 13.5),
//                                   child: ListView(
//                                     scrollDirection: Axis.horizontal,
//                                     children: <Widget>[
//                                       Text("Manic",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500)),
//                                       SizedBox(
//                                         width: 3,
//                                       ),
//                                       Text(
//                                         "-",
//                                         style: TextStyle(color: Colors.white70),
//                                       ),
//                                       SizedBox(
//                                         width: 3,
//                                       ),
//                                       Text("Halsey",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w200))
//                                     ],
//                                   ),
//                                 )),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Row(
//                             children: <Widget>[
//                               Icon(
//                                 Icons.playlist_play,
//                                 size: 20,
//                                 color: Colors.grey[400],
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 "Playing Now",
//                                 style: TextStyle(
//                                     color: Colors.grey[400],
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w300),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
