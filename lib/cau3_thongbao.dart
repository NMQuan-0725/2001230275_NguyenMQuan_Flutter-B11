import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Modernized Initialization
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );
  }

  static Future<void> playSuccessSound() async {
    await _audioPlayer.play(AssetSource('sounds/success_beep.mp3'));
  }

  static Future<void> showReminder(String className) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          '14DHTH',
          'Thong bao lop',
          importance: Importance.max,
          priority: Priority.high,
        );

    // Modernized Show Method (positional NotificationDetails)
    await _notificationsPlugin.show(
      id: 0,
      title: 'Sinh viên chú ý',
      body: 'Đã đến giờ vào lớp môn $className!',
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }
}
