import 'package:flutter/material.dart';
import '../services/usuario_service.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  _CadastroUsuarioPageState createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await UsuarioService.cadastrarUsuario(
      _nomeController.text.trim(),
      _emailController.text.trim(),
      _senhaController.text.trim(),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Usuário registrado com sucesso!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Já existe um usuário com o email "${_emailController.text}"!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Erro ao cadastrar usuário. Tente novamente!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
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
          color: Theme.of(context).scaffoldBackgroundColor,

          child: Center(
            child: Column(
              children: [
                const Text(
                  'Crie sua conta no to-do-it!',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    height: 1.62,
                    letterSpacing: 0.50,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome completo',
                              hintText: 'Ex: Jane Doe',
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    value != null && value.isNotEmpty
                                        ? null
                                        : 'Informe seu nome completo.',
                          ),
                          const SizedBox(height: 10),
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
                              hintText: 'Crie uma senha segura',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    (value != null && value.length >= 4)
                                        ? null
                                        : 'A senha precisa ter pelo menos 4 caracteres.',
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text('Cadastrar'),
                            onPressed: _cadastrarUsuario,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // retorna à tela de login
                            },
                            child: const Text(
                              'Já tem uma conta? Voltar ao login.',
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
