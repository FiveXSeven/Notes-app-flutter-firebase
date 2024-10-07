import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get a collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  // CREATE

  Future<void> addNote(String note) {
    return notes.add({"note": note, "timestamp": Timestamp.now()});
  }

  // READ

  Stream<QuerySnapshot> getNotes() {
    final noteStream = notes.orderBy("timestamp", descending: true).snapshots();

    return noteStream;
  }

  // UPDATE

  Future<void> updateNote(String docId, String newNote) {
    return notes
        .doc(docId)
        .update({"note": newNote, "timestamp": Timestamp.now()});
  }

  // DELETE

  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
