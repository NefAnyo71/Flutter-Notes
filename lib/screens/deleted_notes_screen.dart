import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/deleted_note.dart';
import '../widgets/deleted_note_card.dart';

// Silinen Notlar Ekranı
class DeletedNotesScreen extends StatefulWidget {
  const DeletedNotesScreen({super.key});

  @override
  State<DeletedNotesScreen> createState() => _DeletedNotesScreenState();
}

class _DeletedNotesScreenState extends State<DeletedNotesScreen> {
  final CollectionReference _deletedNotesCollection = FirebaseFirestore.instance
      .collection('deleted_notes');
  final CollectionReference _notesCollection = FirebaseFirestore.instance
      .collection('notes');

  Future<void> _restoreNote(DeletedNote deletedNote) async {
    bool? shouldRestore = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Notu Geri Getir',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bu notu geri getirmek istediğinizden emin misiniz?\n\n"${deletedNote.title}"',
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'İPTAL',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'GERİ GETİR',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (shouldRestore == true) {
      try {
        await _notesCollection.add({
          'title': deletedNote.title,
          'content': deletedNote.content,
          // İSTEK ÜZERİNE DÜZENLEME: Notu geri getirirken her zaman yeni bir zaman damgası kullan.
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (deletedNote.id != null) {
          await _deletedNotesCollection.doc(deletedNote.id!).delete();
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Not başarıyla geri getirildi!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Not geri getirilirken hata oluştu: $e',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        title: const Text('Silinen Notlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _deletedNotesCollection
            .orderBy('deletedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Hata: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange[200]!, width: 2),
                    ),
                    child: Icon(
                      Icons.delete_sweep_outlined,
                      size: 80,
                      color: Colors.orange[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Silinen not bulunamadı',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz hiçbir not silmediniz',
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          // HATA DÜZELTMESİ: 'if' bloğundan sonra bir 'else' bloğu eklenmeli.
          // Eğer silinmiş not varsa, bu blok çalışacak.
          else {
            final deletedNotes = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: deletedNotes.length,
              itemBuilder: (context, index) {
                try {
                  final deletedNote = DeletedNote.fromFirestore(
                    deletedNotes[index],
                  );
                  return DeletedNoteCard(
                    deletedNote: deletedNote,
                    onRestore: _restoreNote,
                  );
                } catch (e) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Veri okuma hatası: $e',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
