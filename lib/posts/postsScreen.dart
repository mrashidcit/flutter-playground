import 'package:flutter/material.dart';
import 'package:flutter_play_ground/posts/post.dart';
import 'package:flutter_play_ground/posts/postsProvider.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<PostsProvider>().posts;

    return ListView.separated(
      // key: const PageStorageKey<String>('feed_tab'),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => PostListItem(post: posts[index]),
    );
  }
}

class PostListItem extends StatelessWidget {
  const PostListItem({super.key, required this.post});

  final Post post;

  static const double _thumbnailSize = 100;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      // No action yet; a non-null onTap shows the ripple.
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.imageUrl,
                width: _thumbnailSize,
                height: _thumbnailSize,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _placeholder(colorScheme),
                errorBuilder: (context, error, stackTrace) => _placeholder(
                  colorScheme,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colorScheme, {Widget? child}) {
    return Container(
      width: _thumbnailSize,
      height: _thumbnailSize,
      color: colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: child,
    );
  }
}
