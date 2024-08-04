import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecreator/src/core/navigation/navigation.dart';
import 'package:imagecreator/src/ui/compnents/gradient_button.dart';
import 'package:imagecreator/src/utils/app_colors.dart';
import 'package:imagecreator/src/utils/app_icons.dart';
import 'package:imagecreator/src/utils/extensions.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int rate = 5;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0A051B),
      insetPadding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.06),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.03,
            ),
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
              child: SvgPicture.string(
                AppIcons.heart,
                width: 20,
                height: 20,
              ),
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
            const Text(
              "Hey Drop some Rating!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: context.height * 0.01,
            ),
            const Text(
              "How is your experience with this application so far",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  5,
                  (index) => InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          setState(() {
                            rate = index + 1;
                          });
                        },
                        child: Container(
                          width: context.width * 0.1,
                          height: context.width * 0.1,
                          decoration: BoxDecoration(
                              color: (index + 1) == rate
                                  ? AppColors.darkPink
                                  : Colors.grey,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            GradientButton(
              text: "Submit",
              onTap: () {
                NavigationService.goBack(data: rate);
              },
              width: context.width,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
