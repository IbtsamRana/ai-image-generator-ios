import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecreator/main.dart';
import 'package:imagecreator/src/ui/screens/main_screen/background_remover/background_remover.dart';
import 'package:imagecreator/src/ui/screens/main_screen/image_generator/image_generator.dart';
import 'package:imagecreator/src/utils/app_colors.dart';
import 'package:imagecreator/src/utils/app_icons.dart';

import '../../../core/navigation/navigation.dart';
import 'premium_screen/premium_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> widgets = [
    const ImageGenerator(),
    const BackgroundRemover()
  ];
  int index = 0;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (!user.premium) {
        NavigationService.navigateToScreen(const PremiumScreen());
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white60,
          selectedItemColor: Colors.white,
          selectedLabelStyle:
              const TextStyle(color: Colors.white, fontSize: 15),
          unselectedLabelStyle:
              const TextStyle(color: Colors.white60, fontSize: 15),
          backgroundColor: AppColors.sideBarColor,
          onTap: (val) {
            setState(() {
              index = val;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.string(
                  index == 0
                      ? AppIcons.aiImageGenerator
                      : AppIcons.aiImageGeneratorLight,
                  width: 24,
                  height: 24,
                ),
                label: "Ai Image"),
            BottomNavigationBarItem(
                icon: SvgPicture.string(
                  AppIcons.backgroundRemover,
                  width: 24,
                  height: 24,
                  colorFilter: index == 1
                      ? null
                      : const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
                ),
                label: "BG Remove")
          ]),
      body: widgets[index],
    );
  }
}
