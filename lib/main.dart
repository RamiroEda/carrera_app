import 'package:carreras_app/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';
import 'carrera_page.dart';
import 'admin/login.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carreras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppScaffold(),
    );
  }
}

class AppScaffold extends StatefulWidget {
  AppScaffold({Key key}) : super(key: key);

  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  Boolean isLogged = Boolean(false);

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
        appBar: AppBar(
          title: Text('Carreras'),
          actions: <Widget>[
            FutureBuilder(
              future: Utils.isLogged(),
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if(snapshot.hasData){
                  isLogged.val = snapshot.data;
                  
                  if(!snapshot.data){
                    return PopupMenuButton(
                      onSelected: (i){
                        if(i == 0){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAdmin()));
                        }
                      },
                      itemBuilder: (context){
                        return {
                          PopupMenuItem(
                            value: 0,
                            child: Text('Iniciar sesión'),
                          )
                        }.toList();
                      },
                    );
                  }else{
                    return PopupMenuButton(
                      onSelected: (i) async{
                        if(i == 1){
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            prefs.setBool("logged", false);
                          });
                        }
                      },
                      itemBuilder: (context){
                        return {
                          PopupMenuItem(
                            value: 1,
                            child: Text('Cerrar sesión'),
                          )
                        }.toList();
                      },
                    );
                  }
                }

                return Container();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: FutureBuild(isLogged),
        ),
        floatingActionButton: FutureBuilder(
          future: Utils.isLogged(),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if(snapshot.hasData && snapshot.data == true && snapshot.connectionState == ConnectionState.done){
              return FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  showDialog(context: context, builder: (context) => AddCarreraDialog());
                },
                tooltip: 'Añadir carrera',
              );
            }else{
              return Container();
            }
          },
        ),
      )
    );
  }
}

class FutureBuild extends StatefulWidget {
  FutureBuild(this.isLogged, {Key key}) : super(key: key);
  final Boolean isLogged;

  _FutureBuildState createState() => _FutureBuildState(isLogged);
}

class _FutureBuildState extends State<FutureBuild> {
  bool init = false;
  String host = '';
  final Boolean isLogged;

  _FutureBuildState(this.isLogged);

  @override
  Widget build(BuildContext context) {
    return Container(
       child: FutureBuilder(
          future: Utils.searchIP(init),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(host.isNotEmpty) return CarreraPage(host, isLogged);

            if(snapshot.connectionState == ConnectionState.waiting){
              return MainPage();
            }else if(snapshot.hasData){
              init = true;
              host = snapshot.data;
              return CarreraPage(snapshot.data, isLogged);
            }else if(snapshot.hasError){
              return Container(
                margin: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(snapshot.error),
                      RaisedButton(
                        color: Colors.blue,
                        splashColor: Colors.blueAccent,
                        textColor: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.refresh),
                            Text('Reintentar')
                          ],
                        ),
                        onPressed: (){
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              );
            }

            return MainPage();
          },
        ),
    );
  }
}

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 8.0),
          Text('Buscando servidor...')
        ],
      ),
    );
  }
}

