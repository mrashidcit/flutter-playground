import 'package:equatable/equatable.dart';
import 'package:flutter_play_ground/practice/user.dart';

/**
class User extends Equatable {
  final int id;
  final String name;

  User(this.id, this.name);

  /**
  @override
  bool operator ==(Object other) {
    return other is User && other.id == id && other.name == name;
  }
  */

  @override
  List<Object?> get props => [id, name];
}
*/

void main() {
  final user1 = User(1, "Rashid", "rashid@gmail.com");
  final user2 = User(1, "Rashid", "rashid@gmail.com");

  print("== result : ${user1 == user2}");
}
