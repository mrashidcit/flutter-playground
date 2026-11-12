import 'package:flutter/foundation.dart';
import 'package:flutter_play_ground/data/repository/postsRepository.dart';
import 'package:flutter_play_ground/posts/post.dart';

/// Holds an in-memory list of posts loaded from [PostsRepository].
class PostsProvider extends ChangeNotifier {
  PostsProvider({PostsRepository repository = const PostsRepository()})
    : _posts = repository.getPosts();

  final List<Post> _posts;

  List<Post> get posts => List.unmodifiable(_posts);
}
