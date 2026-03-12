import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/components.dart';

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  int _counter = 0;
  String _currentTasbeeh = 'SubhanAllah';
  int _targetCount = 33;

  final List<Map<String, dynamic>> _tasbeehList = [
    {'name': 'SubhanAllah', 'arabic': 'سُبْحَانَ اللَّهِ', 'count': 33},
    {'name': 'Alhumdulillah', 'arabic': 'الْحَمْدُ لِلَّهِ', 'count': 33},
    {'name': 'Allahu Akbar', 'arabic': 'اللَّهُ أَكْبَرُ', 'count': 34},
    {
      'name': 'La ilaha illallah',
      'arabic': 'لَا إِلَهَ إِلَّا اللَّهُ',
      'count': 100,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('tasbeeh_counter') ?? 0;
    });
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeeh_counter', _counter);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounter();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _saveCounter();
  }

  void _changeTasbeeh(int index) {
    setState(() {
      _currentTasbeeh = _tasbeehList[index]['name'];
      _targetCount = _tasbeehList[index]['count'];
      _counter = 0;
    });
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HeaderBar(title: 'Tasbeeh'),
      body: Column(
        children: [
          // Tasbeeh selector
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tasbeehList.length,
              itemBuilder: (context, index) {
                final tasbeeh = _tasbeehList[index];
                final isSelected = _currentTasbeeh == tasbeeh['name'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tasbeeh['name']),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    onSelected: (_) => _changeTasbeeh(index),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main counter display
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Arabic text
                Text(
                  _tasbeehList.firstWhere(
                    (t) => t['name'] == _currentTasbeeh,
                  )['arabic'],
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 24),

                // Counter circle
                GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade700,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_counter',
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '/ $_targetCount',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _counter / _targetCount,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Reset button
                TextButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh, color: Colors.orange),
                  label: const Text(
                    'Reset Counter',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
