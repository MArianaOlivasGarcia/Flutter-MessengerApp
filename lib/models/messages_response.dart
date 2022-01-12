
import 'dart:convert';

MessagesChatResponse messagesChatResponseFromJson(String str) => MessagesChatResponse.fromJson(json.decode(str));

String messagesChatResponseToJson(MessagesChatResponse data) => json.encode(data.toJson());

class MessagesChatResponse {
    MessagesChatResponse({
        required this.status,
        required this.messages,
    });

    bool status;
    List<Message> messages;

    factory MessagesChatResponse.fromJson(Map<String, dynamic> json) => MessagesChatResponse(
        status: json["status"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    };
}

class Message {
    Message({
        required this.de,
        required this.para,
        required this.mensaje,
        required this.createdAt,
        required this.updatedAt,
    });

    String de;
    String para;
    String mensaje;
    DateTime createdAt;
    DateTime updatedAt;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}