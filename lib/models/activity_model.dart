import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityData {
  late final String activityId;
  late final DateTime date;
  late final String activityType;
  late final String details;
  late final double price;
  late final int quantity;
  late final String state;

  // Constructor con valores predeterminados
  ActivityData.empty()
      : activityId = '',
        date = DateTime.now(),
        activityType = '',
        details = '',
        price = 0.0,
        quantity = 0,
        state = "pendiente";

  ActivityData(
      {required this.activityId,
      required this.date,
      required this.activityType,
      required this.details,
      required this.price,
      required this.quantity,
      required this.state});

  factory ActivityData.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return ActivityData(
      activityId: snapshot.id,
      date: data["date"].toDate(),
      activityType: data["activityType"],
      details: data["details"],
      price: data["price"].toDouble(),
      quantity: data["quantity"],
      state: data["state"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "activityId": activityId,
      "date": date,
      "activityType": activityType,
      "details": details,
      "price": price,
      "quantity": quantity,
      "state": state,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      "date": date,
      "activityType": activityType,
      "details": details,
      "price": price,
      "quantity": quantity,
      "state": state,
    };
  }
}
