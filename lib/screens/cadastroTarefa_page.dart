import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/lembrete_service.dart';
import '../services/tarefa_service.dart';
import 'package:timezone/timezone.dart' as tz;

class CadastroTarefaPage extends StatefulWidget {
  const CadastroTarefaPage({super.key});

  @override
  _CadastroTarefaPageState createState() => _CadastroTarefaPageState();
}

class _CadastroTarefaPageState extends State<CadastroTarefaPage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  File? _imagemSelecionada;

  String tituloTarefa = '';
  bool lembrarTarefa = false;
  DateTime? horarioLembrete;

  Future<void> _selecionarImagem(ImageSource origem) async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: origem);

    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<void> _cadastrarTarefa() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      tituloTarefa = _tituloController.text.trim();
      final resposta = await TarefaService.cadastrarTarefa(
        titulo: tituloTarefa,
        descricao: _descricaoController.text.trim(),
        imagem: _imagemSelecionada,
      );

      if (resposta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarefa registrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _tituloController.clear();
        _descricaoController.clear();
        setState(() => _imagemSelecionada = null);
      } else if (resposta.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Já existe uma tarefa com esse título!'),
            backgroundColor: Colors.red,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova tarefa')),
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
              Row(
                children: [
                  Checkbox(
                    value: lembrarTarefa,
                    onChanged: (valor) {
                      setState(() {
                        lembrarTarefa = valor ?? false;
                      });
                    },
                  ),
                  const Text('Lembrar-me dessa tarefa'),
                  const SizedBox(width: 16),
                  if (lembrarTarefa)
                    TextButton(
                      onPressed: () async {
                        final agora = tz.TZDateTime.from(
                          DateTime.now(),
                          tz.getLocation("America/Sao_Paulo"),
                        );
                        final horarioSelecionado = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: agora.hour,
                            minute: agora.minute,
                          ),
                          helpText: 'Selecione o horário do lembrete',
                        );
                        if (horarioSelecionado != null) {
                          horarioLembrete = DateTime(
                            agora.year,
                            agora.month,
                            agora.day,
                            horarioSelecionado.hour,
                            horarioSelecionado.minute,
                          );
                          setState(() {});
                        }
                      },
                      child: Text(
                        horarioLembrete != null
                            ? 'Lembrete: ${horarioLembrete!.hour}:${horarioLembrete!.minute.toString().padLeft(2, '0')}'
                            : 'Definir horário',
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _cadastrarTarefa();
                  if (lembrarTarefa && horarioLembrete != null) {
                    final horario = tz.TZDateTime.local(
                      horarioLembrete!.year,
                      horarioLembrete!.month,
                      horarioLembrete!.day,
                      horarioLembrete!.hour,
                      horarioLembrete!.minute,
                    );

                    await agendarLembreteTarefa(
                      titulo: tituloTarefa,
                      horario: horario,
                    );
                  }
                },
                child: Text('Salvar tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
