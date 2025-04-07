import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DadosPessoaisPage extends StatefulWidget {
  static const ROUTE_NAME = '/dados_pessoais';
  static const CHAVE_NOME = 'nome';
  static const CHAVE_EMAIL = 'email';
  static const CHAVE_TELEFONE = 'telefone';
  static const CHAVE_FOTO = 'foto';

  @override
  _DadosPessoaisPageState createState() => _DadosPessoaisPageState();
}

class _DadosPessoaisPageState extends State<DadosPessoaisPage> {
  late final SharedPreferences prefs;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  String? _caminhoFoto;
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeController.text = prefs.getString(DadosPessoaisPage.CHAVE_NOME) ?? '';
      _emailController.text = prefs.getString(DadosPessoaisPage.CHAVE_EMAIL) ?? '';
      _telefoneController.text = prefs.getString(DadosPessoaisPage.CHAVE_TELEFONE) ?? '';
      _caminhoFoto = prefs.getString(DadosPessoaisPage.CHAVE_FOTO);
    });
  }

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _caminhoFoto = imagem.path;
        prefs.setString(DadosPessoaisPage.CHAVE_FOTO, imagem.path);
        _alterouValores = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onVoltarClick,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.pink[300],
          title: const Text(
            '❥ Dados Pessoais',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: _criaBody(),
      ),
    );
  }

  Widget _criaBody() {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Center(
          child: GestureDetector(
            onTap: _tirarFoto,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.pink[200],
              backgroundImage: _caminhoFoto != null ? FileImage(File(_caminhoFoto!)) : null,
              child: _caminhoFoto == null
                  ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Nome',
          controller: _nomeController,
          onChanged: _onNomeChanged,
        ),
        const Divider(),
        _buildTextField(
          label: 'E-mail',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: _onEmailChanged,
        ),
        const Divider(),
        _buildTextField(
          label: 'Telefone',
          controller: _telefoneController,
          keyboardType: TextInputType.phone,
          onChanged: _onTelefoneChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    required ValueChanged<String?> onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.pinkAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onNomeChanged(String? valor) {
    prefs.setString(DadosPessoaisPage.CHAVE_NOME, valor ?? '');
    _alterouValores = true;
  }

  void _onEmailChanged(String? valor) {
    prefs.setString(DadosPessoaisPage.CHAVE_EMAIL, valor ?? '');
    _alterouValores = true;
  }

  void _onTelefoneChanged(String? valor) {
    prefs.setString(DadosPessoaisPage.CHAVE_TELEFONE, valor ?? '');
    _alterouValores = true;
  }
}
