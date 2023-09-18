import 'alarm_model.dart';

class UserModel {
  String? name, phone, email, password;
  List<String>? rates;
  List<AlarmModel>? alarms;
  int? id;

  UserModel(this.id, this.name, this.phone, this.email, this.password,
      this.rates, this.alarms);

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    if (json['rates'] != null) {
      List list = json['rates'];
      rates = list.map((e) => e.toString()).toList();
    } else {
      rates = [];
    }

    if (json['alarms'] != null) {
      List list = json['alarms'];
      alarms = list
          .map((e) => AlarmModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      alarms = [];
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id ?? 0;
    data['name'] = name ?? '';
    data['phone'] = phone ?? '';
    data['email'] = email ?? '';
    data['password'] = password ?? '';
    if (rates != null) {
      data['rates'] = rates;
    } else {
      data['rates'] = [];
    }

    if (alarms != null) {
      data['alarms'] = alarms!.map((e) => e.toJson()).toList();
    } else {
      data['alarms'] = [];
    }
    return data;
  }
}
