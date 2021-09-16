import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_notas/controllers/notasController.dart';

void main() => runApp(EditNota());

class EditNota extends StatefulWidget {
  String id;
  String titulo;
  String nota;
  String imagen;
  EditNota({this.id, this.titulo, this.nota, this.imagen});

  @override
  _EditNotaState createState() => _EditNotaState();
}

class _EditNotaState extends State<EditNota> {
  NotasController notasController = new NotasController();

  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _noteController = new TextEditingController();

  String _patch;
  String _imagen64;

  @override
  void initState() {
    super.initState();
    notasController.init(context);
    _titleController.text = widget.titulo;
    _noteController.text = widget.nota;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: notasController.key,
      appBar: AppBar(
        title: Text("Editar nota"),
      ),
      body: _body(context),
    );
  }

  Widget _body(context) {
    return ListView(
      padding:
          const EdgeInsets.only(top: 16, left: 16.0, right: 16.0, bottom: 16.0),
      children: [
        Container(
          height: 60,
          child: new TextField(
            controller: _titleController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Título',
              hintText: 'Escribe el título de la nota',
              icon: new Icon(Icons.title),
            ),
          ),
        ),
        Container(
          height: 60,
          child: new TextField(
            controller: _noteController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Nota',
              hintText: 'Escribe la nota',
              icon: new Icon(Icons.note),
            ),
          ),
        ),
        (widget.imagen.isEmpty)
            ? Container()
            : Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Text(
                    "Imagen",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Image.network(
                    widget.imagen,
                    width: 300,
                  ),
                ],
              ),
        Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        (_patch == null)
            ? Container()
            : Image.file(
                File(_patch),
                width: 200,
              ),
        RaisedButton(
          child: Text("Seleccionar imagen"),
          onPressed: () async {
            final ImagePicker _picker = new ImagePicker();
            PickedFile _archivo =
                await _picker.getImage(source: ImageSource.gallery);
            setState(() {
              _patch = _archivo.path;
            });
            //convertimos en base64
            if (_patch != null) {
              List bytes = await new File(_patch).readAsBytesSync();
              _imagen64 = base64.encode(bytes);
            }
          },
        ),
        new Padding(
          padding: new EdgeInsets.only(top: 44.0),
        ),
        Container(
          height: 40,
          child: new RaisedButton(
            onPressed: () {
              notasController.editarNota(
                  widget.id,
                  _titleController.text.trim(),
                  _noteController.text.trim(),
                  _imagen64);
              Navigator.pushNamed(context, 'listNotas');
            },
            color: Colors.blue,
            child: new Text(
              'Editar',
              style: new TextStyle(
                  color: Colors.white, backgroundColor: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
