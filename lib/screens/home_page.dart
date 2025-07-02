import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/edicaoTarefa_page.dart';
import '../models/tarefa_model.dart';
import '../services/tarefa_service.dart';
import '../widgets/card_tarefa.dart';
import '../widgets/refresh_wrapper.dart';
import '../widgets/tarefa_search_delegate.dart';
import 'cadastroTarefa_page.dart';
import '../services/preferencias_service.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? alternarModo;

  const HomePage({Key? key, this.alternarModo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tarefa> tarefas = [];
  String? nomeUsuario;
  late bool modoEscuro;

  @override
  void initState() {
    super.initState();
    carregarTarefas();
    PreferenciasService.carregarTemaPreferido().then((valor) {
      setState(() {
        modoEscuro = valor;
      });
    });
  }

  Future<void> carregarTarefas() async {
    try {
      final resultado = await TarefaService.buscarTarefas();
      setState(() => tarefas = resultado);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao buscar tarefas',
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

  void _alterarStatusTarefa(
    BuildContext context,
    Tarefa tarefa,
    int tarefaId,
  ) async {
    try {
      final novoStatus =
          tarefa.status == 0 ? 1 : 0; // Alterna entre pendente e concluída
      await TarefaService.alterarStatusTarefa(tarefaId, novoStatus);

      carregarTarefas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao alterar status da tarefa. Tente novamente!',
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

  void _confirmarExclusao(BuildContext context, int tarefaId) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Tem certeza de que quer excluir a tarefa?'),
            content: const Text('Essa ação não pode ser desfeita.'),
            actions: [
              OutlinedButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              TextButton(
                child: const Text('Continuar'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Fecha o diálogo
                  try {
                    await TarefaService.excluirTarefa(tarefaId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Tarefa excluída com sucesso!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        action: SnackBarAction(
                          label: 'Fechar',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                    carregarTarefas();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Erro ao excluir tarefa. Tente novamente!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                },
              ),
            ],
          ),
    );
  }

  Widget _construirListaTarefas(List<Tarefa> lista) {
    return RefreshWrapper(
      onRefresh: carregarTarefas,
      child:
          lista.isEmpty
              ? ListView(
                children: const [
                  SizedBox(height: 150),
                  Center(child: Text('Nenhuma tarefa encontrada.')),
                ],
              )
              : ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  final tarefa = lista[index];
                  return construirCardTarefas(
                    tarefa.titulo,
                    tarefa.descricao,
                    () => _confirmarExclusao(context, tarefa.id),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EdicaoTarefaPage(tarefaId: tarefa.id),
                      ),
                    ),
                    () => _alterarStatusTarefa(context, tarefa, tarefa.id),
                    search: false,
                    concluida: tarefa.status == 1,
                  );
                },
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefasPendentes = tarefas.where((t) => t.status == 0).toList();
    final tarefasConcluidas = tarefas.where((t) => t.status == 1).toList();
    final todasOrdenadas = [...tarefasPendentes, ...tarefasConcluidas];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('to do it!'),
          centerTitle: true,
          automaticallyImplyLeading: false, //Esconde botão de voltar da appbar
          bottom: const TabBar(
            tabs: [
              Tab(text: 'todas'),
              Tab(text: 'pendentes'),
              Tab(text: 'concluídas'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Pesquisar tarefas',
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: TarefaSearchDelegate(
                    tarefas,
                    aoEditar: (tarefa) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EdicaoTarefaPage(tarefaId: tarefa.id),
                        ),
                      );
                    },
                    aoExcluir:
                        (tarefa) => _confirmarExclusao(context, tarefa.id),
                    aoAlterarStatus:
                        (tarefa) =>
                            _alterarStatusTarefa(context, tarefa, tarefa.id),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              tooltip: 'Alternar modo noturno',
              onPressed: () {
                modoEscuro = !modoEscuro;

                PreferenciasService.salvarPreferenciaTemaApp(modoEscuro);
                MyApp.of(
                  context,
                ).changeTheme(modoEscuro ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: TabBarView(
            children: [
              _construirListaTarefas(todasOrdenadas),
              _construirListaTarefas(tarefasPendentes),
              _construirListaTarefas(tarefasConcluidas),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CadastroTarefaPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Nova tarefa',
        ),
      ),
    );
  }
}
