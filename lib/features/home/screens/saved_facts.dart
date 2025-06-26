import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:numberfactapp/core/models/saved_facts.dart';
import 'package:numberfactapp/features/home/widgets/empty_placeholder.dart';
import 'package:numberfactapp/features/home/widgets/saved_fact_card.dart';

class SavedFactsScreen extends StatelessWidget {
  const SavedFactsScreen({super.key});

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SavedFact>('savedFacts');

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
            return const EmptyPlaceholder();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final fact = box.getAt(index)!;
              return SavedFactCard(
                fact: fact,
                formattedDate: _formatDate(fact.savedAt),
                onDelete: () => box.deleteAt(index),
              );
            },
          );
        },
      ),
    );
  }
}
