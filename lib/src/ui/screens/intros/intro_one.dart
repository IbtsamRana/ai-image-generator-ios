import 'package:flutter/material.dart';
import 'package:imagecreator/main.dart';
import 'package:imagecreator/src/core/navigation/navigation.dart';
import 'package:imagecreator/src/ui/compnents/gradient_button.dart';
import 'package:imagecreator/src/ui/screens/intros/intro_two.dart';
import 'package:imagecreator/src/utils/app_assets.dart';
import 'package:imagecreator/src/utils/app_colors.dart';
import 'package:imagecreator/src/utils/extensions.dart';

import '../../../utils/app_constants.dart';

class IntroOne extends StatelessWidget {
  const IntroOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: context.width,
        height: context.height,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Column(
          children: [
            Image.asset(
              AppAssets.introOne,
              width: context.width,
              fit: BoxFit.fill,
              height: context.height * 0.7,
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
            const Text(
              "AI Image Generator",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: context.height * 0.01,
            ),
            const Text(
              "Turn words into Art",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            GradientButton(
              onTap: () {
                NavigationService.replaceScreen(const IntroTwo());
                storageService.set(AppConstants.introDone, true);
              },
              text: "Get Started",
              width: context.width * 0.8,
              height: context.height * 0.055,
            )
          ],
        ),
      ),
    );
  }
}
