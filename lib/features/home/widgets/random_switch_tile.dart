import 'package:flutter/material.dart';

class RandomSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RandomSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Tasodifiy'),
      value: value,
      onChanged: onChanged,
    );
  }
}
