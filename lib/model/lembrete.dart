import 'package:intl/intl.dart';

class Lembrete {

  static const CAMPO_ID = '_id';
  static const CAMPO_DESCRICAO = 'descrição';
  static const CAMPO_DATAHORA = 'data e hora';

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
}
