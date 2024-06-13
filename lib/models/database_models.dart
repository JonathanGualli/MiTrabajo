const String tableCustomActity = "customActivity";
const String tableActivityData = "activityData";

class CustomActivityField {
  static const String nameActivity = 'nameActivity';
  static const String price = 'price';
  static const String icon = 'icon';
  static const String color = 'color';
}

class ActivityField {
  static const String activityId = 'activityId';
  static const String date = 'date';
  static const String activityType = 'activityType';
  static const String details = 'details';
  static const String price = 'price';
  static const String quantity = 'quantity';
  static const String state = 'state';
}

class CustomActivityModel {
  String nameActivity;
  double price;
  int icon;
  String color;

  CustomActivityModel(this.nameActivity, this.price, this.icon, this.color);

  static CustomActivityModel fromJson(Map<String, Object?> json) =>
      CustomActivityModel(
        json[CustomActivityField.nameActivity] as String,
        json[CustomActivityField.price] as double,
        json[CustomActivityField.icon] as int,
        json[CustomActivityField.color] as String,
      );

  Map<String, Object?> toJson() => {
        CustomActivityField.nameActivity: nameActivity,
        CustomActivityField.price: price,
        CustomActivityField.icon: icon,
        CustomActivityField.color: color,
      };
}

class ActivityModel {
  int? activityId;
  String date;
  String activityType;
  String details;
  double price;
  int quantity;
  String state;

  ActivityModel.noID(this.date, this.activityType, this.details, this.price,
      this.quantity, this.state);

  ActivityModel(this.activityId, this.date, this.activityType, this.details,
      this.price, this.quantity, this.state);

  static ActivityModel fromJson(Map<String, Object?> json) => ActivityModel(
        json[ActivityField.activityId] as int,
        json[ActivityField.date] as String,
        json[ActivityField.activityType] as String,
        json[ActivityField.details] as String,
        json[ActivityField.price] as double,
        json[ActivityField.quantity] as int,
        json[ActivityField.state] as String,
      );

  Map<String, Object?> toJson() => {
        //ActivityField.activityId: activityId,
        ActivityField.date: date,
        ActivityField.activityType: activityType,
        ActivityField.details: details,
        ActivityField.price: price,
        ActivityField.quantity: quantity,
        ActivityField.state: state,
      };
}
