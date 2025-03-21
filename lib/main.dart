import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_si7/pages/filtro_page.dart';
import 'package:gerenciador_tarefas_si7/pages/lista_tarefas_page.dart';
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
        title: 'App Gerenciador de Tarefas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        home: LembreteMedPage(),
        routes: {
          FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
        }
    );
  }
}