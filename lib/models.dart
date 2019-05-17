import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class Carrera {
  final String name;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String status;

  Carrera(this.name, this.fechaInicio, this.fechaFin, this.status);

  static String parseTime(DateTime t){
    return DateFormat("dd/MM/y 'a las' H:mm").format(t);
  }

  static DateTime fromString(String t){
    return DateTime.parse(t);
  }

  static List<Carrera> fromJson(Map<String, dynamic> json){
    List<Carrera> res = new List();
      
    for(Map<String, dynamic> els in json["data"]){
      res.add(Carrera(els["nombre"], fromString(els["fecha_inicio"]), fromString(els["fecha_termino"]), els["status"]));
    }

    return res;
  }

  Widget getView(){
    return ListTile(
      title: Text(this.name),
      subtitle: Text(parseTime(this.fechaInicio)+"\n"+parseTime(this.fechaFin)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(this.status),
          FutureBuilder(
            future: Utils.isLogged(),
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if(snapshot.hasData && snapshot.data == true && snapshot.connectionState == ConnectionState.done){
                return PopupMenuButton(
                  onSelected: (i) async{
                    if(i == 0){
                      showDialog(context: context, builder: (context) => EditCarreraDialog(this));
                    }else{
                      //TODO: Eliminar carrera
                    }
                  },
                  itemBuilder: (context){
                    return {
                      PopupMenuItem(
                        value: 0,
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('Eliminar'),
                      )
                    }.toList();
                  },
                );
              }else{
                return Container();
              }
            },
          ),
        ],
      ),
    );
	}
}

class Boolean{
  bool val;

  Boolean(this.val);
}

class Equipo {
  final int pos;
  final String name;
  final String desc;
  final String logo;

  Equipo(this.name, this.desc, this.logo, this.pos);

  static List<Equipo> fromJson(Map<String, dynamic> json){
    List<Equipo> res = new List();
      
    for(Map<String, dynamic> els in json["data"]){
      res.add(Equipo(els["nombre"], els["descripcion"], els["logo"], res.length+1));
    }

    return res;
  }

  Widget getView(bool isLogged){
		return  ListTile(
        leading: Image.network(this.logo),
        title: Text(this.name),
        subtitle: Text(this.desc),
        isThreeLine: true,
        trailing: Builder(
          builder: (BuildContext context) {
            if(isLogged){
              return PopupMenuButton(
                itemBuilder: (context){
                  return {
                    PopupMenuItem(
                        value: 0,
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('Eliminar'),
                      )
                  }.toList();
                },
                onSelected: (val){
                  if(val == 0){
                    showDialog(context: context, builder: (context) => EditEquipoDialog(this));
                  }else{
                    //TODO: Eliminar la carrera
                  }
                },
              );
            }else{
              return Text('#${this.pos}');
            }
          },
        ),
      );
	}
}

class EquipoIntegrante{
  final int equipo;
  final int cargo;
  final String nombre;
  final int edad;
  final String tipoSangre;
  final String direccion;
  final String nss;

  EquipoIntegrante(this.equipo, this.cargo, this.nombre, this.edad, this.tipoSangre, this.direccion, this.nss);

  static List<EquipoIntegrante> fromJson(Map<String, dynamic> json){
    List<EquipoIntegrante> res = new List();
      
    for(Map<String, dynamic> els in json["data"]){
      res.add(EquipoIntegrante(
        els["equipo"],
        els["cargo"],
        els["nombre"],
        els["edad"],
        els["tipo_sangre"],
        els["direccion"],
        els["nss"]
      ));
    }

    return res;
  }

  Widget getView(Boolean isLogged){
    return ListTile(
      title: Text(this.nombre),
      subtitle: Text(this.cargo.toString()),
      trailing: Builder(
        builder: (context){
          if(isLogged.val){
            return PopupMenuButton(
                itemBuilder: (context){
                  return {
                    PopupMenuItem(
                        value: 0,
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('Eliminar'),
                      )
                  }.toList();
                },
                onSelected: (val){
                  if(val == 0){
                    showDialog(context: context, builder: (context) => EditIntegranteDialog(this));
                }else{
                  //TODO: Eliminar la carrera
                }
              },
            );
          }
          return null;
        },
      ),
    );
  }
}

class AddCarreraDialog extends StatefulWidget {
  AddCarreraDialog({Key key}) : super(key: key);

  _AddCarreraDialogState createState() => _AddCarreraDialogState();
}

