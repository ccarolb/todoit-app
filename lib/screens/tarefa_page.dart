import 'package:flutter/material.dart';
import '../models/tarefa_model.dart';
import '../services/tarefa_service.dart';

class TarefaPage extends StatelessWidget {
  final int tarefaId;

  const TarefaPage({super.key, required this.tarefaId});

  Future<Tarefa> _carregarTarefa() => TarefaService.buscarTarefaPorId(tarefaId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualizando tarefa"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Material(
        color: Colors.white,
        child: FutureBuilder<Tarefa>(
          future: _carregarTarefa(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar tarefa.'));
            }
            if (snapshot.hasData && snapshot.data != null) {
              final tarefa = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 16, 30, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Divider(),
                    Text(
                      tarefa.descricao,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tarefa.titulo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    Text(
                      tarefa.descricao,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          },
        ),
      ),
    );
  }
}
