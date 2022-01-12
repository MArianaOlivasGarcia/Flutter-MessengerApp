class Usuario {
    Usuario({
        required this.online,
        required this.name,
        required this.email,
        required this.id,
        required this.image,
    });

    bool online;
    String name;
    String email;
    String id;
    String image;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        name: json["name"],
        email: json["email"],
        id: json["uid"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "id": id,
        "image": image,
    };
}
