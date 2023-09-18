import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_rate_app/model/user_model.dart';
import 'package:heart_rate_app/screens/home_page.dart';
import 'package:heart_rate_app/screens/login_page.dart';
import 'package:heart_rate_app/screens/widgets/custom_button.dart';
import 'package:heart_rate_app/screens/widgets/custom_container.dart';
import 'package:heart_rate_app/screens/widgets/custom_textFields.dart';

import '../local/cach_helper.dart';
import '../local/shared_keys.dart';
import '../services/database_helper.dart';
import '../utils/app_images.dart';
import '../utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final signUpFormKey = GlobalKey<FormState>();
  TextEditingController? nameController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController!.dispose();
    phoneController!.dispose();
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
          key: signUpFormKey,
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
                'Sign Up',
                style: kTitleStyle,
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
              CustomButton(Colors.black, Colors.white, 'SIGN UP', () {
                setState(() {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (signUpFormKey.currentState!.validate()) {
                    int index = DateTime.now().toUtc().millisecondsSinceEpoch;
                    UserModel person = UserModel(
                        index,
                        nameController!.text,
                        phoneController!.text,
                        emailController!.text,
                        passwordController!.text, [], []);
                    DatabaseHelper.database!.insert('Users', {
                      'id': index,
                      'userModel': jsonEncode(person.toJson())
                    });
                    cacheUser(
                        index.toString(),
                        nameController!.text,
                        emailController!.text,
                        phoneController!.text,
                        passwordController!.text);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                });
              }),
              30.verticalSpace,
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have an account? ',
                        style: kFooterStyle,
                      ),
                      TextSpan(
                        text: 'Log In',
                        style: kFooterStyle.copyWith(color: Colors.white),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    ));
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
