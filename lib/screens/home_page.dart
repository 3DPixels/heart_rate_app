import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_rate_app/screens/editProfile_page.dart';
import 'package:heart_rate_app/screens/file_page.dart';
import 'package:heart_rate_app/screens/reminder_page.dart';
import 'package:heart_rate_app/screens/welcome_page.dart';
import 'package:heart_rate_app/screens/widgets/custom_container.dart';
import 'package:heart_rate_app/utils/app_images.dart';
import 'package:heart_rate_app/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to logout?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), //<-- SEE HERE
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            10.verticalSpace,
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            15.verticalSpace,
            Image.asset(
              AppImages.appLogo,
              width: 85,
              height: 75,
            ),
            20.verticalSpace,
            const Text(
              'Choose your service',
              style: kSubtitleStyle,
            ),
            30.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FileScreen()));
                  },
                  child: Container(
                    width: 165,
                    height: 260,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.listIcon,
                          width: 90,
                          height: 90,
                        ),
                        8.verticalSpace,
                        const Text(
                          'file',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReminderScreen()));
                  },
                  child: Container(
                    width: 165,
                    height: 260,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.reminderIcon,
                          width: 90,
                          height: 90,
                        ),
                        8.verticalSpace,
                        const Text(
                          'Reminder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    ));
  }
}
