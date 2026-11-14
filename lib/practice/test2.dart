import 'package:equatable/equatable.dart';

class User {
  final int id;
  final String name;

  User(this.id, this.name);

  /**
  @override
  bool operator ==(Object other) {
    return other is User && other.id == id && other.name == name;
  }
  */

  // @override
  // List<Object?> get props => [id, name];

  /**
  @override
  int get hashCode => Object.hash(id, name);
  */
}

void main() {
  final user1 = User(1, "Rashid");
  final user2 = User(1, "Rashid");

  print("== result : ${user1 == user2}"); // false

  // print("identical result : ${identical(user1, user2)}"); // false
}

/**
class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}

void main() {
  var p1 = Point(1, 2);
  // var p2 = Point(1, 2);
  var p2 = p1;

  print(p1 == p2); // False (different instances in memory)
}
*/
