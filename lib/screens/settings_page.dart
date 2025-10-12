import 'package:flutter/material.dart';
import 'archived_notes_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            color: Colors.blueGrey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.restore_from_trash,
                size: 32,
                color: Colors.amber,
              ),
              title: const Text(
                'Silinen Notları Geri Getir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Arşivlenen notları görüntüle ve geri getir',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArchivedNotesPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
