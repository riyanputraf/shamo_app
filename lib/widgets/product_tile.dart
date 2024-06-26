import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/pages/product_page.dart';
import 'package:shamo_app/theme.dart';

import '../utils/url_util.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    String imageUrl = updateLocalhostUrl(product.galleries[0].url);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: defaultMargin.w,
          right: defaultMargin.w,
          bottom: defaultMargin.h,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported,
                  size: 150.w,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.category}',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    product.name,
                    style: primaryTextStyle.copyWith(
                      fontWeight: semibold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    '\$${product.price}',
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
