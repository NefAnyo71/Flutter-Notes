import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import '../widgets/safe_delete_dialog.dart';
import 'note_detail_screen.dart';
import 'settings_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final CollectionReference _notesCollection = FirebaseFirestore.instance
      .collection('notes');
  final CollectionReference _archiveCollection = FirebaseFirestore.instance
      .collection('deleted_notes');

  Future<void> _archiveAndDeleteNote(Note note) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(_archiveCollection.doc(), note.toArchive());
        transaction.delete(_notesCollection.doc(note.id));
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${note.title}" notu başarıyla silindi ve arşivlendi.',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not silinirken bir hata oluştu: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _showSafeDeleteDialog(Note note) async {
    int confirmationCount = 0;
    bool? finalResult;

    while (confirmationCount < 3 && finalResult == null) {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SafeDeleteDialog(
            note: note,
            confirmationNumber: confirmationCount + 1,
            totalConfirmations: 3,
          );
        },
      );

      if (result == true) {
        confirmationCount++;
      } else {
        finalResult = false;
        break;
      }
    }

    if (confirmationCount == 3) {
      finalResult = true;
    }

    if (finalResult == true && mounted) {
      await _archiveAndDeleteNote(note);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silme işlemi iptal edildi'),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: 'Ayarlar',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notesCollection
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                strokeWidth: 4,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Veritabanı bağlantı hatası: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Henüz not eklenmemiş.\nİlk notunuzu eklemek için\naşağıdaki butona dokunun.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final notes = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = Note.fromFirestore(notes[index]);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: NoteCard(
                  note: note,
                  onDelete: _showSafeDeleteDialog,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(note: note),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteDetailScreen()),
          );
        },
        icon: const Icon(Icons.add, size: 30),
        label: const Text(
          'YENİ NOT EKLE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}