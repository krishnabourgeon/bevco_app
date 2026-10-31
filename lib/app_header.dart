import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  // Change this one number to make the logo and all text bigger or smaller.
  static const double scale = 1.3;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 100.w, vertical: 60.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                25.verticalSpace,
                Text(
                  "KSBC",
                  style: TextStyle(
                    color: Color(0xFFD71920),
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  "Kerala State Beverages (M&M) Corporation Ltd.",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp),
                ),
                Text(
                  "A Govt. of Kerala Undertaking",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp),
                ),
              ],
            ),
            SizedBox(
              height: 70.h,
              width: 250.w,
              child: Image.asset(
                "assets/images/bevco_logo.png",
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}