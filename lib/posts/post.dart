import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  const Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl];
}
