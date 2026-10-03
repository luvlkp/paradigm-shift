import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'quiz_page.dart';
import 'theme.dart';
import 'whispered_words_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  int _currentIndex = 0;
  bool _flipped = false;

  void _goLeft() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _flipped = false;
      });
    }
  }

  void _goRight() {
    if (_currentIndex < dummyJargon.length - 1) {
      setState(() {
        _currentIndex++;
        _flipped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = dummyJargon[_currentIndex];
    return GroveBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Paradigm Shift',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the Grove — tap a card to reveal its meaning.',
              ),
              const SizedBox(height: 24),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => _flipped = !_flipped),
                  child: Container(
                    width: 400,
                    height: 200,
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        _flipped ? card.definition : card.term,
                        key: ValueKey(_flipped),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _flipped ? 16 : 22,
                          fontWeight: _flipped ? FontWeight.normal : FontWeight.bold,
                          color: _flipped
                              ? GroveColors.ink
                              : GroveColors.forestGreen,
                          fontFamily: _flipped ? null : 'Georgia',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('${_currentIndex + 1} of ${dummyJargon.length}'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentIndex > 0 ? _goLeft : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _currentIndex < dummyJargon.length - 1
                  ? _goRight
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Grove Glossary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        DataTable(
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: GroveColors.forestGreen,
          ),
          columns: const [
            DataColumn(label: Text('Jargon Word')),
            DataColumn(label: Text('Growth'), numeric: true),
          ],
          rows: [
            for (final jargon in dummyJargon)
              DataRow(cells: [
                DataCell(Text(jargon.term)),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      growthIcon(jargon.mastery),
                      size: 18,
                      color: growthColor(jargon.mastery),
                    ),
                    const SizedBox(width: 8),
                    Text('${jargon.mastery}%'),
                  ],
                )),
              ]),
          ],
        ),
        ],
          ),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _items = [
    (icon: Icons.forest, label: 'Grove'),
    (icon: Icons.auto_stories, label: 'Knowledge Quest'),
    (icon: Icons.mic, label: 'Whispered Words'),
    (icon: Icons.leaderboard, label: 'Leaderboard'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: GroveColors.forestGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Paradigm Shift',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GroveColors.parchment,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Enchanted Grove',
                    style: TextStyle(
                      fontSize: 12,
                      color: GroveColors.sage,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                for (int i = 0; i < _items.length; i++)
                  ListTile(
                    leading: Icon(
                      _items[i].icon,
                      color: _selectedIndex == i
                          ? GroveColors.softGold
                          : GroveColors.sage,
                    ),
                    title: Text(
                      _items[i].label,
                      style: TextStyle(
                        color: _selectedIndex == i
                            ? GroveColors.parchment
                            : GroveColors.sage,
                        fontWeight: _selectedIndex == i
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: _selectedIndex == i,
                    onTap: () => setState(() => _selectedIndex = i),
                  ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Center(
              child: switch (_selectedIndex) {
                0 => const FlashcardView(),
                1 => const QuizView(),
                2 => const WhisperedWordsPage(),
                _ => Text(
                  _items[_selectedIndex].label,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
