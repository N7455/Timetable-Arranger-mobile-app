import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> col(String name) =>
      db.collection('users').doc(uid).collection(name);

  Future<void> addItem(String collection, Map<String, dynamic> data) async {
    await col(collection).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String collection) {
    return col(collection).orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> deleteItem(String collection, String id) {
    return col(collection).doc(id).delete();
  }
}
