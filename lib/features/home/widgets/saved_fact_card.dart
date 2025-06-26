import 'package:flutter/material.dart';
import 'package:numberfactapp/core/models/saved_facts.dart';

class SavedFactCard extends StatelessWidget {
  final SavedFact fact;
  final String formattedDate;
  final VoidCallback onDelete;

  const SavedFactCard({
    super.key,
    required this.fact,
    required this.formattedDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          '${fact.type.toUpperCase()} • $formattedDate',
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          tooltip: 'O‘chirish',
          onPressed: onDelete,
        ),
      ),
    );
  }
} 