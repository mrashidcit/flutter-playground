import 'package:flutter_play_ground/posts/post.dart';

/// Supplies posts. For now they are dummy posts generated in memory.
class PostsRepository {
  const PostsRepository();

  List<Post> getPosts() {
    const titles = [
      'Getting started with Flutter',
      'Understanding Keys in Flutter: LocalKey, ValueKey, ObjectKey and UniqueKey explained',
      'State management with Provider',
      'PageStorageKey keeps your scroll position',
      'Building responsive layouts',
      'Async programming in Dart with Futures and Streams',
      'Custom painters for beginners',
      'Animations made simple',
      'Navigation 2.0 and the Router API: a practical walkthrough for real apps',
      'Testing widgets the easy way',
      'Theming your app with Material 3',
      'Working with forms and validation',
      'Slivers demystified',
      'Handling images from the network',
      'Platform channels: talking to native code from Flutter on Android and iOS',
      'Performance tips for long lists',
      'Equatable and value equality',
      'Debugging layout overflow errors',
      'Localization and internationalization',
      'Publishing your first app to the stores',
    ];

    const shortDescription =
        'A quick look at this topic with a small example you can try right away.';
    const longDescription =
        'In this post we walk through the topic step by step. We start with the '
        'basic idea, then build a small example, look at the common mistakes '
        'people make, and finish with tips you can apply in your own projects. '
        'By the end you should feel comfortable using it in a real app and know '
        'where to look when something does not behave the way you expect.';

    return List.generate(titles.length, (i) {
      final id = i + 1;
      return Post(
        id: id,
        title: titles[i],
        // Mix short and long descriptions to show the 4-line ellipsis.
        description: i.isEven ? longDescription : shortDescription,
        imageUrl: 'https://picsum.photos/seed/post$id/200',
      );
    });
  }
}
