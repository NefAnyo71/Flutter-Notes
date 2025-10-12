import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(Note) onDelete;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate;
    if (note.timestamp != null) {
      formattedDate = DateFormat(
        'dd.MM.yyyy - HH:mm',
      ).format(note.timestamp!.toDate());
    } else {
      formattedDate = 'Tarih yok';
    }

    return Card(
      elevation: 4,
      color: Colors.blueGrey[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.amber[300],
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
                note.content,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white70),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Güncelleme: $formattedDate',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                      onPressed: () => onDelete(note),
                      padding: EdgeInsets.zero,
                      tooltip: 'Notu Sil',
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}