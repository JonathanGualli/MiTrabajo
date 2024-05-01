// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late final String id;
  late final String name;
  late final String email;
  late final String? phone;
  //late final String address;
  late final String image;
  //late final String aboutMe;
  late final String rol;
  late final double totalPendiente;
  //late final double totalPagado;

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.rol,
      required this.totalPendiente});

  factory UserData.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      id: snapshot.id,
      name: data["name"],
      email: data["email"],
      phone: data["phone"],
      image: data["image"],
      rol: data["rol"],
      totalPendiente: data["totalPendiente"].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      "image": image,
      "rol": rol,
      "totalPendiente": totalPendiente
    };
  }
}
