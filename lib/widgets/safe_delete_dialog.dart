import 'package:flutter/material.dart';
import '../models/note.dart';

class SafeDeleteDialog extends StatelessWidget {
  final Note note;
  final int confirmationNumber;
  final int totalConfirmations;

  const SafeDeleteDialog({
    super.key,
    required this.note,
    required this.confirmationNumber,
    required this.totalConfirmations,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Icon(Icons.delete_forever, size: 60, color: Colors.red[700]),
          const SizedBox(height: 10),
          Text(
            'SON ONAY GEREKİYOR',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      content: Text(
        '"${note.title}" başlıklı not **kalıcı** olarak silinecek.\n\n'
        '**Onay ${confirmationNumber}/${totalConfirmations}**\n'
        'Lütfen bu işlemi **üç kez** onaylayın.\n yanlışlıkla silmemeniz için',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[400],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'VAZGEÇ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'SİL (${confirmationNumber}/${totalConfirmations})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}