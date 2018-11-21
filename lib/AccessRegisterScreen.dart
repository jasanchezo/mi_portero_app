import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccessRegisterScreen extends StatefulWidget {
  final String userName;
  AccessRegisterScreen({Key key, this.userName}) : super(key: key);

  @override
  _AccessRegisterScreenState createState() => _AccessRegisterScreenState();
}

class _AccessRegisterScreenState extends State<AccessRegisterScreen> {
  final _formKey = GlobalKey<FormState>(); //Id. único del formulario
  String _aceptado;
  String _email;
  String _estampaTiempo;
  String _identificador;
  String _notas;
  String _vehiculo;

  bool _formValidate() {
    if (_formKey.currentState.validate()) {
      //Ejecuta la validación del formulario
      _formKey.currentState
          .save(); //Ejecuta el evento onSaved de cada TextFormField
      return true;
    }
    return false;
  }

  void _registerAccess() async {
    if (_formValidate()) {
      try {
        await Firestore.instance.collection("accesos").document().setData({
          "aceptado": _aceptado,
          "email": _email,
          "estampaTiempo": _estampaTiempo,
          "identificador": _identificador,
          "notas": _notas,
          "vehiculo": _vehiculo
        });

        /* FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _userName, password: _password);
        print("Signed In Ok: ${user.uid}");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen(
                      userName: _userName,
                    ))); */
      } catch (e) {
        print("AuthError: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Portero App"), // BARRA SUPERIOR DE TÍTULO
      ),
      body: new ListView(children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Aceptado',
                ),
                keyboardType: TextInputType.text,
                onSaved: (input) => _aceptado = input,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.text,
                onSaved: (input) => _email = input,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'estampaTiempo',
                ),
                keyboardType: TextInputType.text,
                onSaved: (input) => _estampaTiempo = input,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Identificador',
                ),
                keyboardType: TextInputType.text,
                onSaved: (input) => _identificador = input,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notas',
                ),
                keyboardType: TextInputType.text,
                onSaved: (input) => _notas = input,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Vehículo',
                ),
                keyboardType: TextInputType.text,
                onSaved: (input) => _vehiculo = input,
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  elevation: 5.0,
                  splashColor: Colors.blueGrey,
                  child: Text('ENTRAR'),
                  onPressed: () {
                    print("intento de salvado de datos");
                    _registerAccess(); // LLAMADA A LA AUTENTICACIÓN DE FIREBASE
                    Form.of(context).reset();
                  }),
            ],
          ),
        ),
      ]),
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

                Navigator.pushReplacement(
                    // CUANDO SE CIERRE LA SESIÓN QUE REGRESE A LOGINSCREEN
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
