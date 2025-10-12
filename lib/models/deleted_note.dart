import 'package:cloud_firestore/cloud_firestore.dart';

// Silinen Not Model Sınıfı
class DeletedNote {
  final String? id;
  final String title;
  final String content;
  final Timestamp? originalTimestamp;
  final Timestamp? deletedAt;

  DeletedNote({
    this.id,
    required this.title,
    required this.content,
    required this.originalTimestamp,
    required this.deletedAt,
  });

  factory DeletedNote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeletedNote(
      id: doc.id,
      title: data['title'] ?? 'Başlıksız',
      content: data['content'] ?? '',
      originalTimestamp: data['originalTimestamp'] as Timestamp?,
      deletedAt: data['deletedAt'] as Timestamp?,
    );
  }
}
