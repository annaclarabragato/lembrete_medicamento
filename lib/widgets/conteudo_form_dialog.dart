import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/lembrete.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Lembrete lembreteAtual;

  ConteudoFormDialog({Key? key, required this.lembreteAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final horaController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    descricaoController.text = widget.lembreteAtual.descricao;

    if (widget.lembreteAtual.datahora != null) {
      dataController.text = _dateFormat.format(widget.lembreteAtual.datahora!);
      horaController.text = _timeFormat.format(widget.lembreteAtual.datahora!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: descricaoController,
            decoration: InputDecoration(labelText: 'Descrição'),
            validator: (String? valor) {
              if (valor == null || valor.isEmpty) {
                return 'O campo descrição é obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: dataController,
            decoration: InputDecoration(
              labelText: 'Data',
              prefixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _selecionarData,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => dataController.clear(),
              ),
            ),
            readOnly: true,
          ),
          TextFormField(
            controller: horaController,
            decoration: InputDecoration(
              labelText: 'Horário',
              prefixIcon: IconButton(
                icon: Icon(Icons.access_time),
                onPressed: _selecionarHora,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => horaController.clear(),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  void _selecionarData() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 5 * 365)),
      lastDate: DateTime.now().add(Duration(days: 5 * 365)),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataController.text = _dateFormat.format(dataSelecionada);
      });
    }
  }

  void _selecionarHora() async {
    final horaSelecionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horaSelecionada != null) {
      setState(() {
        final horaFormatada = '${horaSelecionada.hour.toString().padLeft(2, '0')}:${horaSelecionada.minute.toString().padLeft(2, '0')}';
        horaController.text = horaFormatada;
      });
    }
  }

  Lembrete get novoLembrete {
    DateTime? dataSelecionada;
    DateTime? horaSelecionada;
    DateTime? dataHoraFinal;

    if (dataController.text.isNotEmpty) {
      dataSelecionada = _dateFormat.parse(dataController.text);
    }

    if (horaController.text.isNotEmpty) {
      final partesHora = horaController.text.split(':');
      horaSelecionada = DateTime(
        dataSelecionada?.year ?? DateTime.now().year,
        dataSelecionada?.month ?? DateTime.now().month,
        dataSelecionada?.day ?? DateTime.now().day,
        int.parse(partesHora[0]),
        int.parse(partesHora[1]),
      );
    }

    if (dataSelecionada != null && horaSelecionada != null) {
      dataHoraFinal = DateTime(
        dataSelecionada.year,
        dataSelecionada.month,
        dataSelecionada.day,
        horaSelecionada.hour,
        horaSelecionada.minute,
      );
    }

    return Lembrete(
      id: widget.lembreteAtual.id,
      descricao: descricaoController.text,
      datahora: dataHoraFinal,
    );
  }
}
