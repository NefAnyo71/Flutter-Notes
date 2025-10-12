import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final Timestamp? timestamp;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? 'Başlıksız',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toArchive() {
    return {
      'title': title,
      'content': content,
      'originalTimestamp': timestamp,
      'deletedAt': FieldValue.serverTimestamp(),
    };
  }
}