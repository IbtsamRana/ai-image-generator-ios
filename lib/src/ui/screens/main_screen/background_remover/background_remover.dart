import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecreator/src/ui/screens/main_screen/result/result.dart';
import 'package:imagecreator/src/utils/app_assets.dart';
import 'package:imagecreator/src/utils/extensions.dart';

import '../../../../../main.dart';
import '../../../../core/model/purchase_model/purchase_model.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../core/service/api_service.dart';
import '../../../../utils/api_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_icons.dart';
import '../../settings/settings.dart';
import '../premium_screen/premium_screen.dart';

class BackgroundRemover extends StatefulWidget {
  const BackgroundRemover({super.key});

  @override
  State<BackgroundRemover> createState() => _BackgroundRemoverState();
}

class _BackgroundRemoverState extends State<BackgroundRemover> {
  late num chances;

  @override
  void initState() {
    chances = storageService.get(AppConstants.backgroundremover) ?? 1;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PurchaseModel>(
        valueListenable: user,
        builder: (context, model, child) {
          return Container(
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
                          NavigationService.navigateToScreen(const Settings());
                        },
                        child: Container(
                          width: context.height * 0.045,
                          height: context.height * 0.045,
                          decoration: const BoxDecoration(
                              color: AppColors.darkPink,
                              shape: BoxShape.circle),
                          child: Center(
                            child: SvgPicture.string(
                              AppIcons.settings,
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
                        "BG Remover",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      // if (!model.isPremium)
                        Container(
                          width: context.width * 0.22,
                          height: context.height * 0.035,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: AppColors.darkPink,
                              )),
                          child: Center(
                            child: Text(
                              "$chances credits",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      if (!model.isPremium)
                        InkWell(
                          onTap: () {
                            NavigationService.navigateToScreen(
                                const PremiumScreen());
                          },
                          child: Container(
                            width: context.width * 0.22,
                            margin: EdgeInsets.only(left: context.width * 0.02),
                            height: context.height * 0.035,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColors.darkPink,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.translate(
                                  offset: Offset(0, -context.height * 0.002),
                                  child: SvgPicture.string(
                                    AppIcons.proIcon,
                                    height: context.height * 0.02,
                                  ),
                                ),
                                const Text(
                                  "Get Pro",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                  SizedBox(
                    height: context.width * 0.05,
                  ),
                  Image.asset(
                    AppAssets.backgroundRemover,
                    width: context.width,
                    fit: BoxFit.fitWidth,
                    height: context.height * 0.3,
                  ),
                  SizedBox(
                    height: context.width * 0.02,
                  ),
                  Container(
                    width: context.width * 0.3,
                    height: context.height * 0.01,
                    margin: EdgeInsets.only(bottom: context.height * 0.03),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const Text(
                    "Add Your Images",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: context.height * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: context.width * 0.05,
                        right: context.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            InkWell(
                                onTap: () async {
                                  if (!model.isPremium) {
                                    NavigationService.navigateToScreen(
                                        const PremiumScreen());
                                    return;
                                  }
                                  final images = await ApiService.picImage(
                                      ImageSource.camera);
                                  if (images != null) {
                                    checkCondition(images,
                                        premium: model.isPremium);
                                  }
                                },
                                child: Container(
                                  width: context.width * 0.35,
                                  height: context.height * 0.15,
                                  padding: EdgeInsets.only(
                                      top: context.height * 0.02,
                                      bottom: context.height * 0.02,
                                      left: context.width * 0.05,
                                      right: context.width * 0.05),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: const GradientBoxBorder(
                                          gradient:
                                              AppColors.selectionGradient)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.string(
                                        AppAssets.camera,
                                        height: context.height * 0.05,
                                        width: context.width * 0.15,
                                      ),
                                      const Text(
                                        "Camera",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                )),
                            if (!model.isPremium)
                              Transform.translate(
                                offset: Offset(context.width * 0.3,
                                    -context.height * 0.02),
                                child: SvgPicture.string(
                                  AppAssets.locked,
                                  width: context.width * 0.08,
                                  height: context.width * 0.08,
                                ),
                              )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            final images =
                                await ApiService.picImage(ImageSource.gallery);
                            if (images != null) {
                              checkCondition(images, premium: model.isPremium);
                            }
                          },
                          child: Container(
                            width: context.width * 0.35,
                            height: context.height * 0.15,
                            padding: EdgeInsets.only(
                                top: context.height * 0.02,
                                bottom: context.height * 0.02,
                                left: context.width * 0.05,
                                right: context.width * 0.05),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: const GradientBoxBorder(
                                    gradient: AppColors.selectionGradient)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.string(
                                  AppAssets.gallery,
                                  height: context.height * 0.05,
                                  width: context.width * 0.15,
                                ),
                                const Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  void checkCondition(File file, {required bool premium}) {
    if (chances > 0) {
      _removeBackground(file, premium: premium);
    } else {
      NavigationService.navigateToScreen(const PremiumScreen());
    }
  }

  void _removeBackground(File image, {required bool premium}) async {
    onLoading();

    try {
      if (chances > 0) {

        final data = await ApiService.removeBackground(image);

        storageService.set(AppConstants.backgroundremover, chances - 1);
        setState(() {
          chances = chances - 1;
        });

        NavigationService.goBack();

        await NavigationService.navigateToScreen(ResultScreen(
          url: "",
          image: data,
        ));
      }
    } catch (e) {
      NavigationService.goBack();
    }
  }
}
