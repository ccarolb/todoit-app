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

  void _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await UsuarioService.cadastrarUsuario(
      _nomeController.text.trim(),
      _emailController.text.trim(),
      _senhaController.text.trim(),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Usuario registrado com sucesso!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Fechar',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Já existe um usuário com o email "${_emailController.text}"!',
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
          content: Text(
            'Erro ao cadastrar usuário. Tente novamente!',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 16, 30, 40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome",
                  hintText: 'Insira seu nome completo',
                  border: OutlineInputBorder(),
                ),
                controller: _nomeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        1 <= (value?.length ?? 0)
                            ? null
                            : 'O título não pode ficar em branco.',
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        1 <= (value?.length ?? 0)
                            ? null
                            : 'O e-mail não pode ficar em branco.',
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Senha",
                  hintText: "Insira uma senha",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                controller: _senhaController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Cadastrar'),
                  onPressed: () {
                    _cadastrarUsuario();
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
