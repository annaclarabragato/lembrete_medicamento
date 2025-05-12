import 'package:intl/intl.dart';

class Lembrete {

  static const CAMPO_ID = '_id';
  static const CAMPO_DESCRICAO = 'descrição';
  static const CAMPO_DATAHORA = 'data e hora';
  static const nomeTabela = 'lembrete';

  int id;
  String descricao;
  DateTime? datahora;

  Lembrete({required this.id, required this.descricao, this.datahora});

  String get dataFormatado {
    if (datahora == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(datahora!);  // Formata apenas a data
  }

  String get horaFormatada {
    if (datahora == null) {
      return '';
    }
    return DateFormat('HH:mm').format(datahora!);  // Formata apenas a hora
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    CAMPO_ID: id,
    CAMPO_DESCRICAO: descricao,
    CAMPO_DATAHORA: datahora == null
        ? null
        : DateFormat("dd/MM/yyyy HH:mm").format(datahora!),
  };

  factory Lembrete.fromMap(Map<String, dynamic> map) => Lembrete(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    datahora: map[CAMPO_DATAHORA] == null
        ? null
        : DateFormat("dd/MM/yyyy HH:mm").parse(map[CAMPO_DATAHORA]),
  );

}
