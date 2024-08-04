import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecreator/src/core/navigation/navigation.dart';
import 'package:imagecreator/src/utils/app_assets.dart';
import 'package:imagecreator/src/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/service/api_service.dart';
import '../../../../utils/app_colors.dart';

class ResultScreen extends StatefulWidget {
  final String url;
  final Uint8List? image;
  const ResultScreen({super.key, required this.url, this.image});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
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
                          AppAssets.cancel,
                          width: context.height * 0.02,
                          height: context.height * 0.02,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.02,
                  ),
                  Text(
                    widget.image == null ? "AI Image" : "BG Remover",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),
              Expanded(
                  child: Center(
                      child: widget.image == null
                          ? Image.network(
                              widget.url,
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Image.memory(
                              widget.image!,
                            ))),
              Padding(
                padding: EdgeInsets.only(
                    bottom: context.height * 0.03,
                    top: context.height * 0.03,
                    left: context.width * 0.05,
                    right: context.width * 0.05),
                child: Text(
                  widget.image != null
                      ? "Background removed successfully!"
                      : "Image Generated successfully!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  ApiService.saveImage(context,
                      url: widget.url, image: widget.image);
                },
                borderRadius: borderRadius,
                child: Container(
                    width: context.width,
                    height: context.height * 0.055,
                    decoration: BoxDecoration(
                        gradient: AppColors.gradientButton,
                        borderRadius: borderRadius),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          AppAssets.downloadLogo,
                          height: context.height * 0.035,
                        ),
                        SizedBox(
                          width: context.width * 0.05,
                        ),
                        const Text(
                          "Download",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: context.height * 0.03,
              ),
              InkWell(
                onTap: () async {
                  final newimage = await ApiService.shareImage(
                      url: widget.url, image: widget.image);
                  if (widget.image != null) {
                    Share.shareXFiles([XFile(newimage!.path)]);
                  }
                },
                borderRadius: borderRadius,
                child: Container(
                    width: context.width,
                    height: context.height * 0.055,
                    decoration: BoxDecoration(
                        gradient: AppColors.gradientButton,
                        borderRadius: borderRadius),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          AppAssets.share,
                          height: context.height * 0.035,
                        ),
                        SizedBox(
                          width: context.width * 0.05,
                        ),
                        const Text(
                          "Share",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: context.height * 0.04,
              ),
            ],
          )),
    );
  }
}
