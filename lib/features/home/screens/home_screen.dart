import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:numberfactapp/core/models/saved_facts.dart';
import 'package:numberfactapp/core/service/fact_service.dart';
import 'package:numberfactapp/features/home/screens/saved_facts.dart';

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
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: 'trivia',
                          child: Text('Trivia'),
                        ),
                        DropdownMenuItem(value: 'math', child: Text('Math')),
                        DropdownMenuItem(value: 'date', child: Text('Date')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedType = val!;
                          _controller.clear();
                          _selectedMonth = null;
                          _selectedDay = null;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Fakt turi'),
                    ),
                    const SizedBox(height: 16),

                    if (_selectedType == 'date') ...[
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedMonth,
                              items: List.generate(12, (i) {
                                return DropdownMenuItem(
                                  value: i + 1,
                                  child: Text(months[i]),
                                );
                              }),
                              onChanged: (val) =>
                                  setState(() => _selectedMonth = val),
                              decoration: const InputDecoration(
                                labelText: 'Oy',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedDay,
                              items: List.generate(31, (i) {
                                return DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1}'),
                                );
                              }),
                              onChanged: (val) =>
                                  setState(() => _selectedDay = val),
                              decoration: const InputDecoration(
                                labelText: 'Kun',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else
                      TextField(
                        controller: _controller,
                        enabled: !_isRandom,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Raqam'),
                      ),

                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: const Text('Tasodifiy'),
                      value: _isRandom,
                      onChanged: (val) => setState(() => _isRandom = val),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text('Faktni olish'),
                      onPressed: _isLoading ? null : _getFact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
