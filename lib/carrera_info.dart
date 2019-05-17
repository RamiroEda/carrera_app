import 'package:flutter/material.dart';
import 'models.dart';
import 'utils.dart';
import 'equipo_info.dart';

class CarreraInfo extends StatelessWidget {
  const CarreraInfo(this.ipHost, this.carrera, this.isLogged, {Key key}) : super(key: key);
  final String ipHost;
  final Carrera carrera;
  final Boolean isLogged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carrera.name),
      ),
      body: SafeArea(
        child: MainPage(ipHost, isLogged),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          if(this.isLogged.val){
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                showDialog(context: context, builder: (context) => AddEquipoDialog());
              },
            );
          }

          return Container();
        },
      ),

    );
  }
}

class MainPage extends StatefulWidget {
  MainPage(this.ipHost, this.isLogged, {Key key}) : super(key: key);
  final String ipHost;
  final Boolean isLogged;

  _MainPageState createState() => _MainPageState(ipHost, isLogged);
}

class _MainPageState extends State<MainPage> {
  final String ipHost;
  final Boolean isLogged;

  _MainPageState(this.ipHost, this.isLogged);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Utils.getEquipos(ipHost),
          builder: (BuildContext context, AsyncSnapshot<List<Equipo>> snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    child: RawMaterialButton(
                      child: snapshot.data[index].getView(this.isLogged.val),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EquipoInfo(ipHost, snapshot.data[index], isLogged)));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    ),
                    
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }
}