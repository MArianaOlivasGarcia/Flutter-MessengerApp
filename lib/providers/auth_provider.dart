


import 'dart:convert';

import 'package:chat/global/environments.dart';
import 'package:chat/models/auth_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {


  late Usuario usuario;
  bool _isAuthenticating = false;

  final _storage = const FlutterSecureStorage();

  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating( bool value ) {
    _isAuthenticating = value;
    notifyListeners();
  }


  // Getters token staticos
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future removeToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<AuthResponse> login( String email, String password ) async {

    isAuthenticating = true;

    final data = {
      'email': email,
      'password': password
    };


    final resp = await http.post( Uri.parse( '${ Environments.apiUrl }/login'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    isAuthenticating = false;


    final authResponse = authResponseFromJson( resp.body );

    if ( resp.statusCode == 200 ) {
      usuario = authResponse.usuario!;
      await _saveToken( authResponse.token! );
    }

    return authResponse;
  }






  Future<AuthResponse> register( String name, String email, String password ) async {

    isAuthenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };


    final resp = await http.post( Uri.parse( '${ Environments.apiUrl }/new'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    isAuthenticating = false;

    final authResponse = authResponseFromJson( resp.body );

    if ( resp.statusCode == 200 ) {
      usuario = authResponse.usuario!;
      await _saveToken( authResponse.token! );
    }

    return authResponse;
  }




  Future<bool> isLoggedIn() async {

    final token = await _storage.read(key: 'token');

    final resp = await http.get( Uri.parse( '${ Environments.apiUrl }/renew'), 
      headers: {
        'Content-Type': 'application/json',
        'token': token ?? ''
      }
    );

    final authResponse = authResponseFromJson( resp.body );

    if ( resp.statusCode == 200 ) {
      usuario = authResponse.usuario!;
      await _saveToken( authResponse.token! );
    } else {
      logout();
    }

    return authResponse.status;

  }



  Future _saveToken( String token ) async {
    await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Eliminar token del storage
    await _storage.delete(key: 'token');
  }

}