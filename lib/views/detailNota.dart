import 'package:flutter/material.dart';
import 'package:sistema_notas/controllers/notasController.dart';
import 'package:sistema_notas/views/editNota.dart';
import 'package:sistema_notas/views/listNotas.dart';

void main() => runApp(DetailNota());

class DetailNota extends StatefulWidget {
  String id;
  String titulo;
  String nota;
  String imagen;
  DetailNota({this.id, this.titulo, this.nota, this.imagen});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<DetailNota> {
  NotasController notasController = new NotasController();

  @override
  void initState() {
    super.initState();
    notasController.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: notasController.key,
      appBar: AppBar(title: Text("Detalle de nota")),
      body: _body(context),
    );
  }

  Widget _body(context) {
    return ListView(
      children: [
        Padding(padding: EdgeInsets.all(8)),
        Text(
          'Título',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
          widget.titulo,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Text(
          'Nota',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
          widget.nota,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(),
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
        Container(
          margin: EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new EditNota(
                        id: widget.id,
                        titulo: widget.titulo,
                        nota: widget.nota,
                        imagen: widget.imagen,
                      ),
                    ),
                  );
                },
                child:
                    Text("Editar", style: const TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
              Expanded(child: Container()),
              RaisedButton(
                onPressed: () => dialogConfirm(),
                child: Text("Eliminar",
                    style: const TextStyle(color: Colors.white)),
                color: Colors.red,
              ),
            ],
          ),
        )
      ],
    );
  }

  void dialogConfirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Esta seguro de eliminar '${widget.titulo}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK remove!",
            style: new TextStyle(color: Colors.white),
          ),
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
            notasController.eliminarNota(widget.id);
          },
        ),
        new RaisedButton(
          child: new Text("CANCEL", style: new TextStyle(color: Colors.white)),
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, child: alertDialog);
  }
}
