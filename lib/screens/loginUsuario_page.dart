import 'package:flutter/material.dart';

import '../services/usuario_service.dart';
import 'cadastroUsuario_page.dart';
import 'home_page.dart';

class LoginUsuarioPage extends StatefulWidget {
  const LoginUsuarioPage({Key? key}) : super(key: key);

  @override
  State<LoginUsuarioPage> createState() => _LoginUsuarioPageState();
}

class _LoginUsuarioPageState extends State<LoginUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override // Limpa os controllers do campo após realizar o cadastro e para evitar vazamentos de memória
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _loginUsuario() async {
    final response = await UsuarioService.loginUsuario(
      _emailController.text.trim(),
      _senhaController.text.trim(),
    );

    if (response.statusCode == 200) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => HomePage()));
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Usuário não encontrado. Verifique suas credenciais.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Fechar',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Erro ao realizar login. Tente novamente.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Fechar',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 250),
        child: Material(
          color:
              Theme.of(
                context,
              ).scaffoldBackgroundColor, //Força que a cor de fundo seja a definida pelo tema do app (claro ou escuro)
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Bem vindo ao to-do-it!',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    height: 1.62,
                    letterSpacing: 0.50,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'janedoe@foruslabs.com',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value?.contains('@') ?? false)
                                        ? null
                                        : 'Digite um e-mail válido.',
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _senhaController,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text('Entrar'),
                            onPressed: () {
                              _loginUsuario();
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => const CadastroUsuarioPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Não tem uma conta? Cadastre-se aqui',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
