import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistema_notas/models/Notas.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_notas/views/utils/snackbar.dart' as utilsnackbar;

class NotasController {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  BuildContext context;
  String urlbase = "http://apirestcrudnotas.ncrdesarrollo.com/notas";
  var status;

  Future init(BuildContext context) async {
    this.context = context;
  }

  //funcion para listar las notas
  List<Notas> notas = [];
  Future<List<Notas>> getNotas() async {
    final response = await http.get(urlbase);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        notas.add(
            Notas(item["id"], item["titulo"], item["nota"], item["imagen"]));
      }
      return notas;
    } else {
      throw Exception("Fallo de conexión");
    }
  }

  void limpiarLista() {
    notas.clear();
  }

  //funcion para guardar las notasController
  void addNota(
      String _titleController, String _noteController, String _imagen) async {
    // validaciones de campos vacios
    if (_titleController == "" || _noteController == "") {
      utilsnackbar.Snackbar.showSnackbar(
          context, key, "Los campos no puede estar vacios", Colors.orange);
      return;
    }
    showLoaderDialog(context);
    final response = await http.post(urlbase,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        //body: {"titulo": "$_titleController", "nota": "$_noteController"},
        body: json.encode({
          "titulo": "$_titleController",
          "nota": "$_noteController",
          "imagen": "$_imagen"
        }));

    status = response.body.contains('error');
    var data = json.decode(response.body);

    if (status) {
      utilsnackbar.Snackbar.showSnackbar(
          context, key, "Error, no se ha apodido registrar", Colors.red);
    } else {
      utilsnackbar.Snackbar.showSnackbar(
          context, key, "Se registró la nota", Colors.green);

      print("se registro");
      Navigator.of(context).pushNamedAndRemoveUntil(
          'listNotas', (Route<dynamic> route) => false);
    }
  }

  //funcion para editar
  void editarNota(String id, String titulo, String nota, String imagen) async {
    if (titulo == "" || nota == "") {
      utilsnackbar.Snackbar.showSnackbar(
          context, key, "Los campos no puede estar vacios", Colors.orange);
      return;
    }
    showLoaderDialog(context);
    http
        .put(urlbase,
            headers: {'Accept': 'application/json'},
            body: json.encode({
              "id": "$id",
              "titulo": "$titulo",
              "nota": "$nota",
              "imagen": "$imagen"
            }))
        .then(
      (response) {
        print('Response status : ${response.statusCode}');
        print('Response body : ${response.body}');
        if (response.statusCode == 200) {
          utilsnackbar.Snackbar.showSnackbar(
              context, key, "Se editó la nota", Colors.green);
          Navigator.of(context).pushNamedAndRemoveUntil(
              'listNotas', (Route<dynamic> route) => false);
        } else {
          utilsnackbar.Snackbar.showSnackbar(
              context, key, "Error, no se ha apodido editar", Colors.red);
        }
      },
    );
  }

  //function para eliminar
  void eliminarNota(String id) async {
    showLoaderDialog(context);
    http.delete(
      urlbase,
      headers: {'Accept': 'application/json', 'id': id},
    ).then(
      (response) {
        print('Response status : ${response.statusCode}');
        print('Response body : ${response.body}');

        if (response.statusCode == 200) {
          utilsnackbar.Snackbar.showSnackbar(
              context, key, "Se eliminó la nota", Colors.green);
          Navigator.of(context).pushNamedAndRemoveUntil(
              'listNotas', (Route<dynamic> route) => false);
        } else {
          utilsnackbar.Snackbar.showSnackbar(
              context, key, "Error, no se h apodido eliminar", Colors.red);
        }
      },
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
