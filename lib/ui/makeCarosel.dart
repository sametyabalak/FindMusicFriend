import 'package:flutter/material.dart';

class MakeCarosel extends StatefulWidget {
  @override
  _MakeCaroselState createState() => _MakeCaroselState();
}

class _MakeCaroselState extends State<MakeCarosel> {
  final List<List<String>> products = [
    ["assets/images/music1.jpg", "Halsey", "listen again"],
    ["assets/images/music2.jpg", "Dua Lipa", "listen again"],
    ["assets/images/music3.jpg", "Tarkan", "listen again"],
  ];
  int currentIndex = 0;

  void _next() {
    setState(() {
      if (currentIndex < products.length - 1) {
        currentIndex++;
      } else {
        currentIndex = currentIndex;
      }
    });
  }

  void _preve() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _preve();
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          _next();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.6),
                  blurRadius: 2,
                  spreadRadius: .1,
                  offset: Offset(2, 2))
            ],
            image: DecorationImage(
                image: AssetImage(products[currentIndex][0]),
                fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.9),
                  Colors.grey.withOpacity(.1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 60,
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: _buildIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return Expanded(
      child: Container(
        height: 5,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < products.length; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
}
