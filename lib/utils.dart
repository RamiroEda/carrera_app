import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'dart:convert';
import 'pruebas.dart';
import 'package:wifi/wifi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<bool> isConnected() async{
    final conState = await (new Connectivity()).checkConnectivity();
    
    return conState == ConnectivityResult.wifi;
  }

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

	static Future<String> searchIP(bool init) async{
    if(init)return Future.value('Host ya encontrado');
    if(!await isConnected()) return Future.error('No hay conexión a internet');

		int port = 80;
    int timeout = 500;
    //if(isInDebugMode) timeout = 500;
    
		final ip = InternetAddress(await Wifi.ip).rawAddress;
    ip.last = 1;

		for(int i = 0 ; i < 253 ; i++){
      String url = "http://${ip.join('.')}:$port/";
      print("Peticion a $url esperando...");
      
      try{
        final res = await http.get(url).timeout(Duration(milliseconds: timeout));

        if(res.statusCode == 200){
          print("Host encontrado: $url");
          return Future.value(url);
        }
      }on TimeoutException catch(e){
        //print(e);
      }on SocketException catch(e){
        //print(e);
      }on PlatformException catch(e){
        //print(e);
        return Future.error('No hay conexión a internet');
      }
      
      ip.last++;
    }

    return Future.error('No se encontró ningun servidor en la red');
	}

	static Future<List<Carrera>> getCarreras(String url) async{
		//final resp = await http.get('${url}listaCarreras/')
    print(url);
		return Carrera.fromJson(json.decode(CARRERAS_JSON));
	}

	static Stream<List<Equipo>> getEquipos(String url) async*{
    print(url);
		while(true){ 
      await Future.delayed(Duration(seconds: 1), (){});
      yield Equipo.fromJson(json.decode(EQUIPO_JSON));
    }
	}

  static Future<List<EquipoIntegrante>> getEquipoInfo(String url) async{
    print(url);
    return EquipoIntegrante.fromJson(json.decode(EQUIPO_INFO_JSON));
  }

  static Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged');
  }
}