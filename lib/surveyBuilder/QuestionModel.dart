/// The kinds of questions the Admin can add to a survey.
enum QuestionType {
  textInput('Text Input'),
  multipleChoice('Multiple Choice'),
  checkbox('Checkbox'),
  dropdown('Dropdown');

  const QuestionType(this.label);

  /// Human readable name shown in the UI.
  final String label;

  /// Only these types need a list of answer options.
  bool get hasChoices =>
      this == QuestionType.multipleChoice || this == QuestionType.dropdown;
}

/// Model for a single survey question.
///
/// It intentionally does NOT override `==` / `hashCode` (and does not extend
/// Equatable). `ObjectKey` compares its value with `identical()`, so every
/// QuestionModel instance is its own identity, even if two questions have the
/// same title and type.
class QuestionModel {
  QuestionModel({
    required this.title,
    required this.type,
    this.choices = const [],
  });

  final String title;

  final QuestionType type;

  /// Answer options for [QuestionType.multipleChoice] and
  /// [QuestionType.dropdown]. Empty for the other types.
  final List<String> choices;

  @override
  String toString() =>
      'QuestionModel(title: $title, type: ${type.label}, choices: $choices)';
}
