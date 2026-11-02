import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_play_ground/surveyBuilder/QuestionModel.dart';

/// Holds the list of survey questions for SurveyBuilderScreen.
///
/// The same QuestionModel instances are kept for their whole life: we only
/// insert, remove or move them inside [_questions], never recreate them.
/// That is what lets `ObjectKey(question)` find the same card State again.
class SurveyProvider extends ChangeNotifier {
  final List<QuestionModel> _questions = [
    QuestionModel(title: 'What is your name?', type: QuestionType.textInput),
    QuestionModel(
      title: 'Which platform do you use?',
      type: QuestionType.multipleChoice,
      choices: ['Android', 'iOS', 'Web'],
    ),
    QuestionModel(
      title: 'Subscribe to the newsletter?',
      type: QuestionType.checkbox,
    ),
    QuestionModel(
      title: 'Favourite state management?',
      type: QuestionType.dropdown,
      choices: ['Provider', 'Riverpod', 'Bloc'],
    ),
  ];

  /// Read-only view, so the list can only be changed through the methods below.
  UnmodifiableListView<QuestionModel> get questions =>
      UnmodifiableListView(_questions);

  // --------------------------------- Actions ---------------------------------

  void addQuestion(QuestionModel question) {
    _questions.add(question);
    notifyListeners();
  }

  void removeQuestion(QuestionModel question) {
    // QuestionModel has no custom `==`, so this removes this exact instance.
    _questions.remove(question);
    notifyListeners();
  }

  /// Called by `ReorderableListView.onReorderItem`, which already adjusts
  /// [newIndex] for the item removed at [oldIndex].
  void reorderQuestions(int oldIndex, int newIndex) {
    // Move the SAME instance; never create a new QuestionModel here.
    final question = _questions.removeAt(oldIndex);
    _questions.insert(newIndex, question);
    notifyListeners();
  }
}
