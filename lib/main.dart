import 'package:flutter/material.dart';
import 'package:sistema_notas/views/addNota.dart';
import 'package:sistema_notas/views/editNota.dart';
import 'package:sistema_notas/views/listNotas.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'listNotas',
      routes: {
        'listNotas': (BuildContext context) => ListNotas(),
        'addNota': (BuildContext context) => AddNota(),
        'editNota': (BuildContext context) => EditNota(),
      },
    );
  }
}
