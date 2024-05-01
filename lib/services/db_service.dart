// !Poner los metodos en un try catch
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_trabajo/models/activity_model.dart';
import 'package:mi_trabajo/models/user_%20model.dart';
import 'package:mi_trabajo/providers/auth_provider.dart';

class DBService {
  static DBService instance = DBService();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _userCollection = "Users";
  final String _activityCollection = "Jobs";

  Future<void> createdUserInDB(String uid, String name, String email,
      String phone, String imageURL) async {
    try {
      await _db.collection(_userCollection).doc(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "image": imageURL,
        "rol": "usuario",
        "totalPendiente": 0
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<bool> existUserInDatabase(String uid) async {
    try {
      DocumentSnapshot user =
          await _db.collection(_userCollection).doc(uid).get();

      if (user.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  Future<UserData> get getUserData async {
    final docSnapshot = await _db
        .collection(_userCollection)
        .doc(AuthProvider.instance.user!.uid)
        .get();
    final userData = UserData.fromFirestore(docSnapshot);
    //print(userData);
    return userData;
  }

  Stream<UserData> getUserDataStream(String userID) {
    return _db
        .collection(_userCollection)
        .doc(userID)
        .snapshots()
        .map((snapshot) => UserData.fromFirestore(snapshot));
  }

  Future<void> updateUserInDB(UserData user) async {
    try {
      await _db.collection(_userCollection).doc(user.id).update({
        "name": user.name,
        "phone": user.phone,
        "image": user.image,
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateTotalPendienteUserInDB(double total) async {
    try {
      await _db
          .collection(_userCollection)
          .doc(AuthProvider.instance.user!.uid)
          .update({'totalPendiente': FieldValue.increment(total)});
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> createdActivityInDB(ActivityData activity) async {
    try {
      await updateTotalPendienteUserInDB((activity.price * activity.quantity))
          .then((value) {
        _db
            .collection(_userCollection)
            .doc(AuthProvider.instance.user!.uid)
            .collection(_activityCollection)
            .doc(Timestamp.now().seconds.toString())
            .set({
          "date": activity.date,
          "activityType": activity.activityType,
          "details": activity.details,
          "price": activity.price,
          "quantity": activity.quantity,
          "state": activity.state
        });
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
/* 
  Future<void> createdActivityInDBs(ActivityData activity) async {
    try {
      await _db
          .collection(_userCollection)
          .doc(AuthProvider.instance.user!.uid)
          .collection(_activityCollection)
          .doc(Timestamp.now().seconds.toString())
          .set({
        "date": activity.date,
        "activityType": activity.activityType,
        "details": activity.details,
        "price": activity.price,
        "quantity": activity.quantity,
        "state": activity.state
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  } */

  Stream<List<ActivityData>> get getActivitisStream {
    return _db
        .collection(_userCollection)
        .doc(AuthProvider.instance.user!.uid)
        .collection(_activityCollection)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ActivityData.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> deleteActivity(String uid, double totalPrice, String state) {
    if (state == 'Pendiente') {
      return updateTotalPendienteUserInDB(-totalPrice).then((value) {
        _db
            .collection(_userCollection)
            .doc(AuthProvider.instance.user!.uid)
            .collection(_activityCollection)
            .doc(uid)
            .delete();
      });
    } else {
      return _db
          .collection(_userCollection)
          .doc(AuthProvider.instance.user!.uid)
          .collection(_activityCollection)
          .doc(uid)
          .delete();
    }
  }

  Future<void> editActivity(
      String activityUid, Map<String, dynamic> activityUpdate) {
    return _db
        .collection(_userCollection)
        .doc(AuthProvider.instance.user!.uid)
        .collection(_activityCollection)
        .doc(activityUid)
        .update(activityUpdate);
  }

  Future<void> changeState(String activityUid, String state, double total) {
    if (state == "Pendiente") {
      total = -total;
    }
    return updateTotalPendienteUserInDB(total).then((value) {
      _db
          .collection(_userCollection)
          .doc(AuthProvider.instance.user!.uid)
          .collection(_activityCollection)
          .doc(activityUid)
          .update({'state': state == "Pendiente" ? "Pagado" : "Pendiente"});
    });
  }
}
