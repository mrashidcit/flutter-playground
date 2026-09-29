import 'package:flutter/material.dart';

class FruitsScreen extends StatefulWidget {
  const FruitsScreen({super.key, this.title = 'Fruits'});

  final String title;

  @override
  State<FruitsScreen> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  // In-memory data source.
  final List<String> fruits = [
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

  /// Sorts [fruits] in place using the current order (case-insensitive).
  /// Call inside setState. Does nothing if sorting was never enabled.
  void _applySort() {
    final ascending = _isAscending;
    if (ascending == null) return;
    fruits.sort((a, b) {
      final result = a.toLowerCase().compareTo(b.toLowerCase());
      return ascending ? result : -result;
    });
  }

  // Names of the fruits that are currently checked (selected).
  // Names are unique, so the name works as the item's id.
  final Set<String> _selectedFruits = {};

  // ---------- Selection ----------

  void _toggleSelected(String fruit, bool? checked) {
    setState(() {
      if (checked ?? false) {
        _selectedFruits.add(fruit);
      } else {
        _selectedFruits.remove(fruit);
      }
    });
  }

  // ---------- CRUD ----------

  /// Create
  Future<void> _addFruit() async {
    final name = await _showFruitDialog();
    if (name == null) return;
    setState(() {
      fruits.add(name);
      _applySort(); // keep list in current sort order
    });
    _showMessage('"$name" added');
  }

  /// Update
  Future<void> _editFruit(int index) async {
    final oldName = fruits[index];
    final name = await _showFruitDialog(
      initialValue: oldName,
      editIndex: index,
    );
    if (name == null || name == oldName) return;
    setState(() {
      fruits[index] = name;
      // Keep the checked state when a fruit is renamed.
      if (_selectedFruits.remove(oldName)) _selectedFruits.add(name);
      _applySort();
    });
    _showMessage('"$oldName" renamed to "$name"');
  }

  /// Delete (with undo)
  void _deleteFruit(int index) {
    final removed = fruits[index];
    final wasSelected = _selectedFruits.contains(removed);
    setState(() {
      fruits.removeAt(index);
      _selectedFruits.remove(removed);
    });

    final messenger = _messengerKey.currentState!;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('"$removed" deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              fruits.insert(index.clamp(0, fruits.length), removed);
              if (wasSelected) _selectedFruits.add(removed);
              _applySort();
            });
          },
        ),
      ),
    );
  }

  // ---------- Helpers ----------

  /// Returns an error message if [name] is invalid, otherwise null.
  String? _validate(String name, {int? editIndex}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Please enter a fruit name';
    for (var i = 0; i < fruits.length; i++) {
      if (i == editIndex) continue;
      if (fruits[i].toLowerCase() == trimmed.toLowerCase()) {
        return '"$trimmed" already exists';
      }
    }
    return null;
  }

  Future<String?> _showFruitDialog({String? initialValue, int? editIndex}) {
    return showDialog<String>(
      context: context,
      builder: (_) => _FruitDialog(
        title: initialValue == null ? 'Add Fruit' : 'Edit Fruit',
        confirmLabel: initialValue == null ? 'Add' : 'Save',
        initialValue: initialValue,
        validator: (value) => _validate(value, editIndex: editIndex),
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
                  final isSelected = _selectedFruits.contains(fruit);
                  return ListTile(
                    selected: isSelected,
                    // Highlight colour for checked items.
                    selectedTileColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    // key: ValueKey(fruit),
                    leading: CircleAvatar(child: Text(fruit[0].toUpperCase())),
                    title: Text(fruit),
                    onTap: () => _editFruit(index),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (checked) =>
                              _toggleSelected(fruit, checked),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () => _editFruit(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete',
                          onPressed: () => _deleteFruit(index),
                        ),
                      ],
                    ),
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
