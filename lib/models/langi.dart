class Langi {
  Langi({
    required this.question,
    required this.answer,
    required this.tokens,
  });

  final String question;
  final String answer;
  final int tokens;

  static Langi fromJson(Map json) => Langi(
        question: json['question'],
        answer: json['answer'],
        tokens: json['tokens'],
      );
}
