import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificacoesPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> inicializarNotificacoes() async {
  tz.initializeTimeZones();

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);

  await notificacoesPlugin.initialize(settings);
}

Future<void> agendarLembreteTarefa({
  required String titulo,
  required DateTime horario,
}) async {
  final detalhes = NotificationDetails(
    android: AndroidNotificationDetails(
      'canal_tarefas',
      'Lembretes de tarefas',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  await notificacoesPlugin.zonedSchedule(
    1,
    'Lembrete: $titulo',
    'Hora de concluir essa tarefa!',
    tz.TZDateTime.from(horario, tz.local),
    detalhes,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
