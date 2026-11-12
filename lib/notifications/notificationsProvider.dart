import 'package:flutter/foundation.dart';
import 'package:flutter_play_ground/data/repository/notificationsRepository.dart';
import 'package:flutter_play_ground/notifications/appNotification.dart';

/// Holds an in-memory list of notifications loaded from [NotificationsRepository].
class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider({
    NotificationsRepository repository = const NotificationsRepository(),
  }) : _notifications = repository.getNotifications();

  final List<AppNotification> _notifications;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
}
