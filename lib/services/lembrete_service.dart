import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificacoesPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> inicializarNotificacoes() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);

  await notificacoesPlugin.initialize(settings);
}

Future<void> dispararNotificacaoInstantanea(String titulo) async {
  final detalhes = NotificationDetails(
    android: AndroidNotificationDetails(
      'canal_tarefas',
      'Notificações Instantâneas',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    ),
  );

  print(tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));
  // print(tz.TZDateTime.local.now());

  await notificacoesPlugin.show(
    0,
    'Título da Notificação',
    'Corpo da Notificação',
    detalhes,
  );
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
      playSound: true,
      icon: '@mipmap/ic_launcher',
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
