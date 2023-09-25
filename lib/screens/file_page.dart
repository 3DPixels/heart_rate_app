import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:heart_rate_app/screens/widgets/custom_button.dart';
import 'package:heart_rate_app/screens/widgets/custom_container.dart';
import 'package:heart_rate_app/screens/widgets/custom_textFields.dart';

import '../local/cach_helper.dart';
import '../local/shared_keys.dart';
import '../model/user_model.dart';
import '../services/database_helper.dart';
import '../utils/app_images.dart';
import '../utils/constants.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({super.key});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  final fileFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController week1Controller = TextEditingController();
  TextEditingController week2Controller = TextEditingController();
  TextEditingController week3Controller = TextEditingController();
  TextEditingController week4Controller = TextEditingController();
  TextEditingController week5Controller = TextEditingController();
  List<TextEditingController> controllers = [];
  UserModel? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllers = [
      week1Controller,
      week2Controller,
      week3Controller,
      week4Controller,
      week5Controller
    ];
    nameController.text = CacheHelper.getString(SharedKeys.name);
    getUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    week1Controller.dispose();
    week2Controller.dispose();
    week3Controller.dispose();
    week4Controller.dispose();
    week5Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: fileFormKey,
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
                      CustomTextField2(
                        hint: 'Name',
                        padding: true,
                        controller: nameController,
                        readOnly: true,
                      ),
                      CustomTextField2(
                        hint: 'Week One',
                        padding: true,
                        controller: week1Controller,
                      ),
                      CustomTextField2(
                        hint: 'Week Two',
                        padding: true,
                        controller: week2Controller,
                      ),
                      CustomTextField2(
                        hint: 'Week Three',
                        padding: true,
                        controller: week3Controller,
                      ),
                      CustomTextField2(
                        hint: 'Week Four',
                        padding: true,
                        controller: week4Controller,
                      ),
                      CustomTextField2(
                        hint: 'Week Five',
                        padding: true,
                        controller: week5Controller,
                      ),
                      25.verticalSpace,
                      CustomButton(Colors.black, Colors.white, 'Save', () {
                        user!.rates!.clear();
                        user!.rates!.addAll([
                          week1Controller.text,
                          week2Controller.text,
                          week3Controller.text,
                          week4Controller.text,
                          week5Controller.text
                        ]);
                        DatabaseHelper.database!.update('Users', {
                          'id': CacheHelper.getString(SharedKeys.id),
                          'userModel': jsonEncode(user!.toJson())
                        });
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future getUserData() async {
    List<Map<String, dynamic>> usersData = await DatabaseHelper.database!
        .rawQuery('SELECT * FROM "Users" WHERE id=?',
            [int.parse(CacheHelper.getString(SharedKeys.id))]);
    if (usersData.isNotEmpty) {
      user = UserModel.fromJson(jsonDecode(usersData.first['userModel']));
      for (int i = 0; i < user!.rates!.length; i++) {
        controllers[i].text = user!.rates![i];
      }
    }
  }
}
