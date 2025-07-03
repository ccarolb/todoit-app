import 'package:flutter/material.dart';

Widget construirCardTarefas(
  String titulo,
  String descricao,
  Function excluir,
  Function editar,
  Function alterarStatus, {
  required bool concluida,
  required bool search,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 8),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child:
        search
            ? construirConteudoCard(
              titulo: titulo,
              descricao: descricao,
              concluida: concluida,
              botaoEditar: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  editar();
                },
              ),
            )
            : construirConteudoCard(
              titulo: titulo,
              descricao: descricao,
              concluida: concluida,
              checkBox: Checkbox(
                value: concluida,
                onChanged: (_) => alterarStatus(),
              ),
              botaoEditar: IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  editar();
                },
              ),
              botaoExcluir: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => excluir(),
              ),
            ),
  );
}

Widget construirConteudoCard({
  required String titulo,
  required String descricao,
  required bool concluida,
  Widget? checkBox,
  Widget? botaoEditar,
  Widget? botaoExcluir,
}) {
  final estiloTexto = TextStyle(
    decoration: concluida ? TextDecoration.lineThrough : TextDecoration.none,
    color: concluida ? Colors.grey : null,
  );
  return Row(
    children: [
      checkBox ?? SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.62,
                letterSpacing: 0.50,
                decoration:
                    concluida
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
              ),
            ),
            Opacity(
              opacity: 0.50,
              child: Text(
                descricao,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0.30,
                ),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
      botaoEditar ?? SizedBox(width: 0),
      botaoExcluir ?? SizedBox(width: 0),
    ],
  );
}
