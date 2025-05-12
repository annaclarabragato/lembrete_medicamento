import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lembrete_medicamento/model/lembrete.dart';
import 'package:lembrete_medicamento/widgets/conteudo_form_dialog.dart';
import 'package:lembrete_medicamento/dao/lembrete_dao.dart';  // Importando o LembreteDao

class LembreteMedPage extends StatefulWidget {
  @override
  _LembreteMedPageState createState() => _LembreteMedPageState();
}

class _LembreteMedPageState extends State<LembreteMedPage> {
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final lembretes = <Lembrete>[];
  final _dao = LembreteDao();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _timeFormat = DateFormat('HH:mm');
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLembretes();
  }

  // Função para carregar lembretes do banco de dados
  void _carregarLembretes() async {
    final listaLembretes = await _dao.listar(filtro: '');
    setState(() {
      lembretes.clear();
      lembretes.addAll(listaLembretes);
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
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
    );
  }

  Widget _criarBody() {
    if (_carregando) {
      return Center(child: CircularProgressIndicator());
    }

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
                  _excluir(lembrete);
                }
              },
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
    );
  }

  void _excluir(Lembrete lembrete) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Lembrete'),
          content: const Text('Deseja excluir este lembrete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );

    if (confirmacao == true) {
      await _dao.remover(lembrete.id!);
      _carregarLembretes();
    }
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
                      _dao.salvar(novoLembrete).then((_) {
                        _carregarLembretes();
                      });
                    } else {
                      _dao.salvar(novoLembrete).then((_) {
                        _carregarLembretes();
                      });
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
