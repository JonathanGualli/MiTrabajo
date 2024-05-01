const String tableCustomActity = "customActivity";

class CustomActivityField {
  static const String nameActivity = 'nameActivity';
  static const String price = 'price';
  static const String icon = 'icon';
  static const String color = 'color';
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
