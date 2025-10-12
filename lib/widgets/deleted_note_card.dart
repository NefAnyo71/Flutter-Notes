import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/deleted_note.dart';

// Silinen Not Kartı
class DeletedNoteCard extends StatelessWidget {
  final DeletedNote deletedNote;
  final Function(DeletedNote) onRestore;

  const DeletedNoteCard({
    super.key,
    required this.deletedNote,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final String deletedDate;
    final String originalDate;

    if (deletedNote.deletedAt != null) {
      deletedDate = DateFormat(
        'dd MMMM yyyy, HH:mm',
      ).format(deletedNote.deletedAt!.toDate());
    } else {
      deletedDate = 'Bilinmiyor';
    }

    // HATA DÜZELTMESİ: originalTimestamp null olsa bile uygulamanın çökmemesi için kontrol eklendi.
    if (deletedNote.originalTimestamp != null) {
      originalDate = DateFormat(
        'dd MMMM yyyy',
      ).format(deletedNote.originalTimestamp!.toDate());
    } else {
      originalDate = 'Bilinmiyor';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.orange[50]!, Colors.orange[100]!],
            ),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        deletedNote.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.restore,
                          color: Colors.green[600],
                          size: 24,
                        ),
                        onPressed: () => onRestore(deletedNote),
                        tooltip: 'Geri Getir',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Text(
                    deletedNote.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Oluşturulma',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              originalDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Silinme',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              deletedDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
