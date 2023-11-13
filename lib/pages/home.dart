import 'package:Yize_Notes/components/routes.dart';
import 'package:Yize_Notes/services/CRUD/note_service.dart';
import 'package:Yize_Notes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum MenuAction { logOut }

class _HomeState extends State<Home> {
  late final NotesService _notesService;
  final user = AuthService.firebase().currentUser;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          leading: const Icon(Icons.menu),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(newNotes);
              }, 
              icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logOut:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logOut,
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
            
          ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes, 
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {                     
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Center(child: Text('waiting for all notes'),);                 
                      default:
                        return const CircularProgressIndicator();
                    }
                  },);
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are You Sure ?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
