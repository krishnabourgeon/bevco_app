// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/services/app_config.dart';
// import 'package:kiosk/services/helpers.dart';
// import 'package:kiosk/services/shared_preference_helper.dart';
// import 'package:kiosk/view/homepage.dart';
// import 'package:kiosk/view/loginscreen.dart';
// import 'package:provider/provider.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     checkLogged();
//     super.initState();
//   }

//   checkLogged() async {
//     await SharedPreferenceHelper.getToken();
//     Future.delayed(const Duration(seconds: 2), () => navToScreen());
//   }

//   navToScreen() async {
//     final home = context.read<HomeProvider>();

//     home.updateSelectedDate();
//     if ((AppConfig.accessToken ?? '').isNotEmpty) {
//       await home.getDeities();

//       await home.getStars();
//       await home.getPoojas(
//         deityId: home.deitiesResponse?.data![0].id.toString(),
//       );
//       if (!mounted) return;
//       home.getPaymentModes(
//         onFailure:
//             () => Helpers.successToast(
//               'Error occurred while fetching payment modes ....!',
//             ),
//       );

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//         (route) => false,
//       );
//     } else {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(45.r),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,

//                 children: [
//                   //old id 64 font size
//                   Text(
//                     "Sree Kadampuzha Bhagavathy Temple",
//                     style: Fontpalette.brown65700,
//                   ),
//                   Text(
//                     "Melmuri, Kadampuzha, Kerala",
//                     style: Fontpalette.grey45600,
//                   ),
//                 ],
//               ).verticalPadding(30.h).horizontalPadding(40.w),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/app_config.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/services/shared_preference_helper.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:kiosk/view/loginscreen.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  static const Color _charcoal = Color(0xFF1C1C1E);
  static const Color _charcoalLight = Color(0xFF2C2C2E);
  static const Color _bevcoRed = Color(0xFFD71920);
  static const Color _silver = Color(0xFFC0C0C0);

  // Update to your actual logo path
  static const String _logoAsset = 'assets/images/bevco_logo.png';

  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _lineWidth;
  late final Animation<double> _taglineFade;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.36, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.36, curve: Curves.easeOutCubic),
      ),
    );

    _lineWidth = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.36, 0.64, curve: Curves.easeInOut),
    );

    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.82, curve: Curves.easeOut),
    );

    _loaderFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    checkLogged();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  checkLogged() async {
    await SharedPreferenceHelper.getToken();
    try {
      await _controller.forward().orCancel;
    } catch (_) {
      return;
    }
    if (!mounted) return;
    navToScreen();
  }

  navToScreen() async {
    final home = context.read<HomeProvider>();

    home.updateSelectedDate();
    if ((AppConfig.accessToken ?? '').isNotEmpty) {
      await home.getDeities();

      await home.getStars();
      await home.getPoojas(
        deityId: home.deitiesResponse?.data![0].id.toString(),
      );
      if (!mounted) return;
      home.getPaymentModes(
        onFailure:
            () => Helpers.successToast(
              'Error occurred while fetching payment modes ....!',
            ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _charcoal,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [_charcoalLight, _charcoal],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              children: [
                // Logo, line and tagline
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: _logoFade.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.w,
                              vertical: 28.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32.r),
                              boxShadow: [
                                BoxShadow(
                                  color: _bevcoRed.withOpacity(0.25),
                                  blurRadius: 60.r,
                                  spreadRadius: 2.r,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              _logoAsset,
                              height: 140.h,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (_, __, ___) => Text(
                                    'BEVCO',
                                    style: TextStyle(
                                      fontSize: 72.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 6,
                                      color: _bevcoRed,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 36.h),
                      // Silver line drawing in
                      Container(
                        height: 3.h,
                        width: 260.w * _lineWidth.value,
                        decoration: BoxDecoration(
                          color: _silver,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Opacity(
                        opacity: _taglineFade.value,
                        child: Transform.translate(
                          offset: Offset(0, 10.h * (1 - _taglineFade.value)),
                          child: Text(
                            'SELF-SERVICE BEVERAGE KIOSK',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4,
                              color: _silver,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Red progress bar at the bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 60.h,
                  child: Opacity(
                    opacity: _loaderFade.value,
                    child: Center(
                      child: SizedBox(
                        width: 320.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            minHeight: 5.h,
                            color: _bevcoRed,
                            backgroundColor: Colors.white.withOpacity(0.12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}