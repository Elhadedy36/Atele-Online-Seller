import 'package:atele_seller/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInImage extends StatelessWidget {
  const SignInImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235.h,
      width: 235.w,
      child: Image.asset(Assets.imagesFashion),
    );
  }
}
