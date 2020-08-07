class SongModel {
  String title;
  String artist;
  String imgUrl;
  String storageUrl;
  List<String> likedUsers;

  SongModel(
      this.title, this.artist, this.imgUrl, this.storageUrl, this.likedUsers);
}
