import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:numberfactapp/core/models/saved_facts.dart';
import 'package:numberfactapp/core/service/fact_service.dart';
import 'package:numberfactapp/features/home/screens/saved_facts.dart';
import 'package:numberfactapp/features/home/widgets/fact_type_dropdown.dart';
import 'package:numberfactapp/features/home/widgets/date_input_row.dart';
import 'package:numberfactapp/features/home/widgets/number_input_field.dart';
import 'package:numberfactapp/features/home/widgets/random_switch_tile.dart';
import 'package:numberfactapp/features/home/widgets/submit_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedType = 'trivia';
  bool _isRandom = false;
  bool _isLoading = false;

  int? _selectedMonth;
  int? _selectedDay;

  final months = const [
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'Iyun',
    'Iyul',
    'Avgust',
    'Sentyabr',
    'Oktyabr',
    'Noyabr',
    'Dekabr',
  ];

  void _getFact() async {
    setState(() => _isLoading = true);
    String? input;

    if (_selectedType == 'date') {
      if (_selectedMonth == null || _selectedDay == null) {
        _showError('Oy va kun tanlang');
        setState(() => _isLoading = false);
        return;
      }
      input = '$_selectedMonth/$_selectedDay';
    } else {
      input = _controller.text.trim();
      if (!_isRandom && input.isEmpty) {
        _showError('Raqam kiritilishi kerak');
        setState(() => _isLoading = false);
        return;
      }
      if (!_isRandom && int.tryParse(input) == null) {
        _showError('Faqat raqam kiritilishi kerak');
        setState(() => _isLoading = false);
        return;
      }
    }

    try {
      final fact = await FactService().fetchFact(
        type: _selectedType,
        number: _isRandom ? null : input,
        isRandom: _isRandom,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Fakt',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(fact, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () async {
                final box = Hive.box<SavedFact>('savedFacts');
                await box.add(
                  SavedFact(
                    fact: fact,
                    type: _selectedType,
                    savedAt: DateTime.now(),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Saqlash'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Yopish'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError(
        'Serverga ulanib bo‘lmadi. Iltimos, internet aloqasini tekshiring.',
      );
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xatolik',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Numbers Fact'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SavedFactsScreen()),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    FactTypeDropdown(
                      selectedType: _selectedType,
                      onChanged: (val) {
                        setState(() {
                          _selectedType = val;
                          _controller.clear();
                          _selectedMonth = null;
                          _selectedDay = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedType == 'date')
                      DateInputRow(
                        selectedMonth: _selectedMonth,
                        selectedDay: _selectedDay,
                        months: months,
                        onMonthChanged: (val) =>
                            setState(() => _selectedMonth = val),
                        onDayChanged: (val) =>
                            setState(() => _selectedDay = val),
                      )
                    else
                      NumberInputField(
                        controller: _controller,
                        enabled: !_isRandom,
                      ),
                    const SizedBox(height: 16),
                    RandomSwitchTile(
                      value: _isRandom,
                      onChanged: (val) => setState(() => _isRandom = val),
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _getFact,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.3),
          ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}