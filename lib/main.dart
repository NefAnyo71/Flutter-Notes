import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:not_tut/screens/note_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kolay Not Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
          primary: Colors.amber[600]!,
          onPrimary: Colors.black,
          secondary: Colors.blueGrey[600],
          onSecondary: Colors.white,
          surface: Colors.blueGrey[700],
          onSurface: Colors.white,
          background: Colors.blueGrey[900],
          onBackground: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.blueGrey[900],

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800],
          elevation: 1,
          titleTextStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          centerTitle: true,
        ),

        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber[600],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          extendedSizeConstraints: const BoxConstraints.tightFor(
            height: 60,
            width: 200,
          ),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blueGrey[800]!.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[600]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[600]!, width: 2.5),
          ),
          labelStyle: TextStyle(color: Colors.amber[300], fontSize: 20),
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
      home: const NoteListPage(),
    );
  }
}
