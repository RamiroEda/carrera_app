import 'package:carreras_app/carrera_info.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'models.dart';

class CarreraPage extends StatefulWidget {
  CarreraPage(this.ipHost, this.isLogged, {Key key}) : super(key: key);
  final String ipHost;
  final Boolean isLogged;

  _CarreraPageState createState() => _CarreraPageState(ipHost, isLogged);
}

class _CarreraPageState extends State<CarreraPage> {
  final String ipHost;
  final Boolean isLogged;

  _CarreraPageState(this.ipHost, this.isLogged);

  @override
  Widget build(BuildContext context) {
    return Container(
       child: FutureBuilder(
         future: Utils.getCarreras(ipHost),
         builder: (BuildContext context, AsyncSnapshot<List<Carrera>> snapshot) {
           if(snapshot.hasData){
             return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return RawMaterialButton(
                    child: snapshot.data[index].getView(),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CarreraInfo(ipHost, snapshot.data[index], this.isLogged)));
                    },
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