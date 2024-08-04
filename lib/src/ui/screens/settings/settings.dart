import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:imagecreator/src/ui/compnents/gradient_button.dart';
import 'package:imagecreator/src/ui/screens/main_screen/premium_screen/premium_screen.dart';
import 'package:imagecreator/src/ui/screens/main_screen/rating_dialog/rating_dialog.dart';
import 'package:imagecreator/src/utils/app_assets.dart';
import 'package:imagecreator/src/utils/app_icons.dart';
import 'package:imagecreator/src/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/model/tool_model/tool_model.dart';
import '../../../core/navigation/navigation.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final List<ToolModel> containerList = [
      ToolModel(
          image: AppIcons.rateUs, name: "Rate Us", toolName: ToolName.rateUs),
      ToolModel(
        image: AppIcons.shareUs,
        name: "Share",
        toolName: ToolName.shareUs,
      ),
      ToolModel(
          image: AppIcons.feedback,
          name: "Feedback",
          toolName: ToolName.feedback),
      ToolModel(
          image: AppIcons.privacy,
          name: "Privacy Policy",
          toolName: ToolName.privacyPolicy),
      ToolModel(
          image: AppIcons.rateUs,
          name: "Rate us",
          toolName: ToolName.termsOfUse),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          width: context.width,
          height: context.height,
          padding: EdgeInsets.only(
              left: context.width * 0.05, right: context.width * 0.05),
          decoration:
              const BoxDecoration(gradient: AppColors.imageCreatorGradient),
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.06,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      NavigationService.goBack();
                    },
                    child: Container(
                      width: context.height * 0.045,
                      height: context.height * 0.045,
                      decoration: const BoxDecoration(
                          color: AppColors.darkPink, shape: BoxShape.circle),
                      child: Center(
                        child: SvgPicture.string(
                          AppIcons.arrrowBack,
                          width: context.height * 0.02,
                          height: context.height * 0.02,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.02,
                  ),
                  const Text(
                    "Settings",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),
              Container(
                width: context.width,
                height: context.height * 0.18,
                margin: EdgeInsets.only(top: context.height * 0.02),
                padding: EdgeInsets.only(
                    left: context.width * 0.05, right: context.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin:
                        Alignment(-0.996, -0.259), // Calculated based on angle
                    end: Alignment(0.866, 0.5), // Calculated based on angle
                    colors: [
                      Color(0xFF090019),
                      Color(0xFF420A63),
                    ],
                    stops: [
                      -0.001,
                      1.135
                    ], // Adjusted for 0% to start and 100% for end
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Unlimited Artwork Styles",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          GradientButton(
                            onTap: () {
                              NavigationService.navigateToScreen(
                                  const PremiumScreen());
                            },
                            text: "Try Pro Now",
                            width: context.width * 0.5,
                          )
                        ],
                      ),
                    ),
                    Image.asset(
                      AppAssets.upgrade,
                      height: context.height * 0.1,
                    )
                  ],
                ),
              ),
              for (final data in containerList)
                InkWell(
                  onTap: () {
                    selection(data.toolName);
                  },
                  child: Container(
                    width: context.width,
                    height: context.height * 0.06,
                    margin: EdgeInsets.only(top: context.height * 0.02),
                    padding:
                        EdgeInsets.symmetric(horizontal: context.width * 0.03),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: const GradientBoxBorder(
                            gradient: AppColors.selectionGradient)),
                    child: Row(
                      children: [
                        SvgPicture.string(
                          data.image,
                          height: context.height * 0.02,
                          width: context.height * 0.02,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: context.width * 0.05,
                        ),
                        Text(
                          data.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
            ],
          )),
    );
  }

  void selection(
    ToolName name,
  ) async {
    switch (name) {
      case ToolName.rateUs:
        final data = await showDialog(
            context: context, builder: (ctx) => const RatingDialog());
        if (data != null) {
          launchUrl(Uri.parse(
              "https://apps.apple.com/us/app/ai-art-generator-bg-remover/id6477200348"));
        }
        break;

      case ToolName.feedback:
        launchUrl(Uri.parse(
          'mailto:Arslanahmed.112200i@gmail.com',
        ));
        break;

      case ToolName.privacyPolicy:
        launchUrl(
            Uri.parse(
                'https://appcodersios.blogspot.com/2024/02/App-Coders-Privacy-Policy.html'),
            mode: LaunchMode.externalApplication);
        break;
      case ToolName.termsOfUse:
        launchUrl(
            Uri.parse(
                'https://appcodersios.blogspot.com/2024/02/App-Coders-Terms-Of-Use.html'),
            mode: LaunchMode.externalApplication);
        break;
      case ToolName.shareUs:
        Share.share('''🌟 Hey Friend! 🌟

Just found the coolest app to jazz up your pics! 📸 It's the AI Image Generator – turns your photos into jaw-dropping art in seconds! 🎨✨

Check it out! ${Platform.isMacOS ? "https://apps.apple.com/us/app/ai-image-creator/id6477715324" : "https://apps.apple.com/us/app/ai-art-generator-bg-remover/id6477200348"} ''');
        break;
      default:
    }
  }
}
