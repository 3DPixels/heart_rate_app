class AlarmModel {
  String? medicine, alarmId;
  int? time;

  AlarmModel({this.medicine, this.time, this.alarmId});

  AlarmModel.fromJson(Map<String, dynamic> json) {
    medicine = json['medicine'] ?? '';
    alarmId = json['alarmId'] ?? '';

    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['medicine'] = medicine ?? '';
    data['alarmId'] = alarmId ?? '';
    data['time'] = time ?? '';
    return data;
  }
}
