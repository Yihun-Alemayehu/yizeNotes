import 'package:Yize_Notes/components/dialogs/delete_dialog.dart';
import 'package:Yize_Notes/services/CRUD/note_service.dart';
import 'package:flutter/material.dart';

typedef DeleteNoteCallBack = void Function(DatabaseNotes notes);

class NotesList extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final DeleteNoteCallBack onDeleteNote;
  const NotesList({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async{
                final shouldDelete = await showDeleteDialog(context);
                if(shouldDelete){
                  onDeleteNote(note);
                }
              }, 
             icon: const Icon(Icons.delete)),
          );
        });
  }
}
