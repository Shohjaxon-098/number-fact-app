import 'package:flutter/material.dart';

class FactTypeDropdown extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const FactTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedType,
      items: const [
        DropdownMenuItem(value: 'trivia', child: Text('Trivia')),
        DropdownMenuItem(value: 'math', child: Text('Math')),
        DropdownMenuItem(value: 'date', child: Text('Date')),
      ],
      onChanged: (val) => onChanged(val!),
      decoration: const InputDecoration(labelText: 'Fakt turi'),
    );
  }
}
