import 'package:flutter/material.dart';
import 'package:lembrete_medicamento/page/dados_pessoais_page.dart';
import 'package:lembrete_medicamento/page/lembrete_med_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pink Pill - Lembrete',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        home: LembreteMedPage(),
        routes: {
          DadosPessoaisPage.ROUTE_NAME: (BuildContext context) => DadosPessoaisPage(),
        }
    );
  }
}