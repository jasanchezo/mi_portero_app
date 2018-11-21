import 'package:flutter/material.dart';
// IMPORTADO PARA AUTENTICACIÓN POR FIREBASE:
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
import 'AccessRegisterScreen.dart';
// import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); //Id. único del formulario
  String _userName; //variable que almacena el correo del usuario
  String _password; //variable que almacena la contraseña

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return "El correo electrónico no es válido";
    else
      return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty)
      return "Escriba una contraseña";
    else if (value.length < 6)
      return "La contraseña debe tener por lo menos 6 caracteres";
    else
      return null;
  }

  bool _formValidate() {
    if (_formKey.currentState.validate()) {
      //Ejecuta la validación del formulario
      _formKey.currentState
          .save(); //Ejecuta el evento onSaved de cada TextFormField
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Autenticación"),
      ),
      body: ListView(
        padding: EdgeInsets.all(32.0),
        children: <Widget>[
          SizedBox(
            height: 80.0,
          ),
          FlutterLogo(
            size: 100.0,
          ),
          Center(
            child: Text("Mi Portero App", style: TextStyle(fontSize: 20.0)),
          ),
          SizedBox(
            height: 80.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    //filled: true,
                    labelText: "Correo electrónico",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) =>
                      _validateEmail(input), //funcion validar correo
                  onSaved: (input) => _userName = input,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    //filled: true,
                    labelText: "Contraseña",
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (input) => _validatePassword(
                      input), // FUNCIÓN PARA VALIDAR COMPLEJIDAD DE CONTRASEÑA
                  onSaved: (input) => _password = input,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
              color: Theme.of(context).accentColor,
              elevation: 5.0,
              splashColor: Colors.blueGrey,
              child: Text("Acceder"),
              onPressed: () {
                print("intento de Login");
                _loginAuth(); // LLAMADA A LA AUTENTICACIÓN DE FIREBASE
              }),
          /* FlatButton(
              child: Text('No tienes cuenta? Regístrate aquí'),
              onPressed: () {
                print("Register");
                // _registerAccount(); CODIGO PARA REGISTRARSE EN CASO DE NO TENER CUENTA
              }), */
        ],
      ),
    );
  }

  void _loginAuth() async {
    if (_formValidate()) {
      //Firebase authentication
      try {
        print("UserName:" + _userName);
        print("Password:" + _password);
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _userName, password: _password);
        print("Signed In Ok: ${user.uid}");

        if (_userName == "portero1@test.com") {
          print("Portero: " + _userName);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => AccessRegisterScreen(
                        userName: _userName,
                      )));
        } else {
          print("Residente: " + _userName);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => HomeScreen(
                        userName: _userName,
                      )));
        }
      } catch (e) {
        print("AuthError: $e");

        showDialog<void>(
          // DIALOGO CUANDO HAY UN ERROR EN LOS DATOS DE AUTENTICACIÓN
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Datos de acceso incorrectos"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        "El correo electrónico o la contraseña que introdujo no son correctas. Si persisten los problemas puede contactar al personal de su colonia."),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  /* void _registerAccount() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RegisterScreen()));
  } */
}
