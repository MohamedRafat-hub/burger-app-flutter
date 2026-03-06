import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/custom_text.dart';
import '../checkout_view.dart';
import 'custom_order_price_details.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key, required this.price});
  final double price;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        CustomText(
          text: 'Order Summary',
          size: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3C2F2F),
        ),
        CustomOrderPriceDetails(
          title: 'Order',
          price: price.toString(),
        ),
        CustomOrderPriceDetails(
          title: 'Taxes',
          price: '10',
        ),
        CustomOrderPriceDetails(
          title: 'Delivery fees',
          price: '15',
        ),
        Divider(),
        Row(
          children: [
            Text(
              'Total:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            Spacer(),
            Text(
              '\$${price + 10 + 15}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Estimated delivery time:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            Spacer(),
            Text(
              '15 - 30 mins',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Gap(15),
      ],
    );
  }
}