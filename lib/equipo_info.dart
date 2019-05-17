import 'package:flutter/material.dart';
import 'utils.dart';
import 'models.dart';

class EquipoInfo extends StatelessWidget {
  const EquipoInfo(this.ipHost, this.equipo, this.isLogged, {Key key}) : super(key: key);
  final String ipHost;
  final Equipo equipo;
  final Boolean isLogged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipo.name),
      ),
      body: Container(
      child: FutureBuilder(
          future: Utils.getEquipoInfo(ipHost),
          builder: (BuildContext context, AsyncSnapshot<List<EquipoIntegrante>> snapshot) {
            if(snapshot.hasData){
              return EquipoIntegrantesView(snapshot.data, isLogged);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: Builder(
        builder: (context){
          if(isLogged.val){
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                showDialog(context: context, builder: (context) => AddIntegranteDialog());
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}


class EquipoIntegrantesView extends StatefulWidget {
  EquipoIntegrantesView(this.data, this.isLogged, {Key key}) : super(key: key);
  final List<EquipoIntegrante> data;
  final Boolean isLogged;

  _EquipoIntegrantesViewState createState() => _EquipoIntegrantesViewState(data, isLogged);
}

class _EquipoIntegrantesViewState extends State<EquipoIntegrantesView> {
  final List<EquipoIntegrante> data;
  final Boolean isLogged;

  _EquipoIntegrantesViewState(this.data, this.isLogged);

  @override
  Widget build(BuildContext context) {
    return Container(
       child: ListView.builder(
         itemCount: data.length,
         itemBuilder: (context, index){
           return data[index].getView(isLogged);
         },
       ),
    );
  }
}