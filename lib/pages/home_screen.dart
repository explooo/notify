import 'package:flutter/material.dart';
import 'note_editing_screen.dart';
import '../database_helper.dart';
import 'package:animations/animations.dart';
class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final selectedNotes = ValueNotifier<List<Map<String, dynamic>>>([]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: selectedNotes,
          builder: (context, value, child) {
            if (value.isEmpty) {
              // No notes are selected, show the regular AppBar
              return AppBar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                title: Text('Notify'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchBarDelegate(),
                      );
                    },
                  ),
                ],
              );
            } else {
              // Some notes are selected, show the custom AppBar
              return AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    selectedNotes.value = [];
                  },
                ),
                title: Text('${value.length} selected'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.archive),
                    onPressed: () {
                      // Archive the selected notes...
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      for (var note in selectedNotes.value) {
                        await DatabaseHelper.instance.delete(note['_id']);
                      }
                      selectedNotes.value = [];
                      // Delete the selected notes...
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Text(
                'Labels',
              ),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text('Archive'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: DatabaseHelper.instance.notesStream,
        builder: (context, snapshot) {
          print('StreamBuilder snapshot: $snapshot');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            
            return ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: selectedNotes,
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> note = snapshot.data![index];
                    return InkWell(
                      onLongPress: () {
                        selectedNotes.value = List.from(selectedNotes.value)
                          ..add(note);
                      },
                      onTap: () {
                        if (selectedNotes.value.isNotEmpty) {
                          // Some notes are already selected, add this note to the selected notes
                          if (!selectedNotes.value.any((selectedNote) =>
                              selectedNote['_id'] == note['_id'])) {
                            selectedNotes.value = List.from(selectedNotes.value)
                              ..add(note);
                          }
                        } else {
                          // No notes are selected, navigate to the NoteEditingScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteEditingScreen(note: note),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 4.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: ListTile(
                              tileColor: selectedNotes.value.any(
                                      (selectedNote) =>
                                          selectedNote['_id'] == note['_id'])
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : null,
                              title: Text(note['title']),
                              subtitle: Text(note['content']),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton:  customFab(),
    );
  }
}

class customFab extends StatelessWidget {
  const customFab({
    super.key,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
    openBuilder: (context, _) =>NoteEditingScreen(note: {}),
    closedShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    closedElevation: 6.0,
    closedColor: Theme.of(context).colorScheme.inversePrimary,
    // transitionDuration: Duration(milliseconds: 500),
    transitionType: ContainerTransitionType.fadeThrough,
    closedBuilder: (context, openContainer)=> FloatingActionButton(
        onPressed: () {
          openContainer();},
        child: const Icon(Icons.add),
        // backgroundColor: Colors.blue,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
     
    ),
  
  );
}