import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play_ground/Fruit.dart';

/// One row in the fruits list.
///
/// Stateful so it can own the `Qty` TextField's state (its controller).
/// The quantity lives only here, inside the list item — not in [Fruit]
/// and not in the parent screen.
class FruitListItem extends StatefulWidget {
  const FruitListItem({
    super.key,
    required this.fruit,
    required this.onSelectedChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final Fruit fruit;
  final ValueChanged<bool?> onSelectedChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<FruitListItem> createState() => _FruitListItemState();
}

class _FruitListItemState extends State<FruitListItem>
    with AutomaticKeepAliveClientMixin {
  // Qty TextField state, held by the list item itself.
  final TextEditingController _qtyController = TextEditingController();

  // Keep this item's state alive when it scrolls off-screen, otherwise
  // ListView would dispose it and the typed Qty would be lost.
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final fruit = widget.fruit;

    return ListTile(
      selected: fruit.isSelected,
      // Highlight colour for checked items.
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      leading: CircleAvatar(child: Text('${fruit.id}')),
      title: Text(fruit.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            const Text('Qty'),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: '0',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: widget.onEdit,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: fruit.isSelected,
            onChanged: widget.onSelectedChanged,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: widget.onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Delete',
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