class _AddCarreraDialogState extends State<AddCarreraDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0
                  ),
                  child: Text(
                    'Nueva carrera',
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre'
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Fecha de inicio'),
                      OutlineButton(
                        child: Text('Elegir'),
                        onPressed: (){
                          DatePicker.showDateTimePicker(context, 
                            showTitleActions: true,
                            currentTime: DateTime.now(),
                            locale: LocaleType.es,
                            onChanged: (dateTime){

                            }
                          );
                        }
                      ),
                      SizedBox(height: 8.0),
                      Text('Fecha de término'),
                      OutlineButton(
                        child: Text('Elegir'),
                        onPressed: (){
                          DatePicker.showDateTimePicker(context, 
                            showTitleActions: true,
                            currentTime: DateTime.now(),
                            locale: LocaleType.es,
                            onChanged: (dateTime){
                              
                            }
                          );
                        }
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Fecha de termino'
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Estatus'
                        ),
                      ),
                      Container(
                        height: 18.0,
                      ),
                      Center(
                        child: OutlineButton(
                          child: Text('Enviar'),
                          shape: StadiumBorder(),
                          onPressed: (){

                          },
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

class EditCarreraDialog extends StatefulWidget {
  EditCarreraDialog(this.carrera, {Key key}) : super(key: key);
  final Carrera carrera;

  _EditCarreraDialogState createState() => _EditCarreraDialogState(carrera);
}

class _EditCarreraDialogState extends State<EditCarreraDialog> {
  final Carrera carrera;

  _EditCarreraDialogState(this.carrera);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0
              ),
              child: Text(
                'Editar carrera',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nombre'
                    ),
                    controller: TextEditingController(text: carrera.name),
                  ),
                  SizedBox(height: 8.0),
                  Text('Fecha de inicio'),
                  OutlineButton(
                    child: Text('Elegir'),
                    onPressed: (){
                      DatePicker.showDateTimePicker(context, 
                        showTitleActions: true,
                        currentTime: carrera.fechaInicio,
                        locale: LocaleType.es,
                        onChanged: (dateTime){

                        }
                      );
                    }
                  ),
                  SizedBox(height: 8.0),
                  Text('Fecha de término'),
                  OutlineButton(
                    child: Text('Elegir'),
                    onPressed: (){
                      DatePicker.showDateTimePicker(context, 
                        showTitleActions: true,
                        currentTime: carrera.fechaFin,
                        locale: LocaleType.es,
                        onChanged: (dateTime){
                          
                        }
                      );
                    }
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Estatus'
                    ),
                    controller: TextEditingController(text: carrera.status),
                  ),
                  Container(
                    height: 18.0,
                  ),
                  Center(
                    child: OutlineButton(
                      child: Text('Enviar'),
                      shape: StadiumBorder(),
                      onPressed: (){

                      },
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    ));
  }
}


class AddEquipoDialog extends StatefulWidget {
  AddEquipoDialog({Key key}) : super(key: key);

  _AddEquipoDialogState createState() => _AddEquipoDialogState();
}

class _AddEquipoDialogState extends State<AddEquipoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0
                ),
                child: Text(
                  'Nuevo equipo',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre'
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Descripción'
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Logo'
                      ),
                    ),
                    Container(
                      height: 18.0,
                    ),
                    Center(
                      child: OutlineButton(
                        child: Text('Enviar'),
                        shape: StadiumBorder(),
                        onPressed: (){

                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class EditEquipoDialog extends StatefulWidget {
  EditEquipoDialog(this.equipo, {Key key}) : super(key: key);
  final Equipo equipo;

  _EditEquipoDialogState createState() => _EditEquipoDialogState(equipo);
}

class _EditEquipoDialogState extends State<EditEquipoDialog> {
  final Equipo equipo;

  _EditEquipoDialogState(this.equipo);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0
                ),
                child: Text(
                  'Editar equipo',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre'
                      ),
                      controller: TextEditingController(text: equipo.name),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Descripción'
                      ),
                      controller: TextEditingController(text: equipo.desc),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Logo'
                      ),
                      controller: TextEditingController(text: equipo.logo),
                    ),
                    Container(
                      height: 18.0,
                    ),
                    Center(
                      child: OutlineButton(
                        child: Text('Enviar'),
                        shape: StadiumBorder(),
                        onPressed: (){

                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class AddIntegranteDialog extends StatefulWidget {
  AddIntegranteDialog({Key key}) : super(key: key);

  _AddIntegranteDialogState createState() => _AddIntegranteDialogState();
}

class _AddIntegranteDialogState extends State<AddIntegranteDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0
                ),
                child: Text(
                  'Añadir integrante',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre del equipo'
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Equipo'
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Cargo'
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Edad'
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Tipo de sangre'
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Dirección'
                      ),
                      maxLines: 3,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'NSS'
                      ),
                    ),
                    Container(
                      height: 18.0,
                    ),
                    Center(
                      child: OutlineButton(
                        child: Text('Enviar'),
                        shape: StadiumBorder(),
                        onPressed: (){

                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class EditIntegranteDialog extends StatefulWidget {
  EditIntegranteDialog(this.integrante, {Key key}) : super(key: key);
  final EquipoIntegrante integrante;

  _EditIntegranteDialogState createState() => _EditIntegranteDialogState(integrante);
}

class _EditIntegranteDialogState extends State<EditIntegranteDialog> {
  final EquipoIntegrante integrante;

  _EditIntegranteDialogState(this.integrante);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0
                ),
                child: Text(
                  'Editar integrante',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre del equipo'
                      ),
                      controller: TextEditingController(text: integrante.nombre),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Equipo'
                      ),
                      controller: TextEditingController(text: integrante.equipo.toString()),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Cargo'
                      ),
                      controller: TextEditingController(text: integrante.cargo.toString()),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Edad'
                      ),
                      controller: TextEditingController(text: integrante.edad.toString()),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Tipo de sangre'
                      ),
                      controller: TextEditingController(text: integrante.tipoSangre.toString()),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Dirección'
                      ),
                      controller: TextEditingController(text: integrante.direccion),
                      maxLines: 3,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'NSS'
                      ),
                      controller: TextEditingController(text: integrante.nss),
                    ),
                    Container(
                      height: 18.0,
                    ),
                    Center(
                      child: OutlineButton(
                        child: Text('Enviar'),
                        shape: StadiumBorder(),
                        onPressed: (){

                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}