import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_notas/controllers/notasController.dart';
import 'package:sistema_notas/models/Notas.dart';
import 'package:sistema_notas/views/detailNota.dart';
import 'package:sistema_notas/views/editNota.dart';
import 'package:sistema_notas/views/utils/snackbar.dart' as utilsnackbar;

void main() => runApp(ListNotas());

class ListNotas extends StatefulWidget {
  @override
  _ListNotasState createState() => _ListNotasState();
}

class _ListNotasState extends State<ListNotas> {
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  NotasController notasController = new NotasController();
  Future<List<Notas>> _listadoNotas;

  @override
  void initState() {
    super.initState();
    _listadoNotas = notasController.getNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Libro de notas'),
        leading: IconButton(
          icon: Icon(Icons.book),
          onPressed: () {},
          color: Colors.white,
        ),
        //actions: [IconButton(icon: Icon(Icons.help), onPressed: null)],
      ),
      body: _body(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: _listadoNotas,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            key: refreshkey,
            onRefresh: refreshlist,
            child: ListView(
              children: _listNotas(snapshot.data),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Widget> _listNotas(List<Notas> data) {
    List<Widget> notas = [];
    for (var nota in data) {
      notas.add(ListTile(
        onTap: () {
          print(nota.id);
          //Navigator.pushNamed(context, 'editNota');
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => new DetailNota(
                id: nota.id,
                titulo: nota.titulo,
                nota: nota.nota,
                imagen: nota.imagen,
              ),
            ),
          );
        },
        title: Text(nota.titulo),
        leading: CircleAvatar(
          child: Text(nota.titulo.substring(0, 1)),
        ),
      ));
    }
    return notas;
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, 'addNota');
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }

  Future<Null> refreshlist() async {
    refreshkey.currentState?.show(
        atTop:
            true); // change atTop to false to show progress indicator at bottom

    await Future.delayed(Duration(seconds: 2)); //wait here for 2 second

    setState(() {
      notasController.limpiarLista();
      _listadoNotas = notasController.getNotas();
    });
  }
}
