import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocalizacaoUsuarioPage extends StatefulWidget {
  const LocalizacaoUsuarioPage({Key? key}) : super(key: key);

  @override
  _LocalizacaoUsuarioPageState createState() => _LocalizacaoUsuarioPageState();
}

class _LocalizacaoUsuarioPageState extends State<LocalizacaoUsuarioPage> {
  String _localizacao = 'Localização não obtida';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização Atual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _obterLocalizacao,
              child: const Text('Obter localização atual'),
            ),
            const SizedBox(height: 20),
            Text(
              _localizacao,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _obterLocalizacao() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarDialogMensagem(
          'Ative o serviço de localização para obter sua posição.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _mostrarMensagem('Permissão de localização negada.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem(
          'Permita o acesso à localização nas configurações do app.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _localizacao =
      'Latitude: ${position.latitude}\nLongitude: ${position.longitude}';
    });
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
