import 'package:lembrete_medicamento/database/database_provider.dart';
import '../model/lembrete.dart';

class LembreteDao {
  final dbProvider = DataBaseProvider.instance;

  // Método para salvar ou atualizar um lembrete
  Future<bool> salvar(Lembrete lembrete) async {
    final db = await dbProvider.database;
    final valores = lembrete.toMap();
    if (lembrete.id == null) {
      lembrete.id = await db.insert(Lembrete.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await db.update(
        Lembrete.nomeTabela,
        valores,
        where: '${Lembrete.CAMPO_ID} = ?',
        whereArgs: [lembrete.id],
      );
      return registrosAtualizados > 0;
    }
  }

  // Método para excluir um lembrete pelo id
  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final registrosAtualizados = await db.delete(
      Lembrete.nomeTabela,
      where: '${Lembrete.CAMPO_ID} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  // Método para listar os lembretes, com filtro e ordenação
  Future<List<Lembrete>> listar({
    String filtro = '',
    String campoOrdenacao = Lembrete.CAMPO_ID,
    bool usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Lembrete.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }
    final db = await dbProvider.database;
    final resultado = await db.query(
      Lembrete.nomeTabela,
      where: where,
      orderBy: orderBy,
      columns: [Lembrete.CAMPO_ID, Lembrete.CAMPO_DESCRICAO, Lembrete.CAMPO_DATAHORA],
    );
    return resultado.map((m) => Lembrete.fromMap(m)).toList();
  }

  // Método para buscar um lembrete pelo id
  Future<Lembrete?> buscarPorId(int id) async {
    final db = await dbProvider.database;
    final resultado = await db.query(
      Lembrete.nomeTabela,
      where: '${Lembrete.CAMPO_ID} = ?',
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      return Lembrete.fromMap(resultado.first);
    }
    return null;
  }
}
