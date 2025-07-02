import 'package:flutter/material.dart';
import 'package:untitled2/screens/cadastroUsuario_page.dart';
import 'package:untitled2/screens/loginUsuario_page.dart';
import '../screens/onboarding_page.dart';
import '../screens/home_page.dart';
import '../screens/cadastroTarefa_page.dart';
import '../screens/edicaoTarefa_page.dart';
import '../screens/tarefa_page.dart';

class Rotas {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String cadastrarTarefas = '/cadastrar-tarefas';
  static const String editarTarefas = '/editar-tarefas';
  static const String exibirTarefa = '/exibir-tarefa';
  static const String cadastrarUsuario = '/cadastrar-usuario';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginUsuarioPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case exibirTarefa:
        final tarefaId = settings.arguments as int; // Recebe o id do tarefa
        return MaterialPageRoute(
          builder: (context) => TarefaPage(tarefaId: tarefaId),
        );
      case cadastrarTarefas:
        return MaterialPageRoute(builder: (_) => const CadastroTarefaPage());
      case editarTarefas:
        final tarefaId = settings.arguments as int; // Recebe o id do tarefa
        return MaterialPageRoute(
          builder: (context) => EdicaoTarefaPage(tarefaId: tarefaId),
        );
      case cadastrarUsuario:
        return MaterialPageRoute(builder: (_) => const CadastroUsuarioPage());
      default:
        return null;
    }
  }

  static Route criaEfeitoFadeParaRotas(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(
        milliseconds: 800,
      ), // Duração da animação
    );
  }
}
