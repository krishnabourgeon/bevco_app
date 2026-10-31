// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/color_pallatte.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/auth_provider.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/services/helpers.dart';
// import 'package:kiosk/view/homepage.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<AuthProvider>(
//         builder:
//             (context, auth, child) => Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: AlignmentDirectional.topCenter,
//                   end: AlignmentDirectional.bottomCenter,
//                   colors: [
//                     const Color.fromARGB(255, 243, 233, 98),
//                     const Color.fromARGB(255, 244, 245, 199),
//                     Colors.white,
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 470.h,
//                     left: -330.w,
//                     child: Container(
//                       height: 202.h,
//                       width: 702.w,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage("assets/images/flwr.png"),
//                         ),
//                       ),
//                     ),
//                   ),

//                   Positioned(
//                     top: 470.h,
//                     right: -330.w,
//                     child: Container(
//                       height: 202.h,
//                       width: 702.w,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage("assets/images/flwr.png"),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             height: 55.h,

//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(21.r),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: TextField(
//                               controller: auth.loginUsernameController,
//                               style: Fontpalette.blackinter50400,
//                               textAlignVertical: TextAlignVertical.center,
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 contentPadding: EdgeInsets.symmetric(
//                                   vertical: 12.h,
//                                   horizontal: 40.w,
//                                 ),

//                                 hintText: "Email",
//                                 hintStyle: Fontpalette.blackinter50400,
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           10.verticalSpace,
//                           Container(
//                             height: 55.h,

//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(21.r),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: TextField(
//                               obscureText: auth.visible,
//                               controller: auth.loginPasswordController,
//                               style: Fontpalette.blackinter50400,
//                               textAlignVertical: TextAlignVertical.center,
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 contentPadding: EdgeInsets.symmetric(
//                                   vertical: 12.h,
//                                   horizontal: 40.w,
//                                 ),

//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     auth.visible
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                   ),
//                                   onPressed: () => auth.updateVisibility(),
//                                 ),
//                                 hintText: "Password",
//                                 hintStyle: Fontpalette.blackinter50400,
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           20.verticalSpace,
//                           ValueListenableBuilder<bool>(
//                             valueListenable: isEnabled,
//                             builder:
//                                 (context, value, child) => InkWell(
//                                   onTap: () {
//                                     if (auth
//                                             .loginPasswordController
//                                             .text
//                                             .isEmpty ||
//                                         auth
//                                             .loginPasswordController
//                                             .text
//                                             .isEmpty) {
//                                       Helpers.successToast("Field is  empty");
//                                       return;
//                                     }
//                                     isEnabled.value = true;
//                                     FocusScope.of(context).unfocus();
//                                     auth.login(
//                                       onSuccess: () async {
//                                         final home =
//                                             context.read<HomeProvider>();
//                                         await home.getDeities();
//                                         await home.getStars();

//                                         home.getPaymentModes(
//                                           onFailure:
//                                               () => Helpers.successToast(
//                                                 'Error occurred while fetching payment modes ....!',
//                                               ),
//                                         );
//                                         await home.getPoojas(
//                                           deityId:
//                                               home.deitiesResponse?.data![0].id
//                                                   .toString(),
//                                         );
//                                         navigatescrren(
//                                           page: MyHomePage(),
//                                           context: context,
//                                         ).then((value) async {
//                                           await home.getCounter();
//                                           isEnabled.value = false;
//                                           auth.clearValues();
//                                         });
//                                       },
//                                       onFailure: () {
//                                         isEnabled.value = false;
//                                         Helpers.successToast(
//                                           auth.errorToast ?? '',
//                                         );
//                                       },
//                                     );
//                                   },

//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                               27.r,
//                                             ),
//                                             color: HexColor("#EC5002"),
//                                           ),
//                                           child: Center(
//                                             child:
//                                                 isEnabled.value == true
//                                                     ? CircularProgressIndicator(
//                                                       color: Colors.white,
//                                                     )
//                                                     : Text(
//                                                       "Continue",
//                                                       style:
//                                                           Fontpalette
//                                                               .white50500,
//                                                     ),
//                                           ).verticalPadding(20.h),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                           ),
//                         ],
//                       ),
//                       60.verticalSpace,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 107.h,
//                             width: 500.w,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: AssetImage(
//                                   "assets/images/logowithname.png",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "www.punnyamtemplesuite.com",
//                             style: Fontpalette.brown30600,
//                           ),
//                         ],
//                       ).horizontalPadding(100.w),
//                     ],
//                   ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
//                 ],
//               ),
//             ),
//       ),
//     );
//   }
// }

// navigatescrren({BuildContext? context, required page}) {
//   Navigator.of(context!).push(
//     PageRouteBuilder(
//       transitionDuration: Duration(milliseconds: 500),
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(opacity: animation, child: child);
//       },
//     ),
//   );
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/extension.dart';
import 'package:kiosk/fontpallate.dart';
import 'package:kiosk/provider/auth_provider.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);

  static const Color _charcoal = Color(0xFF17181C);
  static const Color _charcoalLight = Color(0xFF26282E);
  static const Color _bevcoRed = Color(0xFFD71920);
  static const Color _silver = Color(0xFFC9CCD1);

  @override
  void dispose() {
    isEnabled.dispose();
    super.dispose();
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: _silver.withOpacity(0.45)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: _bevcoRed,
        style: Fontpalette.blackinter50400.copyWith(color: Colors.white),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 40.w),
          hintText: hint,
          hintStyle: Fontpalette.blackinter50400.copyWith(
            color: _silver.withOpacity(0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Icon(icon, color: _silver),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 40.w),
          suffixIcon: suffix,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _onLoginTap(AuthProvider auth) async {
    if (auth.loginUsernameController.text.trim().isEmpty ||
        auth.loginPasswordController.text.isEmpty) {
      Helpers.successToast("Field is empty");
      return;
    }
    isEnabled.value = true;
    FocusScope.of(context).unfocus();
    auth.login(
      onSuccess: () async {
        final home = context.read<HomeProvider>();
        await home.getDeities();
        await home.getStars();

        home.getPaymentModes(
          onFailure:
              () => Helpers.successToast(
                'Error occurred while fetching payment modes ....!',
              ),
        );
        await home.getPoojas(
          deityId: home.deitiesResponse?.data![0].id.toString(),
        );
        navigatescrren(page: MyHomePage(), context: context).then((
          value,
        ) async {
          await home.getCounter();
          isEnabled.value = false;
          auth.clearValues();
        });
      },
      onFailure: () {
        isEnabled.value = false;
        Helpers.successToast(auth.errorToast ?? '');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _charcoal,
      body: Consumer<AuthProvider>(
        builder:
            (context, auth, child) => Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_charcoalLight, _charcoal],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -250.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 500.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _bevcoRed.withOpacity(0.35),
                            _bevcoRed.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(height: 8.h, color: _bevcoRed),
                  ),
                  SafeArea(
                    child: LayoutBuilder(
                      builder:
                          (context, constraints) => SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Logo
                                  Container(
                                    height: 107.h,
                                    width: 500.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                          "assets/images/bevco_logo.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  Text(
                                    "Welcome back",
                                    style: Fontpalette.white50500,
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    "Sign in to continue",
                                    style: Fontpalette.blackinter50400.copyWith(
                                      color: _silver.withOpacity(0.7),
                                    ),
                                  ),
                                  40.verticalSpace,

                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40.w,
                                      vertical: 40.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(27.r),
                                      border: Border.all(
                                        color: _silver.withOpacity(0.2),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 30,
                                          offset: const Offset(0, 14),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        _inputField(
                                          controller:
                                              auth.loginUsernameController,
                                          hint: "Email",
                                          icon: Icons.mail_outline_rounded,
                                        ),
                                        10.verticalSpace,
                                        _inputField(
                                          controller:
                                              auth.loginPasswordController,
                                          hint: "Password",
                                          icon: Icons.lock_outline_rounded,
                                          obscureText: auth.visible,
                                          suffix: IconButton(
                                            icon: Icon(
                                              auth.visible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: _silver,
                                            ),
                                            onPressed:
                                                () => auth.updateVisibility(),
                                          ),
                                        ),
                                        20.verticalSpace,
                                        ValueListenableBuilder<bool>(
                                          valueListenable: isEnabled,
                                          builder:
                                              (context, value, child) => InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(27.r),
                                                onTap:
                                                    value
                                                        ? null
                                                        : () =>
                                                            _onLoginTap(auth),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                27.r,
                                                              ),
                                                          gradient:
                                                              const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0xFFE53038,
                                                                  ),
                                                                  _bevcoRed,
                                                                ],
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: _bevcoRed
                                                                  .withOpacity(
                                                                    0.45,
                                                                  ),
                                                              blurRadius: 18,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    8,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child:
                                                              value
                                                                  ? const CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  )
                                                                  : Text(
                                                                    "Continue",
                                                                    style:
                                                                        Fontpalette
                                                                            .white50500,
                                                                  ),
                                                        ).verticalPadding(20.h),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  60.verticalSpace,
                                  // Text(
                                  //   "www.bevco.in", // TODO: replace with your BEVCO site
                                  //   style: Fontpalette.brown30600.copyWith(
                                  //     color: _silver.withOpacity(0.6),
                                  //   ),
                                  // ),
                                ],
                              ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

Future<void> navigatescrren({BuildContext? context, required page}) {
  return Navigator.of(context!).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}