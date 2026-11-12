import 'package:equatable/equatable.dart';

enum NotificationType {
  info('ℹ️'),
  alert('🚨'),
  warning('⚠️');

  const NotificationType(this.emoji);

  /// Icon shown on the left of a notification list item.
  final String emoji;
}

/// Named `AppNotification` to avoid clashing with Flutter's `Notification`.
class AppNotification extends Equatable {
  final int id;
  final String title;
  final String description;
  final NotificationType type;

  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, description, type];
}
