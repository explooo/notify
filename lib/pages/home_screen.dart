import 'package:flutter/material.dart';
import 'note_editing_screen.dart';
import '../database_helper.dart';
import 'package:animations/animations.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
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
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: selectedNotes,
          builder: (context, value, child) {
            if (value.isEmpty) {
              // No notes are selected, show the regular AppBar
              return AppBar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                title: const Text('Notify'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
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
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    selectedNotes.value = [];
                  },
                ),
                title: Text('${value.length} selected'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.archive),
                    onPressed: () {
                      // Archive the selected notes...
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: const Text('Drawer Header'),
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text(
                'Labels',
              ),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
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
            return const Center(child: CircularProgressIndicator());
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
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.0),
                              // color: Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            child: OpenContainer(
                              closedColor: Colors.transparent,
                              closedElevation: 0.0,
                              closedShape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              closedBuilder: (
                                BuildContext context,
                                VoidCallback openContainer,
                              ) {
                                return Card(
                                  elevation: 0.0,
                                  color: selectedNotes.value.any(
                                          (selectedNote) =>
                                              selectedNote['_id'] ==
                                              note['_id'])
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14.0),
                                    onLongPress: () {
                                      selectedNotes.value =
                                          List.from(selectedNotes.value)
                                            ..add(note);
                                    },
                                    onTap: () {
                                      if (selectedNotes.value.isNotEmpty) {
                                        // Some notes are already selected, add this note to the selected notes
                                        if (!selectedNotes.value.any(
                                            (selectedNote) =>
                                                selectedNote['_id'] ==
                                                note['_id'])) {
                                          selectedNotes.value =
                                              List.from(selectedNotes.value)
                                                ..add(note);
                                        } 
                                        }
                                     else {
                                        openContainer();
                                      }
                                    }
                                    ,
                                    child: Container(
                                      decoration: const BoxDecoration(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              note['title'],
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(note['content']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              openBuilder:
                                  (BuildContext context, VoidCallback _) {
                                return NoteEditingScreen(note: note);
                              },
                              transitionType: ContainerTransitionType.fade,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: const customFab(),
    );
  }
}

// ignore: camel_case_types
class customFab extends StatelessWidget {
  const customFab({
    super.key,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
        openBuilder: (context, _) => NoteEditingScreen(note: const {}),
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        // closedElevation: 6.0,
        closedColor: Theme.of(context).colorScheme.inversePrimary,
        // transitionDuration: Duration(milliseconds: 500),
        // transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, openContainer) => FloatingActionButton(
          onPressed: () {
            openContainer();
          },
          // backgroundColor: Colors.blue,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(Icons.add),
        ),
      );
}
