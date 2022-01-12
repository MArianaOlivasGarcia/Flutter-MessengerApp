


import 'package:chat/global/environments.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsuariosProvider {

  final _storage = const FlutterSecureStorage();

  Future<List<Usuario>> getAllUsers() async {

    try {

      final token = await _storage.read(key: 'token');

      final resp = await http.get( Uri.parse( '${ Environments.apiUrl }/usuarios/all'), 
        headers: {
          'Content-Type': 'application/json',
          'token': token ?? ''
        }
      );

      final usuariosResponse = usuariosResponseFromJson( resp.body );

      print(usuariosResponse.usuarios);
      return usuariosResponse.usuarios;
      
    } catch (e) {
      return [];
    }

    
    
  }


}