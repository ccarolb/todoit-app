import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificacoesPlugin =
    FlutterLocalNotificationsPlugin();

//Método que configura o plugin de notificações
Future<void> inicializarNotificacoes() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);

  await notificacoesPlugin.initialize(settings);
}

//Método que passa os detalhes da notificação e o horário e título para agendar o lembrete
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
