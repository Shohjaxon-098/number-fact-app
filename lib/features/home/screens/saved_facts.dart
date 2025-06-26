import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:numberfactapp/core/models/saved_facts.dart';

class SavedFactsScreen extends StatelessWidget {
  const SavedFactsScreen({super.key});

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SavedFact>('savedFacts');
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saqlangan Faktlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Hammasini tozalash',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Diqqat!'),
                  content: const Text(
                    'Barcha saqlangan faktlar o‘chirilsinmi?',
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Bekor qilish'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                      child: const Text('Tozalash'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await box.clear();
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<SavedFact>>(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox, size: 72, color: colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(
                    'Hozircha hech qanday fakt saqlanmagan.',
                    style: TextStyle(fontSize: 16, color: colorScheme.outline),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final fact = box.getAt(index)!;
              return Card(
                elevation: 4,
                shadowColor: colorScheme.shadow.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  title: Text(
                    fact.fact,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    '${fact.type.toUpperCase()} • ${_formatDate(fact.savedAt)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    tooltip: 'O‘chirish',
                    onPressed: () => box.deleteAt(index),
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
