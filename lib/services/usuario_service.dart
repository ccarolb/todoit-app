import 'package:http/http.dart' as http;

//Classe que gerencia as operações relacionadas aos usuários
class UsuarioService {
  static const String baseUrl =
      'http://192.168.1.100/diversogeek/controller/usuario.php';

  static Future<http.Response> cadastrarUsuario(
    String nome,
    String email,
    String senha,
  ) async {
    final url = Uri.parse('$baseUrl?acao=cadastrarUsuario');
    return await http.post(
      url,
      body: {'nome': nome, 'email': email, 'senha': senha},
    );
  }

  static Future<http.Response> loginUsuario(String email, String senha) async {
    final url = Uri.parse('$baseUrl?acao=login');

    if (email.isEmpty || senha.isEmpty) {
      throw Exception('Email e senha não podem ser vazios');
    }
    final response = await http.post(
      url,
      body: {'email': email, 'senha': senha},
    );

    return response;
  }
}
