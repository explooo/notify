import 'package:flutter/material.dart';
import '../database_helper.dart';

class NoteEditingScreen extends StatefulWidget {
  NoteEditingScreen({Key? key, required this.note}) : super(key: key);
  final Map<String, dynamic> note;

  @override
  State<NoteEditingScreen> createState() => _NoteEditingScreenState();
}

class _NoteEditingScreenState extends State<NoteEditingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _contentController = TextEditingController(text: widget.note['content']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void _saveChanges() async {
    if (widget.note.containsKey('_id')) {
      int rowsAffected = await DatabaseHelper.instance.updateNote(
        widget.note['_id'],
        _titleController.text,
        _contentController.text,
        
      );
      if (rowsAffected == 1) {
        // The note was updated successfully
        // Navigator.pop(context);
      } else {
        // An error occurred

      }
    } else {
      // The note is new, insert it
      int id = await DatabaseHelper.instance.saveNote(
        _titleController.text,
        _contentController.text,
      );
      if (id != 0) {
        // The note was inserted successfully
        // Navigator.pop(context);
      } else {
        // An error occurred
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              _saveChanges();
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 0.0, // remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
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
