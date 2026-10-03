import 'package:flutter/material.dart';
import 'data/dummy_quiz.dart';
import 'data/dummy_data.dart';
import 'theme.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _submitted = false;
  int _score = 0;

  QuizQuestion get _question => dummyQuiz[_currentIndex];
  bool get _isLastQuestion => _currentIndex == dummyQuiz.length - 1;
  bool get _isCorrect => _selectedIndex == _question.correctIndex;

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() {
      _submitted = true;
      if (_isCorrect) _score++;
      final jargon = dummyJargon.where((j) => j.term == _question.term);
      for (final j in jargon) {
        j.adjustMastery(_isCorrect);
      }
    });
  }

  void _next() {
    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _submitted = false;
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedIndex = null;
      _submitted = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GroveBackground(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(
            'Knowledge Quest',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${_currentIndex + 1} of ${dummyQuiz.length}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentIndex + (_submitted ? 1 : 0)) / dummyQuiz.length,
              minHeight: 8,
              backgroundColor: GroveColors.sage.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(GroveColors.forestGreen),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _question.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < _question.options.length; i++)
                    _OptionTile(
                      text: _question.options[i],
                      selected: _selectedIndex == i,
                      submitted: _submitted,
                      isCorrect: i == _question.correctIndex,
                      onTap: _submitted
                          ? null
                          : () => setState(() => _selectedIndex = i),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_submitted)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: _isCorrect
                    ? GroveColors.softGold.withValues(alpha: 0.35)
                    : GroveColors.woodBrown.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isCorrect
                    ? [
                        BoxShadow(
                          color: GroveColors.gold.withValues(alpha: 0.4),
                          blurRadius: 16,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _isCorrect
                    ? 'Correct! Well explored ✨'
                    : 'Keep exploring — the correct path is highlighted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isCorrect
                      ? GroveColors.forestGreen
                      : GroveColors.woodBrown,
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (!_submitted)
            FilledButton(
              onPressed: _selectedIndex == null ? null : _submit,
              child: const Text('Submit'),
            )
          else if (!_isLastQuestion)
            FilledButton(
              onPressed: _next,
              child: const Text('Next Question'),
            )
          else
            Column(
              children: [
                Text(
                  'Quest complete! You scored $_score out of ${dummyQuiz.length}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GroveColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _restart,
                  child: const Text('Restart Quiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.text,
    required this.selected,
    required this.submitted,
    required this.isCorrect,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool submitted;
  final bool isCorrect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (submitted && isCorrect) {
      color = GroveColors.softGold.withValues(alpha: 0.35);
    } else if (submitted && selected && !isCorrect) {
      color = GroveColors.woodBrown.withValues(alpha: 0.15);
    } else if (selected) {
      color = GroveColors.sage.withValues(alpha: 0.3);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  submitted && isCorrect
                      ? Icons.check_circle
                      : submitted && selected
                      ? Icons.cancel
                      : selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: submitted && isCorrect
                      ? GroveColors.forestGreen
                      : submitted && selected
                      ? GroveColors.woodBrown
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(text)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
