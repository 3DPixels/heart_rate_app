import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:heart_rate_app/model/alarm_model.dart';
import 'package:heart_rate_app/model/user_model.dart';
import 'package:heart_rate_app/screens/widgets/custom_button.dart';
import 'package:heart_rate_app/screens/widgets/custom_container.dart';
import 'package:heart_rate_app/screens/widgets/custom_textFields.dart';
import 'package:heart_rate_app/services/notification_service.dart';
import 'package:intl/intl.dart';

import '../local/cach_helper.dart';
import '../local/shared_keys.dart';
import '../services/database_helper.dart';
import '../utils/app_images.dart';
import '../utils/constants.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

List<AlarmModel> list = [];

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime scheduleTime = DateTime.now();
  UserModel? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    list.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              10.verticalSpace,
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImages.appLogo,
                      width: 55,
                      height: 45,
                    ),
                    10.verticalSpace,
                    const Text(
                      'Enter Your Information:',
                      style: kSubtitleStyle,
                    ),
                    30.verticalSpace,
                    ...list.map((item) => Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomTextField2(
                                hint: item.medicine ?? 'Medicine',
                                padding: false,
                                onChanged: (text) {
                                  list[list.indexOf(item)].medicine = text;
                                  setState(() {});
                                },
                              ),
                            ),
                            30.horizontalSpace,
                            SizedBox(
                                width: 100,
                                child: CustomTimePicker(model: item)),
                            IconButton(
                                onPressed: () {
                                  list.remove(item);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                )),
                          ],
                        )),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (list.length < 5) {
                                list.add(
                                  AlarmModel(
                                      alarmId: DateTime.now()
                                          .toUtc()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      medicine: 'Medicine',
                                      time: DateTime.now()
                                          .toUtc()
                                          .millisecondsSinceEpoch),
                                );
                              } else {
                                showMsg(context, "Can't add more than 5");
                              }
                            });
                          },
                          child: const Text('+ add new')),
                    ),
                    25.verticalSpace,
                    CustomButton(Colors.black, Colors.white, 'Set A Reminder',
                        () {
                      // print("${list.first.medicine}, ${list.first.time}");
                      DatabaseHelper.database!.update('Users', {
                        'id': int.parse(CacheHelper.getString(SharedKeys.id)),
                        'userModel': jsonEncode(user!.toJson())
                      });
                      NotificationService().addNotification(list);
                      Navigator.pop(context);
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future getUserData() async {
    List<Map<String, dynamic>> usersData = await DatabaseHelper.database!
        .rawQuery('SELECT * FROM "Users" WHERE id=?',
            [int.parse(CacheHelper.getString(SharedKeys.id))]);
    if (usersData.isNotEmpty) {
      user = UserModel.fromJson(jsonDecode(usersData.first['userModel']));
      list = user!.alarms ?? [];
      setState(() {});
    }
  }
}

class CustomTimePicker extends StatefulWidget {
  final AlarmModel? model;
  const CustomTimePicker({super.key, this.model});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TextEditingController textEditingController = TextEditingController();
  int? time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text = widget.model != null
        ? "${DateFormat('hh').format(DateTime.fromMillisecondsSinceEpoch(widget.model!.time!))}:${DateFormat('mm').format(DateTime.fromMillisecondsSinceEpoch(widget.model!.time!))}"
        : 'Time';

    time = widget.model!.time;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: MediaQuery.of(context).copyWith().size.height / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 330,
                    child: CupertinoDatePicker(
                      initialDateTime: time != null
                          ? DateTime.fromMillisecondsSinceEpoch(time!)
                          : DateTime.now(),
                      onDateTimeChanged: (DateTime newdate) {
                        setState(() {
                          time = newdate.toUtc().millisecondsSinceEpoch;
                          textEditingController.text =
                              "${DateFormat('hh').format(newdate)}:${DateFormat('mm').format(newdate)}";
                        });
                      },
                      minuteInterval: 1,
                      mode: CupertinoDatePickerMode.time,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              list[list.indexOf(widget.model!)].time = time!;
                              Navigator.pop(context);
                            });
                          },
                          child: const Text('Confirm')),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
      readOnly: true,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Georgia',
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        suffixIcon: Image.asset(
          AppImages.downIcon,
          scale: 3,
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
