import 'package:flutter/material.dart';
import '../database_helper.dart';

class NoteEditingScreen extends StatelessWidget {
  NoteEditingScreen({Key? key}) : super(key: key);
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              int id = await DatabaseHelper.instance.saveNote(
                titleController.text,
                contentController.text,
              );
              print('Saved note with id: $id');
            },
          ),
        ],
        elevation: 0.0, // remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: contentController,
          decoration: InputDecoration(
            hintText: 'Note',
            border: InputBorder.none,
          ),
          maxLines: null, // allow multiple lines
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.push_pin_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add_alert_outlined),
              onPressed: () {},
            ),
            // add more IconButton's for other actions
          ],
        ),
      ),
    );
  }
}
