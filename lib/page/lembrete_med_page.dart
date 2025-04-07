import 'package:flutter/material.dart';
import 'package:lembrete_medicamento/page/dados_pessoais_page.dart';
import 'package:lembrete_medicamento/widgets/conteudo_form_dialog.dart';
import 'package:lembrete_medicamento/model/lembrete.dart';
import 'package:intl/intl.dart';

class LembreteMedPage extends StatefulWidget {
  @override
  _LembreteMedPageState createState() => _LembreteMedPageState();
}

class _LembreteMedPageState extends State<LembreteMedPage> {
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final lembretes = <Lembrete>[];
  var _ultimoId = 0;
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Fundo rosa claro
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirForm(lembreteAtual: Lembrete(id: 0, descricao: '', datahora: null));
        },
        tooltip: 'Novo lembrete',
        backgroundColor: Colors.pink[300]!,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      backgroundColor: Colors.pink[300]!,
      centerTitle: true,
      title: const Text(
        '🌸 Pink Pill - Lembrete 🌸',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        IconButton(
          onPressed: _abrirDadosPessoais,
          icon: const Icon(Icons.person, color: Colors.white),
        )
      ],
    );
  }

  void _abrirDadosPessoais() {
    Navigator.of(context).pushNamed(DadosPessoaisPage.ROUTE_NAME);
  }

  Widget _criarBody() {
    if (lembretes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.pink[300], size: 60),
            const SizedBox(height: 10),
            Text(
              'Nenhum lembrete cadastrado!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink[300]),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: lembretes.length,
      itemBuilder: (BuildContext context, int index) {
        final lembrete = lembretes[index];

        final dataTexto = lembrete.datahora != null ? _dateFormat.format(lembrete.datahora!) : 'Sem data';
        final horaTexto = lembrete.datahora != null ? _timeFormat.format(lembrete.datahora!) : 'Sem horário';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          color: Colors.pink[100],
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Icon(Icons.notifications, color: Colors.pink[300], size: 30),
            title: Text(
              lembrete.descricao,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '📅 $dataTexto   ⏰ $horaTexto',
              style: TextStyle(fontSize: 14, color: Colors.pink[800]),
            ),
            trailing: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => criarMenuPopUp(),
              onSelected: (String valorSelecionado) {
                if (valorSelecionado == ACAO_EDITAR) {
                  _abrirForm(lembreteAtual: lembrete, indice: index);
                } else {
                  _excluir(index);
                }
              },
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
    );
  }

  void _excluir(int indice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.pink[50],
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Atenção', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          content: const Text('Deseja realmente excluir esse lembrete?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Não', style: TextStyle(color: Colors.pink[300])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  lembretes.removeAt(indice);
                });
              },
              child: const Text('Sim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  List<PopupMenuEntry<String>> criarMenuPopUp() {
    return [
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.pink[300]),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            ),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            ),
          ],
        ),
      ),
    ];
  }

  void _abrirForm({required Lembrete lembreteAtual, int? indice}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.pink[50],
          title: Text(
            indice == null ? 'Novo lembrete' : 'Alterar lembrete ${lembreteAtual.id}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[300]),
          ),
          content: ConteudoFormDialog(key: key, lembreteAtual: lembreteAtual),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: Colors.pink[300])),
            ),
            TextButton(
              child: Text('Salvar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[300])),
              onPressed: () {
                if (key.currentState != null && key.currentState!.dadosValidados()) {
                  setState(() {
                    final novoLembrete = key.currentState!.novoLembrete;
                    if (indice == null) {
                      novoLembrete.id = ++_ultimoId;
                      lembretes.add(novoLembrete);
                    } else {
                      lembretes[indice] = novoLembrete;
                    }
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
