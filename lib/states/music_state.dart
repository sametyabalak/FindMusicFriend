import 'package:musicapp_flutter/models/musicmodel.dart';

class MusicState {
  List<MusicModel> _musics = [
    MusicModel("Manic", "Halsey", "assets/images/music1.jpg"),
    MusicModel("Future Nostalgia", "Dua Lipa", "assets/images/music2.jpg"),
    MusicModel("Her Şey Fani", "Tarkan", "assets/images/music3.jpg"),
    MusicModel("Manic", "Halsey", "assets/images/music1.jpg"),
    MusicModel("Future Nostalgia", "Dua Lipa", "assets/images/music2.jpg"),
    MusicModel("Her Şey Fani", "Tarkan", "assets/images/music3.jpg"),
  ];

  List<MusicModel> get musics => _musics;
}
