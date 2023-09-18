import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_rate_app/local/shared_keys.dart';
import 'package:heart_rate_app/model/user_model.dart';
import 'package:heart_rate_app/screens/signup_page.dart';
import 'package:heart_rate_app/screens/widgets/custom_button.dart';
import 'package:heart_rate_app/screens/widgets/custom_container.dart';
import 'package:heart_rate_app/screens/widgets/custom_textFields.dart';
import 'package:heart_rate_app/services/database_helper.dart';
import 'package:heart_rate_app/utils/app_images.dart';
import 'package:heart_rate_app/utils/constants.dart';

import '../local/cach_helper.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? passwordController;
  List<UserModel> usersList = [];

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    getUserData();
  }

  getUserData() async {
    List<Map<String, dynamic>> usersData =
        await DatabaseHelper.database!.rawQuery('SELECT * FROM "Users" ');
    usersList = usersData
        .map((e) => UserModel.fromJson(jsonDecode(e['userModel'])))
        .toList();
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: loginFormKey,
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
                  const Text(
                    'Log In',
                    style: kTitleStyle,
                  ),
                  10.verticalSpace,
                  const Text(
                    'Email:',
                    style: kLabelStyle,
                  ),
                  CustomTextField(
                    controller: emailController,
                  ),
                  5.verticalSpace,
                  const Text(
                    'Password:',
                    style: kLabelStyle,
                  ),
                  CustomTextField(
                    suffix: 'forget password?',
                    obscure: true,
                    controller: passwordController,
                  ),
                  10.verticalSpace,
                  CustomButton(Colors.black, Colors.white, 'LOG IN', () {
                    if (loginFormKey.currentState!.validate()) {
                      int index = usersList.indexWhere((element) =>
                          element.email == emailController!.text &&
                          element.password == passwordController!.text);
                      if (index != -1) {
                        cacheUser(
                            usersList[index].id.toString() ?? '',
                            usersList[index].name ?? '',
                            usersList[index].email ?? '',
                            usersList[index].phone ?? '',
                            usersList[index].password ?? '');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } else {
                        if (usersList.indexWhere((element) =>
                                element.email == emailController!.text) !=
                            -1) {
                          showMsg(context, 'Wrong Password');
                        } else {
                          showMsg(context, 'User not found');
                        }
                      }
                    }
                  }),
                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'New member?\n',
                            style: kFooterStyle,
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: kFooterStyle.copyWith(color: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void cacheUser(
      String id, String name, String email, String phone, String pass) {
    CacheHelper.putString(SharedKeys.id, id);
    CacheHelper.putString(SharedKeys.name, name);
    CacheHelper.putString(SharedKeys.email, email);
    CacheHelper.putString(SharedKeys.phone, phone);
    CacheHelper.putString(SharedKeys.password, pass);
  }
}
