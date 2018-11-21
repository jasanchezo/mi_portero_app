import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  DetailScreen({Key key, this.userName}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // WIDGET QUE RECIBIRÁ LA INFORMACIÓN PARA RENDERIZAR LOS DATOS DE FIREBASE
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      elevation: 5.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text("Estampa de tiempo"),
            subtitle: Text(document["estampaTiempo"].toString()),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text("Vehículo"),
            subtitle: Text(document["vehiculo"]),
          ),
          ListTile(
            leading: Icon(Icons.event_note),
            title: Text("Placas"),
            subtitle: Text(document["identificador"]),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text("Notas"),
            subtitle: Text(document["notas"]),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              // BARRA DE BOTONES DE CADA WIDGET CARD
              children: <Widget>[
                FlatButton(
                  child: const Text("Validar"),
                  onPressed: () {
                    Firestore.instance
                        .runTransaction((Transaction transaction) async {
                      DocumentSnapshot snap =
                          await transaction.get(document.reference);
                      await transaction.update(snap.reference, {
                        "aceptado": "true",
                      });
                    });
                  },
                ),
                FlatButton(
                  child: const Text("No válido"),
                  onPressed: () {
                    Firestore.instance
                        .runTransaction((Transaction transaction) async {
                      DocumentSnapshot snap =
                          await transaction.get(document.reference);
                      await transaction.update(snap.reference, {
                        "aceptado": "false",
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actividad de ingresos"), // BARRA SUPERIOR DE TÍTULO
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("accesos").where("email", isEqualTo: widget.userName).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

            return ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }
}
