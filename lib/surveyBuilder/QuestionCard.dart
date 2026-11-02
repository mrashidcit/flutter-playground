import 'package:flutter/material.dart';
import 'package:flutter_play_ground/surveyBuilder/QuestionModel.dart';

/// One question in the survey list.
///
/// It is a StatefulWidget on purpose: the notes TextField and the preview
/// control (typed text, selected radio, checkbox, dropdown value) live in
/// [_QuestionCardState], NOT in the provider. The parent gives every card an
/// `ObjectKey(question)`, so this State stays with its question when the list
/// is reordered or another question is deleted.
class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onDelete,
  });

  final QuestionModel question;

  /// Position in the list, needed by ReorderableDragStartListener.
  final int index;

  final VoidCallback onDelete;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  // ------------------------------ Internal state -----------------------------
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  String? _selectedChoice;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    debugPrint('QuestionCard initState: ${widget.question.title}');
  }

  @override
  void dispose() {
    debugPrint('QuestionCard dispose: ${widget.question.title}');
    _notesController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ReorderableDragStartListener(
                  index: widget.index,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.drag_handle),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        question.type.label,
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Delete question',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPreview(question),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Admin notes',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Preview of how the question will look to the person filling the survey.
  Widget _buildPreview(QuestionModel question) {
    switch (question.type) {
      case QuestionType.textInput:
        return TextField(
          controller: _answerController,
          decoration: const InputDecoration(hintText: 'Answer preview'),
        );
      case QuestionType.multipleChoice:
        return RadioGroup<String>(
          groupValue: _selectedChoice,
          onChanged: (value) => setState(() => _selectedChoice = value),
          child: Column(
            children: [
              for (final choice in question.choices)
                RadioListTile<String>(
                  value: choice,
                  title: Text(choice),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        );
      case QuestionType.checkbox:
        return CheckboxListTile(
          value: _isChecked,
          onChanged: (value) => setState(() => _isChecked = value ?? false),
          title: const Text('Yes'),
          dense: true,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        );
      case QuestionType.dropdown:
        return DropdownButton<String>(
          value: _selectedChoice,
          hint: const Text('Select an option'),
          isExpanded: true,
          items: [
            for (final choice in question.choices)
              DropdownMenuItem(value: choice, child: Text(choice)),
          ],
          onChanged: (value) => setState(() => _selectedChoice = value),
        );
    }
  }
}
