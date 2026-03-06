import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider(
      {super.key, required this.value, this.onChanged, required this.image , this.title});

  final double value;
  final void Function(double)? onChanged;
  final String image;
  final String? title;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Image
        CachedNetworkImage(
          height: 200,
          imageUrl: widget.image,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        // Image.network(
        //   widget.image,
        // ),

        Center(
          child: CustomText(
            maxLines: 10,
            textAlign: TextAlign.center,
              text: '${widget.title}',
              // color: Color(0xFF3C2F2F),
              color: AppColors.primaryColor,
              size: 18,
              fontWeight: FontWeight.w600),
        ),
        Gap(10),
        CustomText(
            text: 'Spicy',
            // color: Color(0xFF3C2F2F),
            color: Colors.red,
            size: 18,
            fontWeight: FontWeight.w600),
        Slider(
          min: 0,
          max: 1,
          value: widget.value,
          onChanged: widget.onChanged,
          activeColor: AppColors.primaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gap(20),
            CustomText(
              text: 'Cold 🥶',
              size: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CustomText(
                text: 'Hot 🌶',
                size: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
