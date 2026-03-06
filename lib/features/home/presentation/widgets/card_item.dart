import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/home/data/models/product_model.dart';
import 'package:gap/gap.dart';

import '../../../../shared/custom_text.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.productModel,
  });

  final ProductModel? productModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                width: 120,
                height: 120,
                imageUrl: productModel?.secureImageUrl ?? 'assets/images/splash.png',
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
                errorWidget: (context, url, error) => const Icon(Icons.error_outline),
              ),
            ),
            // Center(
            //   child: productModel?.image != null
            //       ? Image.network(
            //           productModel!.image,
            //           width: 120,
            //           height: 120,
            //         )
            //       : Image.asset(
            //           'assets/images/splash.png',
            //           width: 120,
            //           height: 120,
            //         ),
            // ),
            Gap(5),
            CustomText(
                text: productModel?.name ?? '',
                color: Color(0xFF3C2F2F),
                size: 16,
                fontWeight: FontWeight.w600),
            Gap(6),
            CustomText(
              text: productModel?.desc ?? '',
              color: Color(0xFF3C2F2F),
              size: 16,
              fontWeight: FontWeight.w600,
            ),
            Text(
              '⭐ ${productModel?.rating ?? ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
