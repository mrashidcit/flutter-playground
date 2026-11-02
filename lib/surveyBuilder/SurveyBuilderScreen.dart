import 'package:flutter/material.dart';
import 'package:flutter_play_ground/surveyBuilder/QuestionCard.dart';
import 'package:flutter_play_ground/surveyBuilder/QuestionModel.dart';
import 'package:flutter_play_ground/surveyBuilder/SurveyProvider.dart';
import 'package:provider/provider.dart';

/// Demo screen to learn `ObjectKey`.
///
/// Every QuestionCard gets `ObjectKey(question)`. When the list is reordered
/// or a question is deleted, Flutter matches the old and new children by
/// their key (the QuestionModel instance), not by their position. So each
/// card's internal State (notes, selected answer) moves with its question.
class SurveyBuilderScreen extends StatelessWidget {
  const SurveyBuilderScreen({super.key});

  Future<void> _showAddQuestionDialog(BuildContext context) async {
    final question = await showDialog<QuestionModel>(
      context: context,
      builder: (_) => const _AddQuestionDialog(),
    );
    if (question == null || !context.mounted) return;
    context.read<SurveyProvider>().addQuestion(question);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SurveyProvider>();
    final questions = provider.questions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dynamic Survey Builder'),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddQuestionDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Question'),
          ),
        ],
      ),
      body: questions.isEmpty
          ? const Center(child: Text('No questions yet. Tap "Add Question".'))
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              // We show our own drag handle inside the card instead.
              buildDefaultDragHandles: false,
              itemCount: questions.length,
              onReorderItem: provider.reorderQuestions,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionCard(
                  // The key that ties this card's State to this exact
                  // QuestionModel instance.
                  key: ObjectKey(question),
                  question: question,
                  index: index,
                  onDelete: () => provider.removeQuestion(question),
                );
              },
            ),
    );
  }
}

/// Dialog that builds a new QuestionModel and returns it with Navigator.pop.
///
/// Uses setState only for its own form fields; the survey list itself is
/// managed by SurveyProvider.
class _AddQuestionDialog extends StatefulWidget {
  const _AddQuestionDialog();

  @override
  State<_AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<_AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _choicesController = TextEditingController();
  QuestionType _type = QuestionType.textInput;

  @override
  void dispose() {
    _titleController.dispose();
    _choicesController.dispose();
    super.dispose();
  }

  /// "Red, Green , ,Blue" -> ['Red', 'Green', 'Blue']
  List<String> get _choices => _choicesController.text
      .split(',')
      .map((choice) => choice.trim())
      .where((choice) => choice.isNotEmpty)
      .toList();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      QuestionModel(
        title: _titleController.text.trim(),
        type: _type,
        choices: _type.hasChoices ? _choices : const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Question'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Question title'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<QuestionType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Question type'),
                items: [
                  for (final type in QuestionType.values)
                    DropdownMenuItem(value: type, child: Text(type.label)),
                ],
                onChanged: (value) => setState(() => _type = value!),
              ),
              if (_type.hasChoices) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _choicesController,
                  decoration: const InputDecoration(
                    labelText: 'Options',
                    helperText: 'Separate options with commas',
                  ),
                  validator: (_) => _choices.length < 2
                      ? 'Please enter at least 2 options'
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
