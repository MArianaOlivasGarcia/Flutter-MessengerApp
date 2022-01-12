


import 'package:chat/global/environments.dart';
import 'package:chat/models/messages_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier {

  late Usuario userTo;

   Future<List<Message>> getChat( String userId ) async {


    final resp = await http.get( Uri.parse( '${ Environments.apiUrl }/mensajes/$userId'), 
      headers: {
        'Content-Type': 'application/json',
        'token': await AuthProvider.getToken()
      }
    );

    final messagesReponse = messagesChatResponseFromJson( resp.body );

    return messagesReponse.messages;


  }

}