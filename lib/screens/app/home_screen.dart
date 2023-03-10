import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:qatar_data_app/models/process_response.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/note_provider.dart';
import 'package:qatar_data_app/screens/app/note_screen.dart';
import 'package:qatar_data_app/screens/app/resident_details_screen.dart';
import 'package:qatar_data_app/screens/app/resident_home_screen.dart';
import 'package:qatar_data_app/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Helpers {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NoteProvider>(context, listen: false).read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff205375),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green),
        title: Text(
          'population',
          style: GoogleFonts.nunito(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _logout();
            },
            icon: const Icon(Icons.logout,color: Colors.white),
          ),

        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, NoteProvider noteProvider, child) {
          if (noteProvider.notes.isNotEmpty) {
            return ListView.builder(
                itemCount: noteProvider.notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(
                            note: noteProvider.notes[index],
                          ),
                        ),
                      );
                    },
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResidentHomeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.details,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(noteProvider.notes[index].title),
                    subtitle: Text(noteProvider.notes[index].info),
                    trailing: IconButton(
                      onPressed: () async => await deleteNote(index: index),
                      icon: const Icon(Icons.delete),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text(
                'NO DATA',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xff205375),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await SharedPrefController().logout();
    //Home, Settings (Logout) PushReplacement(Login)
    //Home, Login
    //A => B => C => D
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/D', (route) => route.settings.name == 'A');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login_screen', (route) => false);
  }

  Future<void> deleteNote({required int index}) async {
    ProcessResponse processResponse =
        await Provider.of<NoteProvider>(context, listen: false)
            .delete(index: index);
    showSnackBar(context,
        message: processResponse.message, error: !processResponse.success);
  }
}
