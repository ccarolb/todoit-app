import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/tarefa_model.dart';

class TarefaService {
  static const String baseUrl =
      'http://192.168.1.105/diversogeek/controller/tarefa.php';

  static Future<List<Tarefa>> buscarTarefas() async {
    final url = Uri.parse('$baseUrl?acao=listarTarefas');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final List dados = json.decode(resposta.body);
      return dados.map((json) => Tarefa.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar tarefas');
    }
  }

  static Future<Tarefa> buscarTarefaPorId(int id) async {
    final url = Uri.parse('$baseUrl?acao=buscarTarefaPorId&id=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return Tarefa.fromJson(dados.first);
    } else {
      throw Exception('Erro ao buscar tarefa com ID: $id');
    }
  }

  static Future<Tarefa> buscarTarefaPorTituloOuDescricao(
    String termoBusca,
  ) async {
    final url = Uri.parse('$baseUrl?acao=buscarTarefa&termoBusca=$termoBusca');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return Tarefa.fromJson(dados.first);
    } else {
      throw Exception('Erro ao buscar tarefa');
    }
  }

  static Future<void> excluirTarefa(int id) async {
    final url = Uri.parse('$baseUrl?acao=excluirTarefa&id=$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar tarefa com ID: $id');
    }
  }

  static Future<http.StreamedResponse> editarTarefa({
    required int id,
    required String titulo,
    required String descricao,
    File? imagem,
  }) async {
    final uri = Uri.parse('$baseUrl?acao=editarTarefa&id=$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields['titulo'] = titulo;
    request.fields['descricao'] = descricao;

    if (imagem != null) {
      request.files.add(
        await http.MultipartFile.fromPath('imagem', imagem.path),
      );
    }

    return await request.send();
  }

  static Future<http.Response> alterarStatusTarefa(int id, int status) async {
    final url = Uri.parse('$baseUrl?acao=alterarStatus&id=$id');
    return await http.post(url, body: {'status': status.toString()});
  }

  static Future<http.StreamedResponse> cadastrarTarefa({
    required String titulo,
    required String descricao,
    File? imagem,
  }) async {
    final uri = Uri.parse('$baseUrl?acao=cadastrarTarefa');
    final request = http.MultipartRequest('POST', uri);

    request.fields['titulo'] = titulo;
    request.fields['descricao'] = descricao;

    if (imagem != null) {
      request.files.add(
        await http.MultipartFile.fromPath('imagem', imagem.path),
      );
    }

    return await request.send();
  }
}
