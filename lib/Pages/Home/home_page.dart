// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/Services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController noteController = TextEditingController();

  // open box to edit/add note
  void openBox({String? docId, String? currentNote}) {
    // Pré-remplir avec la note actuelle si c'est une modification
    if (currentNote != null) {
      noteController.text = currentNote;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? "Add Note" : "Edit Note"),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId == null) {
                firestoreService.addNote(noteController.text);
              } else {
                firestoreService.updateNote(docId, noteController.text);
              }
              noteController.clear();
              Navigator.pop(context);
            },
            child: Text(
              docId == null ? "Add" : "Update",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  // confirmation before deletion
  void confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Annuler la suppression
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.deleteNote(docId);
              Navigator.pop(context); // Confirmer et fermer le dialogue
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => openBox(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                // get individual docs
                DocumentSnapshot document = noteList[index];
                String docId = document.id;

                // get string of notes
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () =>
                            openBox(docId: docId, currentNote: noteText),
                        icon: Icon(Icons.settings),
                      ),
                      IconButton(
                        onPressed: () => confirmDelete(docId),
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text("No notes");
          }
        },
      ),
    );
  }
}
