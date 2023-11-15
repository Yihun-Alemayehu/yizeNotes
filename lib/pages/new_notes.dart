import 'package:Yize_Notes/services/CRUD/note_service.dart';
import 'package:Yize_Notes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class NewNotes extends StatefulWidget {
  const NewNotes({super.key});

  @override
  State<NewNotes> createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textEditingControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final text = _textEditingController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }
  void _setupTextEditingControllerListener() {
    _textEditingController.removeListener(_textEditingControllerListener);
    _textEditingController.removeListener(_textEditingControllerListener);
  }

  Future<DatabaseNotes> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Notes'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: createNewNote(), 
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
            _note = snapshot.data;
            _setupTextEditingControllerListener();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Write a note here ...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
      },)
    );
  }
}
