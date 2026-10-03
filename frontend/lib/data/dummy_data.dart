class JargonTerm {
  final String term;
  final String definition;
  final String example;
  int mastery;

  JargonTerm({
    required this.term,
    required this.definition,
    required this.example,
    required this.mastery,
  });

  void adjustMastery(bool correct) {
    mastery = (mastery + (correct ? 10 : -10)).clamp(0, 100);
  }
}

final List<JargonTerm> dummyJargon = [
  JargonTerm(
    term: "Circle back",
    definition: "To return to a topic or discussion later.",
    example: "Let's circle back after we get more information.",
    mastery: 80,
  ),
  JargonTerm(
    term: "Bandwidth",
    definition: "The available time, energy, or resources to take on work.",
    example: "I don't have enough bandwidth to take this on.",
    mastery: 55,
  ),
  JargonTerm(
    term: "Synergy",
    definition: "The combined effect of a group that is greater than the sum of individual efforts.",
    example: "The synergy between the teams boosted results.",
    mastery: 50,
  ),
  JargonTerm(
    term: "Deep dive",
    definition: "A thorough examination of a subject or topic.",
    example: "Let's do a deep dive into the metrics.",
    mastery: 50,
  ),
  JargonTerm(
    term: "Low-hanging fruit",
    definition: "A task or opportunity that is relatively easy to accomplish.",
    example: "Let's start with the low-hanging fruit.",
    mastery: 35,
  ),
  JargonTerm(
    term: "Move the needle",
    definition: "To make a meaningful or noticeable improvement.",
    example: "This feature could really move the needle.",
    mastery: 65,
  ),
  JargonTerm(
    term: "KPI",
    definition: "Key Performance Indicator, a measurement used to track performance.",
    example: "Our main KPI this quarter is customer retention.",
    mastery: 90,
  ),
];