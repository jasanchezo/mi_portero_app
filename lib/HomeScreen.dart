import 'package:flutter/material.dart';
import 'DetailScreen.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  HomeScreen({Key key, this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Portero App"), // BARRA SUPERIOR DE TÍTULO
      ),
      body: new ListView(
        // CUERPO PRINCIPAL DE LA APLICACIÓN
        children: <Widget>[
          new ListTile(
            title: new Text("Escoge una de las opciones"),
            // isThreeLine: true,
            subtitle: new Text('This is our Subtitle'),
            // trailing: new Icon(Icons.close),
          ),
          new Card(
            // ELEMENTO CARD DEL MENÚ DE HERRAMIENTAS
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.assignment_ind),
                    title: Text('Ver actividad'),
                    subtitle: Text('Revisar actividad de ingresos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                  userName: widget.userName,
                                )),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        // MENÚ LATERAL
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.userName),
              accountEmail: Text(widget.userName),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black26,
                child: Text(widget.userName[0]),
              ),
              decoration: BoxDecoration(color: Colors.orange),
            ),
            AboutListTile(
                child: Text("Acerca de"),
                applicationName: "Mi Portero App",
                applicationVersion: "v1.0.0",
                applicationIcon: Icon(Icons.adb),
                icon: Icon(Icons.info)),
            Divider(),
            ListTile(
              leading: new Icon(Icons.close),
              title: new Text("Cerrar"),
              onTap: () {
                setState(() {
                  Navigator.pop(context); // pop closes the drawer
                });

                Navigator.pushReplacement( // CUANDO SE CIERRE LA SESIÓN QUE REGRESE A LOGINSCREEN
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
