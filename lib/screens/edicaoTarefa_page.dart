import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/tarefa_service.dart';

class EdicaoTarefaPage extends StatefulWidget {
  final int tarefaId; // Recebe o id da tarefa a ser editada

  const EdicaoTarefaPage({super.key, required this.tarefaId});

  _EdicaoTarefaPageState createState() => _EdicaoTarefaPageState();
}

class _EdicaoTarefaPageState extends State<EdicaoTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _imagemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDadosTarefa(); // Carrega os dados iniciais da tarefa no formulário
  }

  File? _imagemSelecionada;

  Future<void> _selecionarImagem(ImageSource origem) async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(
      source: origem,
    ); // Seleciona a imagem da câmera ou galeria, a origem é passada como parâmetro

    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<void> _editarTarefa() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final resposta = await TarefaService.editarTarefa(
        id: widget.tarefaId,
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        imagem: _imagemSelecionada,
      );

      final corpo = await resposta.stream.bytesToString();

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarefa editada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $corpo'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _carregarDadosTarefa() async {
    try {
      final tarefa = await TarefaService.buscarTarefaPorId(widget.tarefaId);
      setState(() {
        _tituloController.text = tarefa.titulo;
        _descricaoController.text = tarefa.descricao;
        _imagemController.text = tarefa.imagem ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar dados da tarefa: $e',
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
      appBar: AppBar(title: const Text('Editar tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(hintText: 'Título da tarefa'),
                validator:
                    (value) => value!.isEmpty ? 'Informe um título' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 12,
                  ),
                ),
                maxLines: 6,
                validator:
                    (value) => value!.isEmpty ? 'Informe uma descrição' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selecionarImagem(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Tirar foto'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selecionarImagem(ImageSource.gallery),
                    icon: Icon(Icons.photo_library),
                    label: Text('Anexar foto'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _imagemSelecionada != null
                          ? _imagemSelecionada!.path.split('/').last
                          : 'Nenhum arquivo selecionado',
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _editarTarefa,
                child: Text('Salvar tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
