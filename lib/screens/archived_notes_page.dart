import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ArchivedNotesPage extends StatelessWidget {
  const ArchivedNotesPage({super.key});

  Future<void> _restoreNote(BuildContext context, Map<String, dynamic> archivedNote, String docId) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          FirebaseFirestore.instance.collection('notes').doc(),
          {
            'title': archivedNote['title'],
            'content': archivedNote['content'],
            'timestamp': archivedNote['originalTimestamp'] ?? FieldValue.serverTimestamp(),
          },
        );
        transaction.delete(
          FirebaseFirestore.instance.collection('deleted_notes').doc(docId),
        );
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${archivedNote['title']}" notu başarıyla geri getirildi!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not geri getirilirken hata oluştu: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Silinen Notlar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deleted_notes')
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
                    Icons.delete_sweep_outlined,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Arşivlenmiş not bulunmuyor.\n\nSilinen notlar burada görünecek.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final archivedNotes = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: archivedNotes.length,
            itemBuilder: (context, index) {
              final doc = archivedNotes[index];
              final data = doc.data() as Map<String, dynamic>;
              
              final String formattedDeleteDate;
              if (data['deletedAt'] != null) {
                formattedDeleteDate = DateFormat('dd.MM.yyyy - HH:mm')
                    .format((data['deletedAt'] as Timestamp).toDate());
              } else {
                formattedDeleteDate = 'Tarih yok';
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 4,
                  color: Colors.blueGrey[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? 'Başlıksız',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Colors.orange[300],
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(
                          height: 25,
                          thickness: 1,
                          color: Colors.white10,
                        ),
                        Text(
                          data['content'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white60,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Silinme: $formattedDeleteDate',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _restoreNote(context, data, doc.id),
                            icon: const Icon(Icons.restore, size: 24),
                            label: const Text(
                              'Geri Getir',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}