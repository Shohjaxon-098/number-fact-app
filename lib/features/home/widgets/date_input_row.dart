import 'package:flutter/material.dart';

class DateInputRow extends StatelessWidget {
  final int? selectedMonth;
  final int? selectedDay;
  final List<String> months;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onDayChanged;

  const DateInputRow({
    super.key,
    required this.selectedMonth,
    required this.selectedDay,
    required this.months,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedMonth,
            items: List.generate(12, (i) {
              return DropdownMenuItem(
                value: i + 1,
                child: Text(months[i]),
              );
            }),
            onChanged: onMonthChanged,
            decoration: const InputDecoration(labelText: 'Oy'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedDay,
            items: List.generate(31, (i) {
              return DropdownMenuItem(
                value: i + 1,
                child: Text('${i + 1}'),
              );
            }),
            onChanged: onDayChanged,
            decoration: const InputDecoration(labelText: 'Kun'),
          ),
        ),
      ],
    );
  }
}
