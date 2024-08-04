import 'package:flutter/material.dart';
import 'package:imagecreator/src/ui/screens/main_screen/main_screen.dart';
import 'package:imagecreator/src/utils/extensions.dart';

import '../../../core/navigation/navigation.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../compnents/gradient_button.dart';

class IntroTwo extends StatelessWidget {
  const IntroTwo({super.key});

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
            SizedBox(
              height: context.height * 0.7,
              child: Center(
                child: Stack(
                  children: [
                    Image.asset(
                      AppAssets.introTwoMask,
                      width: context.width,
                      fit: BoxFit.fitWidth,
                      height: context.height * 0.5,
                    ),
                    Positioned(
                      top: context.height * 0.15,
                      child: Image.asset(
                        AppAssets.introTwo,
                        width: context.width,
                        fit: BoxFit.fitWidth,
                        height: context.height * 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
            const Text(
              "Background  Remover",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: context.height * 0.05,
            ),
            GradientButton(
              onTap: () {
                NavigationService.replaceScreen(const MainScreen());
              },
              text: "Continue",
              width: context.width * 0.8,
              height: context.height * 0.055,
            )
          ],
        ),
      ),
    );
  }
}
