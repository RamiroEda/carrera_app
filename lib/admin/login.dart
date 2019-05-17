import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAdmin extends StatelessWidget {
  const LoginAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _controllerUsr;
  TextEditingController _controllerPass;

  @override
  void initState() { 
    super.initState();
    _controllerUsr = new TextEditingController();
    _controllerPass = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _controllerUsr,
          decoration: InputDecoration(
            labelText: 'Usuario'
          ),
        ),
        TextField(
          controller: _controllerPass,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña'
          ),
        ),
        RaisedButton(
          child: Text('Enviar'),
          onPressed: validar,
        )
      ],
    );
  }

  void validar() async{
    if(_controllerUsr.text.isEmpty)return;
    if(_controllerPass.text.isEmpty)return;

    if(_controllerUsr.text == "admin" && _controllerPass.text == "admin"){
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("logged", true);

      Navigator.pop(context);
    }
  }
}