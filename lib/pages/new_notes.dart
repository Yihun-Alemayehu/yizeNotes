import 'package:flutter/material.dart';


class NewNotes extends StatefulWidget {
  const NewNotes({super.key});

  @override
  State<NewNotes> createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Notes'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Welcome to the new notes')),
    );
  }
}