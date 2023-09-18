import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_rate_app/screens/signup_page.dart';
import 'package:heart_rate_app/screens/widgets/custom_button.dart';
import 'package:heart_rate_app/screens/widgets/custom_container.dart';
import 'package:heart_rate_app/utils/app_images.dart';

import 'login_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              SizedBox(
                height: .28.sh,
              ),
              Image.asset(
                AppImages.appLogo,
                width: 145,
                height: 120,
              ),
              30.verticalSpace,
              CustomButton(Colors.white, Colors.black, 'LOG IN', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
              10.verticalSpace,
              CustomButton(Colors.black, Colors.white, 'SIGN UP', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              }),
            ],
          ),
        ),
      ),
    ));
  }
}
