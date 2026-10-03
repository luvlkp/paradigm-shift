class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String term;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.term,
  });
}

const List<QuizQuestion> dummyQuiz = [
  QuizQuestion(
    question: 'What does "synergy" mean in a business context?',
    options: [
      'The combined effect of a group that is greater than the sum of individual efforts.',
      'A plan for reducing the number of employees.',
      'The process of scheduling meetings.',
      'A measure of network speed.',
    ],
    correctIndex: 0,
    term: 'Synergy',
  ),
  QuizQuestion(
    question: 'What does it mean to "circle back" on a topic?',
    options: [
      'To cancel a project entirely.',
      'To return to a topic or follow up at a later time.',
      'To move a meeting to another location.',
      'To assign a task to someone else.',
    ],
    correctIndex: 1,
    term: 'Circle back',
  ),
  QuizQuestion(
    question: 'A "deep dive" refers to:',
    options: [
      'A short break between meetings.',
      'A quick summary of the meeting notes.',
      'A thorough examination of a subject or topic.',
      'A swimming team-building activity.',
    ],
    correctIndex: 2,
    term: 'Deep dive',
  ),
  QuizQuestion(
    question: 'Which of these is an example of "low-hanging fruit"?',
    options: [
      'A multi-year strategic initiative.',
      'An easy task that requires little effort to complete.',
      'A task that has been delayed indefinitely.',
      'The most expensive part of a project.',
    ],
    correctIndex: 1,
    term: 'Low-hanging fruit',
  ),
  QuizQuestion(
    question: 'If someone says they do not have the "bandwidth", they mean:',
    options: [
      'Their internet connection is too slow.',
      'They do not understand the topic.',
      'They do not have the capacity to take on additional work.',
      'They need a larger budget.',
    ],
    correctIndex: 2,
    term: 'Bandwidth',
  ),
  QuizQuestion(
    question: 'What does it mean to "move the needle"?',
    options: [
      'To make a significant impact or noticeable difference.',
      'To change the subject abruptly.',
      'To postpone a decision.',
      'To rearrange the seating plan.',
    ],
    correctIndex: 0,
    term: 'Move the needle',
  ),
];
