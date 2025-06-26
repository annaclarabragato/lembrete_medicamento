import '../database/database_provider.dart';
import '../model/lembrete.dart';

class LembreteDao {
  Future<List<Lembrete>> listar({String filtro = ''}) async {
    final db = await DataBaseProvider.instance.database;
    final resultado = await db.query(
      Lembrete.nomeTabela,
      orderBy: '${Lembrete.CAMPO_DATAHORA} ASC',
    );

    return resultado.map((map) => Lembrete.fromMap(map)).toList();
  }

  Future<void> salvar(Lembrete lembrete) async {
    final db = await DataBaseProvider.instance.database;

    if (lembrete.id == 0) {
      await db.insert(Lembrete.nomeTabela, lembrete.toMap());
    } else {
      await db.update(
        Lembrete.nomeTabela,
        lembrete.toMap(),
        where: '${Lembrete.CAMPO_ID} = ?',
        whereArgs: [lembrete.id],
      );
    }
  }

  Future<void> remover(int id) async {
    final db = await DataBaseProvider.instance.database;
    await db.delete(
      Lembrete.nomeTabela,
      where: '${Lembrete.CAMPO_ID} = ?',
      whereArgs: [id],
    );
  }
}
