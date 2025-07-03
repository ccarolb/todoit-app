import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled2/services/preferencias_service.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  static const String baseUrl =
      'http://192.168.1.105/diversogeek/controller/usuario.php';

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

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final emailRetornado = body['email'] ?? '';
      await PreferenciasService.salvarDadosUsuario(email: emailRetornado);
    }

    return response;
  }
}
