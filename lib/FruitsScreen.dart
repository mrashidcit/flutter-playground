import 'package:flutter/material.dart';
import 'package:flutter_play_ground/Fruit.dart';
import 'package:flutter_play_ground/FruitListItem.dart';

class FruitsScreen extends StatefulWidget {
  const FruitsScreen({super.key, this.title = 'Fruits'});

  final String title;

  @override
  State<FruitsScreen> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  // Id to give the next fruit that is created (1, 2, 3, ...).
  int _nextId = 1;

  // In-memory data source. Ids are assigned in ascending order,
  // every fruit starts unselected.
  late final List<Fruit> fruits = _initialFruitNames
      .map((name) => _createFruit(name))
      .toList();

  static const List<String> _initialFruitNames = [
    "Apple",
    "Banana",
    "Mango",
    "Orange",
    "Grapes",
    "Pineapple",
    "Watermelon",
    "Papaya",
    "Strawberry",
    "Blueberry",
    "Raspberry",
    "Blackberry",
    "Peach",
    "Pear",
    "Plum",
    "Cherry",
    "Guava",
    "Pomegranate",
    "Kiwi",
    "Coconut",
    "Avocado",
    "Apricot",
    "Fig",
    "Lychee",
    "Dragon Fruit",
    "Passion Fruit",
    "Cantaloupe",
    "Jackfruit",
    "Tangerine",
    "Grapefruit",
  ];

  /// Creates a new [Fruit] with the next id.
  Fruit _createFruit(String name) => Fruit(id: _nextId++, name: name);

  // Own messenger so SnackBars appear inside this screen's Scaffold
  // (and push the FAB up instead of covering it).
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  // Sorting state: null = original order (not sorted yet),
  // true = A→Z (ASC), false = Z→A (DESC).
  bool? _isAscending;

  // ---------- Sorting ----------

  /// Toggles ASC/DESC and sorts the list by name.
  void _toggleSort() {
    setState(() {
      _isAscending = !(_isAscending ?? false); // first tap → ASC
      _applySort();
    });
    _showMessage(_isAscending! ? 'Sorted A → Z' : 'Sorted Z → A');
  }

  /// Sorts [fruits] in place by name (case-insensitive).
  /// Call inside setState. Does nothing if sorting was never enabled.
  void _applySort() {
    final ascending = _isAscending;
    if (ascending == null) return;
    fruits.sort((a, b) {
      final result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return ascending ? result : -result;
    });
  }

  // ---------- Selection ----------

  void _toggleSelected(Fruit fruit, bool? checked) {
    setState(() => fruit.isSelected = checked ?? false);
  }

  // ---------- CRUD ----------

  /// Create
  Future<void> _addFruit() async {
    final name = await _showFruitDialog();
    if (name == null) return;
    setState(() {
      fruits.add(_createFruit(name));
      _applySort(); // keep list in current sort order
    });
    _showMessage('"$name" added');
  }

  /// Update
  Future<void> _editFruit(Fruit fruit) async {
    final oldName = fruit.name;
    final name = await _showFruitDialog(editing: fruit);
    if (name == null || name == oldName) return;
    setState(() {
      fruit.name = name; // id and isSelected stay the same
      _applySort();
    });
    _showMessage('"$oldName" renamed to "$name"');
  }

  /// Delete (with undo)
  void _deleteFruit(Fruit fruit) {
    final index = fruits.indexWhere((f) => f.id == fruit.id);
    if (index == -1) return;
    setState(() => fruits.removeAt(index));

    final messenger = _messengerKey.currentState!;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('"${fruit.name}" deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Same object comes back: same id and same isSelected.
            setState(() {
              fruits.insert(index.clamp(0, fruits.length), fruit);
              _applySort();
            });
          },
        ),
      ),
    );
  }

  // ---------- Helpers ----------

  /// Returns an error message if [name] is invalid, otherwise null.
  /// [editingId] is skipped so a fruit can keep its own name.
  String? _validate(String name, {int? editingId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Please enter a fruit name';
    final exists = fruits.any(
      (f) => f.id != editingId && f.name.toLowerCase() == trimmed.toLowerCase(),
    );
    return exists ? '"$trimmed" already exists' : null;
  }

  /// Shows the Add dialog, or the Edit dialog when [editing] is given.
  Future<String?> _showFruitDialog({Fruit? editing}) {
    return showDialog<String>(
      context: context,
      builder: (_) => _FruitDialog(
        title: editing == null ? 'Add Fruit' : 'Edit Fruit',
        confirmLabel: editing == null ? 'Add' : 'Save',
        initialValue: editing?.name,
        validator: (value) => _validate(value, editingId: editing?.id),
      ),
    );
  }

  void _showMessage(String message) {
    _messengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              tooltip: switch (_isAscending) {
                true => 'Sorted A → Z (tap for Z → A)',
                false => 'Sorted Z → A (tap for A → Z)',
                null => 'Sort by name',
              },
              icon: Icon(
                _isAscending == false
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
              ),
              onPressed: _toggleSort,
            ),
          ],
        ),
        body: fruits.isEmpty
            ? const Center(child: Text('No fruits yet. Tap + to add one.'))
            : ListView.separated(
                itemCount: fruits.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final fruit = fruits[index];
                  return FruitListItem(
                    key: ValueKey(fruit.id),
                    fruit: fruit,
                    onSelectedChanged: (checked) =>
                        _toggleSelected(fruit, checked),
                    onEdit: () => _editFruit(fruit),
                    onDelete: () => _deleteFruit(fruit),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addFruit,
          tooltip: 'Add Fruit',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Dialog used for both adding and editing a fruit.
/// Pops with the trimmed name, or null if cancelled.
class _FruitDialog extends StatefulWidget {
  const _FruitDialog({
    required this.title,
    required this.confirmLabel,
    required this.validator,
    this.initialValue,
  });

  final String title;
  final String confirmLabel;
  final String? initialValue;
  final String? Function(String value) validator;

  @override
  State<_FruitDialog> createState() => _FruitDialogState();
}

class _FruitDialogState extends State<_FruitDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final error = widget.validator(_controller.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: 'Fruit name',
          errorText: _error,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
