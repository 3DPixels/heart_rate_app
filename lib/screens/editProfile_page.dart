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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final editFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    nameController.text = CacheHelper.getString(SharedKeys.name);
    phoneController.text = CacheHelper.getString(SharedKeys.phone);
    emailController.text = CacheHelper.getString(SharedKeys.email);
    passwordController.text = CacheHelper.getString(SharedKeys.password);
    getUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: editFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    25.verticalSpace,
                    Center(
                      child: Image.asset(
                        AppImages.appLogo,
                        width: 55,
                        height: 45,
                      ),
                    ),
                    6.verticalSpace,
                    const Center(
                      child: Text(
                        'Edit',
                        style: kTitleStyle,
                      ),
                    ),
                    6.verticalSpace,
                    const Center(
                      child: SizedBox(
                        width: 128,
                        height: 128,
                        child: Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    const Text(
                      'Full Name*',
                      style: kLabelStyle,
                    ),
                    CustomTextField(
                      controller: nameController,
                    ),
                    5.verticalSpace,
                    const Text(
                      'Email*',
                      style: kLabelStyle,
                    ),
                    CustomTextField(
                      controller: emailController,
                    ),
                    5.verticalSpace,
                    const Text(
                      'Phone*',
                      style: kLabelStyle,
                    ),
                    CustomDigitField(
                      controller: phoneController,
                    ),
                    5.verticalSpace,
                    const Text(
                      'Password*',
                      style: kLabelStyle,
                    ),
                    CustomTextField(
                      obscure: true,
                      controller: passwordController,
                    ),
                    10.verticalSpace,
                    CustomButton(Colors.black, Colors.white, 'SAVE', () {
                      if (editFormKey.currentState!.validate()) {
                        user!.name = nameController.text;
                        user!.email = emailController.text;
                        user!.phone = phoneController.text;
                        user!.password = passwordController.text;
                        DatabaseHelper.database!.update('Users', {
                          'id': CacheHelper.getString(SharedKeys.id),
                          'userModel': jsonEncode(user!.toJson())
                        });
                        cacheUser(nameController.text, emailController.text,
                            phoneController.text, passwordController.text);
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void cacheUser(String name, String email, String phone, String pass) {
    CacheHelper.putString(SharedKeys.name, name);
    CacheHelper.putString(SharedKeys.email, email);
    CacheHelper.putString(SharedKeys.phone, phone);
    CacheHelper.putString(SharedKeys.password, pass);
  }

  Future getUserData() async {
    List<Map<String, dynamic>> usersData = await DatabaseHelper.database!
        .rawQuery('SELECT * FROM "Users" WHERE id=?',
            [int.parse(CacheHelper.getString(SharedKeys.id))]);
    print(CacheHelper.getString(SharedKeys.id));
    print('||||| ${usersData.toSet()}');
    if (usersData.isNotEmpty) {
      user = UserModel.fromJson(jsonDecode(usersData.first['userModel']));
    }
  }
}
