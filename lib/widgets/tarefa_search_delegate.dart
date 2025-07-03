import 'package:flutter/material.dart';
import '../models/tarefa_model.dart';
import '../widgets/card_tarefa.dart';

//Classe que implementa a SearchDelegate para pesquisar tarefas
class TarefaSearchDelegate extends SearchDelegate {
  final List<Tarefa> tarefas;
  final Function(Tarefa) aoEditar;
  final Function(Tarefa) aoExcluir;
  final Function(Tarefa) aoAlterarStatus;

  TarefaSearchDelegate(
    this.tarefas, {
    required this.aoEditar,
    required this.aoExcluir,
    required this.aoAlterarStatus,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultados =
        tarefas
            .where(
              (t) =>
                  t.titulo.toLowerCase().contains(query.toLowerCase()) ||
                  t.descricao.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    if (resultados.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa encontrada.'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListView.builder(
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final tarefa = resultados[index];
              return construirCardTarefas(
                tarefa.titulo,
                tarefa.descricao,
                () => aoExcluir(tarefa),
                () => aoEditar(tarefa),
                () => aoAlterarStatus(tarefa),
                search: true,
                concluida: tarefa.status == 1,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugestoes =
        tarefas
            .where((t) => t.titulo.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final tarefa = sugestoes[index];
        return ListTile(
          title: Text(tarefa.titulo),
          onTap: () {
            query = tarefa.titulo;
            showResults(context);
          },
        );
      },
    );
  }
}
