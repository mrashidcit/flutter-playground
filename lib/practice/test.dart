import 'package:equatable/equatable.dart';

class User {
  final int id;
  final String name;

  User(this.id, this.name);

  @override
  bool operator ==(Object other) {
    return other is User && other.id == id && other.name == name;
  }
}

void main() {
  final user1 = User(1, "Rashid");
  // final user2 = User(1, "Rashid");
  final user2 = user1;

  // print("== result : ${user1 == user2}");
  print("identical result : ${identical(user1, user2)}");
}
