import 'package:flutter_play_ground/notifications/appNotification.dart';

/// Supplies notifications. For now they are dummy notifications kept in memory.
class NotificationsRepository {
  const NotificationsRepository();

  List<AppNotification> getNotifications() => const [
    AppNotification(
      id: 1,
      title: 'Welcome to Flutter Playground',
      description: 'Thanks for installing the app. Explore the demos from the home screen.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 2,
      title: 'Unusual sign-in attempt detected on your account from a new device',
      description:
          'Someone tried to sign in from an unrecognized device. If this was not you, change your password right away and review your recent account activity.',
      type: NotificationType.alert,
    ),
    AppNotification(
      id: 3,
      title: 'Storage almost full',
      description: 'You have used 92% of your storage. Free up space to keep syncing.',
      type: NotificationType.warning,
    ),
    AppNotification(
      id: 4,
      title: 'New post published',
      description: 'A new post about PageStorageKey is now available in your feed.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 5,
      title: 'Payment failed',
      description:
          'We could not process your last payment. Please update your billing details to avoid interruption of service.',
      type: NotificationType.alert,
    ),
    AppNotification(
      id: 6,
      title: 'Battery saver is limiting background refresh for this app',
      description: 'Some notifications may arrive late while battery saver is on.',
      type: NotificationType.warning,
    ),
    AppNotification(
      id: 7,
      title: 'Update available',
      description:
          'Version 1.2.0 brings faster loading, a refreshed design, bug fixes and several improvements to stability across all screens of the app.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 8,
      title: 'Password changed',
      description: 'Your password was changed. If you did not do this, contact support.',
      type: NotificationType.alert,
    ),
    AppNotification(
      id: 9,
      title: 'Weak network connection',
      description: 'Your connection is unstable. Some content may not load.',
      type: NotificationType.warning,
    ),
    AppNotification(
      id: 10,
      title: 'Weekly summary ready',
      description: 'See what you read and saved this week.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 11,
      title: 'Server outage in your region',
      description:
          'We are experiencing an outage affecting users in your region. Our team is working on a fix and we will keep you posted on the progress here.',
      type: NotificationType.alert,
    ),
    AppNotification(
      id: 12,
      title: 'Subscription expires soon',
      description: 'Your subscription ends in 3 days. Renew to keep premium features.',
      type: NotificationType.warning,
    ),
    AppNotification(
      id: 13,
      title: 'New follower',
      description: 'Ali started following you.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 14,
      title: 'Account locked after too many failed login attempts',
      description: 'Your account is locked for 30 minutes for your security.',
      type: NotificationType.alert,
    ),
    AppNotification(
      id: 15,
      title: 'Outdated app version',
      description:
          'You are using an older version of the app. Some features may stop working soon, so please update from the store at your earliest convenience.',
      type: NotificationType.warning,
    ),
    AppNotification(
      id: 16,
      title: 'Backup completed',
      description: 'All your data was backed up successfully.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 17,
      title: 'Suspicious file blocked',
      description: 'A download was blocked because it may contain harmful content.',
      type: NotificationType.alert,
    ),
    AppNotification(
      id: 18,
      title: 'Location permission is off',
      description: 'Turn on location to get nearby recommendations.',
      type: NotificationType.warning,
    ),
    AppNotification(
      id: 19,
      title: 'Tip of the day: use keys to preserve widget state across rebuilds',
      description:
          'Keys like ValueKey, ObjectKey and PageStorageKey help Flutter match widgets between rebuilds so their state, such as scroll position, is kept.',
      type: NotificationType.info,
    ),
    AppNotification(
      id: 20,
      title: 'Scheduled maintenance tonight',
      description: 'The app may be unavailable from 1 AM to 3 AM for maintenance.',
      type: NotificationType.warning,
    ),
  ];
}
