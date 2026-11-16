import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  final int id;
  final String name;
  final String email;

  User(this.id, this.name, this.email);
}
