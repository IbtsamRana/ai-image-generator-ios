import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imagecreator/src/utils/app_assets.dart';
import 'package:imagecreator/src/utils/app_icons.dart';
import 'package:imagecreator/src/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../core/service/subscription_service.dart';
import '../../../../utils/app_colors.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final List<String> features = [
    "Ai Creation",
    "BG Remover",
    "Unlock all Canvases"
  ];
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    return ValueListenableBuilder<InAppModel>(
        valueListenable: subscriptionsController,
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
                width: context.width,
                height: context.height,
                decoration: const BoxDecoration(color: AppColors.sideBarColor),
                child: controller.productDetails.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  AppAssets.premiumImage,
                                  width: context.width,
                                  fit: BoxFit.fitWidth,
                                  height: context.height * 0.4,
                                ),
                                // Positioned(
                                //   top: context.height * 0.05,
                                //   child: InkWell(
                                //     child: SvgPicture.string(
                                //       AppIcons.premiumBackIcon,
                                //       width: 70,
                                //       height: 70,
                                //     ),
                                //     onTap: () {
                                //       NavigationService.goBack();
                                //     },
                                //   ),
                                // ),
                                Positioned(
                                  top: context.height * 0.055,
                                  right: context.width * 0.03,
                                  child: InkWell(
                                    child: Container(
                                      width: context.width * 0.4,
                                      height: context.height * 0.04,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color(0xFF0693E1)),
                                      child: const Center(
                                        child: Text(
                                          "Restore Purchase",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      subscriptionsController
                                          .restoreSubscription();
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            const Text(
                              "Get Full Access To Premium Features",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            for (final data in features)
                              Container(
                                margin:
                                    EdgeInsets.only(top: context.height * 0.02),
                                width: context.width * 0.8,
                                child: Row(
                                  children: [
                                    SvgPicture.string(
                                      AppIcons.premiumIcon,
                                      height: context.height * 0.025,
                                    ),
                                    SizedBox(
                                      width: context.width * 0.04,
                                    ),
                                    Text(
                                      data,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            for (final data in controller.productDetails)
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      subscriptionsController.setProduct(data);
                                    },
                                    child: Container(
                                      width: context.width,
                                      margin: EdgeInsets.only(
                                          top: context.height * 0.02,
                                          left: context.width * 0.05,
                                          right: context.width * 0.05),
                                      height: context.height * 0.06,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: context.width * 0.05),
                                      decoration: BoxDecoration(
                                          border: controller.selectProduct !=
                                                      null &&
                                                  controller.selectProduct ==
                                                      data
                                              ? Border.all(
                                                  color: AppColors.darkPink)
                                              : null,
                                          color: const Color(0xFF2B313F),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${data.price} / ${duration(data.id)}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          Icon(
                                            controller.selectProduct != null &&
                                                    controller.selectProduct ==
                                                        data
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: controller.selectProduct !=
                                                        null &&
                                                    controller.selectProduct ==
                                                        data
                                                ? AppColors.darkPink
                                                : Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (data.id == monthly)
                                    Positioned(
                                      top: context.height * 0.01,
                                      right: context.width * 0.15,
                                      child: Container(
                                        width: context.width * 0.25,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.darkPink,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Text(
                                            "Save 88%",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            InkWell(
                              onTap: () {
                                if (controller.selectProduct == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Kindly select plan")));
                                  return;
                                }
                                if (controller.productDetails
                                    .where((p0) =>
                                        p0.id == controller.selectProduct!.id)
                                    .where((element) => element.rawPrice == 0)
                                    .isEmpty) {
                                  subscriptionsController.subscribe(
                                      product: controller.selectProduct!);
                                } else {
                                  subscriptionsController.subscribe(
                                      product: controller.productDetails
                                          .where((p0) =>
                                              p0.id ==
                                              controller.selectProduct!.id)
                                          .where((element) =>
                                              element.rawPrice == 0)
                                          .first);
                                }
                              },
                              borderRadius: borderRadius,
                              child: Container(
                                width: context.width * 0.9,
                                height: context.height * 0.08,
                                decoration: BoxDecoration(
                                    gradient: AppColors.gradientButton,
                                    borderRadius: borderRadius),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    if (controller.selectProduct != null &&
                                        controller.selectProduct!.id == monthly)
                                      const Text(
                                        "3 Days Free Trial",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(
                                            Uri.parse(
                                                'https://appcodersios.blogspot.com/2024/02/App-Coders-Terms-Of-Use.html'),
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                    text: "Terms of services",
                                    style: const TextStyle(fontSize: 17)),
                                const TextSpan(
                                    text: " | ",
                                    style: TextStyle(fontSize: 17)),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NavigationService.goBack();
                                      },
                                    text: "Free Plan",
                                    style: const TextStyle(fontSize: 17)),
                                const TextSpan(
                                    text: " | ",
                                    style: TextStyle(fontSize: 17)),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(
                                            Uri.parse(
                                                'https://appcodersios.blogspot.com/2024/02/App-Coders-Privacy-Policy.html'),
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                    text: "Privacy Policy",
                                    style: const TextStyle(fontSize: 17))
                              ]),
                            )
                          ],
                        ),
                      )),
          );
        });
  }

  String duration(String productid) {
    if (productid == basic) {
      return "Weekly";
    } else if (productid == monthly) {
      return "Monthly";
    } else {
      return "";
    }
  }
}
