
import 'dart:convert';
import 'package:chat/models/usuario.dart';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
    AuthResponse({
        required this.status,
        this.usuario,
        this.token,
        this.msg
    });

    bool status;
    Usuario? usuario;
    String? token;
    String? msg;

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        status: json["status"],
        usuario: (json["usuario"] != null )? Usuario.fromJson(json["usuario"] ) : null ,
        token: json["token"] ,
        msg: json["msg"] ,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "usuario": usuario?.toJson(),
        "token": token,
        "msg": msg,
    };
}

