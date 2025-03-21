import 'package:flutter/material.dart';
import 'package:lembrete_medicamento/model/tarefa.dart';
import 'package:lembrete_medicamento/page/dados_pessoais_page.dart';
import 'package:lembrete_medicamento/widgets/conteudo_form_dialog.dart';

class LembreteMedPage extends StatefulWidget{

  @override
  _LembreteMedPageState createState() => _LembreteMedPageState();
}

class _LembreteMedPageState extends State<LembreteMedPage>{


  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final tarefas = <Tarefa> [
    // Tarefa(id: 1, descricao: 'Tarefa avaliativa da disciplina'
    //, prazo: DateTime.now().add(const Duration(days: 5))
    //)
  ];

  var _ultimoId = 0;

  Widget _criarBody() {
    if (tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum lembrete cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemCount: tarefas.length,
      itemBuilder: (BuildContext context, int index) {
        final tarefa = tarefas[index];
        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text('Lembrete ativo'),
          ),
          itemBuilder: (BuildContext context) => criarMenuPopUp(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == ACAO_EDITAR) {
              _abrirForm(tarefaAtual: tarefa, indice: index);
            } else {
              _excluir(index);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  void _excluir (int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                ),
              ],
            ),
            content: const Text('Deseja realmente excluir esse registro?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Não')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      tarefas.removeAt(indice);
                    });
                  },
                  child: const Text('Sim')
              )
            ],
          );
        }
    );
  }

  void _abrirForm({Tarefa? tarefaAtual, int? indice} ){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(tarefaAtual == null ? 'Nova tarefa':
            'Alterar a tarefa ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (key.currentState != null && key.currentState!.dadosValidados()) {
                    setState(() {
                      final novaTarefa = key.currentState!.novaTarefa;
                      if (indice == null){
                        novaTarefa.id = ++_ultimoId;
                        tarefas.add(novaTarefa);
                      }else{
                        tarefas[indice] = novaTarefa;
                      }
                    });
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


}

