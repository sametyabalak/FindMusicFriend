import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<DocumentSnapshot> getLastPlayed() async* {
    
  }
}
