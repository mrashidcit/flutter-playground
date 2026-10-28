/// Model for a single fruit in the list.
class Fruit {
  Fruit({required this.id, required this.name, this.isSelected = false});

  /// Unique, auto-incremented id (1, 2, 3, ...). Never changes.
  final int id;

  /// Display name. Can be changed via Edit.
  String name;

  /// Whether the fruit's checkbox is checked. Defaults to false.
  bool isSelected;

  @override
  String toString() => 'Fruit(id: $id, name: $name, isSelected: $isSelected)';
}
