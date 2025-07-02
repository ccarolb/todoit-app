import 'package:flutter/material.dart';
import 'package:untitled2/screens/home_page.dart';
import 'package:untitled2/screens/loginUsuario_page.dart';
import '../routes/rotas.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(Icons.book, size: 30)],
              ),
              Text(
                'Bem-vindo ao todo-it',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Sua lista de tarefas minimalista',
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(Rotas.criaEfeitoFadeParaRotas(HomePage()));
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
