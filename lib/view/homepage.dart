// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:kiosk/color_pallatte.dart';
// // import 'package:kiosk/extension.dart';
// // import 'package:kiosk/fontpallate.dart';
// // import 'package:kiosk/provider/homeprovider.dart';
// // import 'package:kiosk/services/helpers.dart';
// // import 'package:kiosk/services/shared_preference_helper.dart';
// // import 'package:kiosk/view/loginscreen.dart';
// // import 'package:kiosk/view/selectedscreen.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key});

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   void initState() {
// //     getCounterID();
// //     super.initState();
// //   }

// //   getCounterID() async {
// //     String id = await SharedPreferenceHelper.getCounterID();
// //     if (id == '') {
// //       _showCounters();
// //     }
// //   }

// //   String? _chosenValue;
// //   String? selectedCounterID;
// //   void _showCounters() {
// //     Future.microtask(() {
// //       context.read<HomeProvider>().getCounter().then((value) {
// //         showDialog<bool>(
// //           barrierDismissible: false,
// //           context: context,
// //           builder: (BuildContext context) {
// //             return StatefulBuilder(
// //               builder: (BuildContext context, StateSetter setState) {
// //                 return PopScope(
// //                   canPop: false,
// //                   child: Consumer<HomeProvider>(
// //                     builder: (context, provider, _) {
// //                       return AlertDialog(
// //                         title: Text(
// //                           "Choose Counter",
// //                           style: Fontpalette.blackinter45400,
// //                         ),
// //                         content: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: <Widget>[
// //                             Text(
// //                               "Please select a counter.",
// //                               style: Fontpalette.blackinter40400,
// //                             ),
// //                             SingleChildScrollView(
// //                               scrollDirection: Axis.horizontal,
// //                               child: DropdownButton<String>(
// //                                 hint: Text(
// //                                   'Select',
// //                                   style: Fontpalette.blackinter28400,
// //                                 ),
// //                                 value: _chosenValue,
// //                                 underline: Container(),
// //                                 items:
// //                                     provider.counterName.map((String value) {
// //                                       return DropdownMenuItem<String>(
// //                                         value: value,
// //                                         child: Text(
// //                                           value,
// //                                           style: Fontpalette.blackinter30600,
// //                                         ),
// //                                       );
// //                                     }).toList(),
// //                                 onChanged: (value) async {
// //                                   final SharedPreferences prefs =
// //                                       await SharedPreferences.getInstance();

// //                                   setState(() {
// //                                     _chosenValue = value;
// //                                     for (
// //                                       int i = 0;
// //                                       i < provider.counterName.length;
// //                                       i++
// //                                     ) {
// //                                       if (provider.counterName[i] ==
// //                                           _chosenValue) {
// //                                         selectedCounterID =
// //                                             provider.counterId[i];

// //                                         prefs.setString(
// //                                           "counterid",
// //                                           selectedCounterID.toString(),
// //                                         );
// //                                       }
// //                                     }
// //                                   });
// //                                 },
// //                               ),
// //                             ),
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.end,
// //                               children: [
// //                                 TextButton(
// //                                   child: Text(
// //                                     "SAVE",
// //                                     style: Fontpalette.blackinter42700,
// //                                   ),
// //                                   onPressed: () async {
// //                                     if ((selectedCounterID != null)) {
// //                                       await SharedPreferenceHelper.saveCounterID(
// //                                         selectedCounterID ?? "",
// //                                       ).then((value) async {
// //                                         Navigator.of(context).pop();
// //                                       });
// //                                     } else {
// //                                       Helpers.successToast(
// //                                         "Should Select Counter",
// //                                       );
// //                                     }
// //                                   },
// //                                 ),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 );
// //               },
// //             );
// //           },
// //         );
// //       });
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: AlignmentDirectional.topCenter,
// //             end: AlignmentDirectional.bottomCenter,
// //             colors: [
// //               const Color.fromARGB(255, 243, 233, 98),
// //               const Color.fromARGB(255, 244, 245, 199), // Start color
// //               Colors.white,
// //               Colors.white, // End color
// //             ],
// //           ),
// //         ),
// //         child: Stack(
// //           children: [
// //             Positioned(
// //               top: 470.h,
// //               left: -330.w,
// //               child: Container(
// //                 height: 202.h,
// //                 width: 702.w,
// //                 decoration: BoxDecoration(
// //                   image: DecorationImage(
// //                     fit: BoxFit.fill,
// //                     image: AssetImage("assets/images/flwr.png"),
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             Positioned(
// //               top: 470.h,
// //               right: -330.w,
// //               child: Container(
// //                 height: 202.h,
// //                 width: 702.w,
// //                 decoration: BoxDecoration(
// //                   image: DecorationImage(
// //                     fit: BoxFit.fill,
// //                     image: AssetImage("assets/images/flwr.png"),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             Column(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Column(
// //                   children: [
// //                     Container(
// //                       height: 500.h,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         border: Border.all(color: Colors.white, width: 10.h),
// //                         borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(6.r),
// //                           topRight: Radius.circular(6.r),
// //                           bottomLeft: Radius.circular(113.r),
// //                           bottomRight: Radius.circular(113.r),
// //                         ),
// //                         image: DecorationImage(
// //                           fit: BoxFit.cover,
// //                           image: AssetImage("assets/images/diety.jpg"),
// //                         ),
// //                       ),
// //                     ),
// //                     10.verticalSpace,
// //                     Container(
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(45.r),
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Column(
// //                             children: [
// //                               //old id 64 font size
// //                               Text(
// //                                 "Sree Kadampuzha Bhagavathy Temple",
// //                                 style: Fontpalette.brown70700,
// //                               ),
// //                               Text(
// //                                 "Melmuri, Kadampuzha, Kerala",
// //                                 style: Fontpalette.grey45600,
// //                               ),
// //                             ],
// //                           ).verticalPadding(30.h).horizontalPadding(40.w),
// //                         ],
// //                       ),
// //                     ),
// //                     60.verticalSpace,

// //                     Text("Choose your language", style: Fontpalette.brown45600),
// //                     15.verticalSpace,
// //                     Stack(
// //                       children: [
// //                         Positioned(
// //                           top: 42.h,
// //                           right: 0,
// //                           child: Transform(
// //                             alignment: Alignment.center,
// //                             transform:
// //                                 Matrix4.identity()..scale(
// //                                   -1.0,
// //                                   1.0,
// //                                   1.0,
// //                                 ), // Mirror horizontally
// //                             child: Container(
// //                               height: 50.h,
// //                               width: 220.w,
// //                               decoration: BoxDecoration(
// //                                 image: DecorationImage(
// //                                   fit: BoxFit.contain,
// //                                   image: AssetImage(
// //                                     "assets/images/sideflwr.png",
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         Positioned(
// //                           top: 42.h,
// //                           left: 0,
// //                           child: Container(
// //                             height: 50.h,
// //                             width: 220.w,
// //                             decoration: BoxDecoration(
// //                               image: DecorationImage(
// //                                 fit: BoxFit.contain,
// //                                 image: AssetImage("assets/images/sideflwr.png"),
// //                               ),
// //                             ),
// //                           ),
// //                         ),

// //                         Column(
// //                           children: [
// //                             Row(
// //                               children: [
// //                                 Expanded(
// //                                   child: InkWell(
// //                                     onTap:
// //                                         () => navigatescrren(
// //                                           page: LanguageSelectedScreen(
// //                                             lanid: 1,
// //                                           ),
// //                                           context: context,
// //                                         ),

// //                                     child: Container(
// //                                       decoration: BoxDecoration(
// //                                         color: HexColor("#EC5002"),
// //                                         borderRadius: BorderRadius.circular(
// //                                           27.r,
// //                                         ),
// //                                         border: Border.all(
// //                                           color: HexColor("#F8A300"),
// //                                           width: 4.h,
// //                                         ),
// //                                       ),
// //                                       height: 60.h,
// //                                       child: Center(
// //                                         child: Text(
// //                                           "English",
// //                                           style: Fontpalette.white45500,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 50.horizontalSpace,
// //                                 Expanded(
// //                                   child: InkWell(
// //                                     onTap:
// //                                         () => navigatescrren(
// //                                           page: LanguageSelectedScreen(
// //                                             lanid: 0,
// //                                           ),
// //                                           context: context,
// //                                         ),

// //                                     child: Container(
// //                                       height: 60.h,
// //                                       decoration: BoxDecoration(
// //                                         color: HexColor("#EC5002"),
// //                                         borderRadius: BorderRadius.circular(
// //                                           27.r,
// //                                         ),
// //                                         border: Border.all(
// //                                           color: HexColor("#F8A300"),
// //                                           width: 4.h,
// //                                         ),
// //                                       ),
// //                                       child: Center(
// //                                         child: Text(
// //                                           "മലയാളം",
// //                                           style: Fontpalette.white45500,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),

// //                             7.verticalSpace,
// //                             Container(
// //                               height: 1,
// //                               decoration: BoxDecoration(
// //                                 gradient: LinearGradient(
// //                                   colors: [
// //                                     Colors.white,
// //                                     HexColor("#EC5002"),
// //                                     Colors.white,
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                             30.verticalSpace,
// //                           ],
// //                         ).horizontalPadding(200.w),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 Column(
// //                   children: [
// //                     InkWell(
// //                       onTap: () {
// //                         SharedPreferenceHelper.clearWholeData();
// //                         Navigator.pushAndRemoveUntil(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const LoginScreen(),
// //                           ),
// //                           (route) => false,
// //                         );
// //                       },
// //                       child: Container(
// //                         padding: EdgeInsets.symmetric(
// //                           horizontal: 24.w,
// //                           vertical: 10.h,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: HexColor("#EC5002"),
// //                           borderRadius: BorderRadius.circular(27.r),
// //                           border: Border.all(
// //                             color: HexColor("#F8A300"),
// //                             width: 4.h,
// //                           ),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black26,
// //                               blurRadius: 8,
// //                               offset: Offset(0, 3),
// //                             ),
// //                           ],
// //                         ),
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Icon(
// //                               Icons.logout,
// //                               color: Colors.white,
// //                               size: 40.w,
// //                             ),
// //                             10.horizontalSpace,
// //                             Text("Logout", style: Fontpalette.white45500),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     15.verticalSpace,
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         InkWell(
// //                           onLongPress: () {
// //                             SharedPreferenceHelper.clearWholeData();
// //                             Navigator.pushAndRemoveUntil(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => const LoginScreen(),
// //                               ),
// //                               (route) => false,
// //                             );
// //                           },
// //                           child: Container(
// //                             height: 107.h,
// //                             width: 500.w,
// //                             decoration: BoxDecoration(
// //                               image: DecorationImage(
// //                                 fit: BoxFit.contain,
// //                                 image: AssetImage(
// //                                   "assets/images/logowithname.png",
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         Text(
// //                           "www.punnyamtemplesuite.com",
// //                           style: Fontpalette.brown30600,
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ).horizontalPadding(100.w),
// //               ],
// //             ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // navigatescrren({BuildContext? context, required page}) {
// //   Navigator.of(context!).push(
// //     PageRouteBuilder(
// //       transitionDuration: Duration(milliseconds: 500),
// //       pageBuilder: (context, animation, secondaryAnimation) => page,
// //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //         return FadeTransition(opacity: animation, child: child);
// //       },
// //     ),
// //   );
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/services/helpers.dart';
// import 'package:kiosk/services/shared_preference_helper.dart';
// import 'package:kiosk/view/bill_screen.dart';
// import 'package:kiosk/view/bookpooja.dart';
// import 'package:kiosk/view/loginscreen.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const Color kBevcoRed = Color(0xFFE53238);
// const Color kBevcoRedLight = Color(0xFFFF5A5F);
// const Color kBevcoDark = Color(0xFF14161A);
// const Color kBevcoInk = Color(0xFF23262B);

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     getCounterID();
//     super.initState();
//   }

//   getCounterID() async {
//     String id = await SharedPreferenceHelper.getCounterID();
//     if (id == '') {
//       _showCounters();
//     }
//   }

//   String? _chosenValue;
//   String? selectedCounterID;

//   void _showCounters() {
//     Future.microtask(() {
//       context.read<HomeProvider>().getCounter().then((value) {
//         showDialog<bool>(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 return PopScope(
//                   canPop: false,
//                   child: Consumer<HomeProvider>(
//                     builder: (context, provider, _) {
//                       return AlertDialog(
//                         title: Text(
//                           "Choose Counter",
//                           style: Fontpalette.blackinter45400,
//                         ),
//                         content: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               "Please select a counter.",
//                               style: Fontpalette.blackinter40400,
//                             ),
//                             SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: DropdownButton<String>(
//                                 hint: Text(
//                                   'Select',
//                                   style: Fontpalette.blackinter28400,
//                                 ),
//                                 value: _chosenValue,
//                                 underline: Container(),
//                                 items:
//                                     provider.counterName.map((String value) {
//                                       return DropdownMenuItem<String>(
//                                         value: value,
//                                         child: Text(
//                                           value,
//                                           style: Fontpalette.blackinter30600,
//                                         ),
//                                       );
//                                     }).toList(),
//                                 onChanged: (value) async {
//                                   final SharedPreferences prefs =
//                                       await SharedPreferences.getInstance();

//                                   setState(() {
//                                     _chosenValue = value;
//                                     for (
//                                       int i = 0;
//                                       i < provider.counterName.length;
//                                       i++
//                                     ) {
//                                       if (provider.counterName[i] ==
//                                           _chosenValue) {
//                                         selectedCounterID =
//                                             provider.counterId[i];

//                                         prefs.setString(
//                                           "counterid",
//                                           selectedCounterID.toString(),
//                                         );
//                                       }
//                                     }
//                                   });
//                                 },
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 TextButton(
//                                   child: Text(
//                                     "SAVE",
//                                     style: Fontpalette.blackinter42700,
//                                   ),
//                                   onPressed: () async {
//                                     if ((selectedCounterID != null)) {
//                                       await SharedPreferenceHelper.saveCounterID(
//                                         selectedCounterID ?? "",
//                                       ).then((value) async {
//                                         Navigator.of(context).pop();
//                                       });
//                                     } else {
//                                       Helpers.successToast(
//                                         "Should Select Counter",
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       });
//     });
//   }

//   void _logout() {
//     SharedPreferenceHelper.clearWholeData();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   void _onCustomTap() {
//     navigatescrren(
//       context: context,
//       page: Bookpoojascreen(lanid: 1),
//     );
//   }

//   void _onScanTap() {
//     navigatescrren(
//       context: context,
//       page: BillScreen()
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBevcoDark,
//       body: Stack(
//         children: [
//           // red glow behind the logo
//           Positioned(
//             top: 40.h,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 height: 700.h,
//                 width: 700.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       kBevcoRed.withOpacity(0.45),
//                       kBevcoRed.withOpacity(0.0),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // faint decorative icons
//           Positioned(
//             top: 120.h,
//             left: 90.w,
//             child: _bgIcon(Icons.local_drink_rounded, 90.w),
//           ),
//           Positioned(
//             top: 220.h,
//             right: 100.w,
//             child: _bgIcon(Icons.sports_bar_rounded, 100.w),
//           ),
//           Positioned(
//             top: 520.h,
//             left: 150.w,
//             child: _bgIcon(Icons.wine_bar_rounded, 80.w),
//           ),
//           Positioned(
//             top: 560.h,
//             right: 170.w,
//             child: _bgIcon(Icons.local_bar_rounded, 84.w),
//           ),
//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: IntrinsicHeight(
//                       child: Column(
//                         children: [
//                           60.verticalSpace,
//                           _buildLogo(),
//                           70.verticalSpace,
//                           Text(
//                             "Choose your choice",
//                             style: TextStyle(
//                               fontSize: 54.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           14.verticalSpace,
//                           Container(
//                             height: 5.h,
//                             width: 100.w,
//                             decoration: BoxDecoration(
//                               color: kBevcoRed,
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                           ),
//                           56.verticalSpace,
//                           Row(
//                             children: [
//                               _rowButton(
//                                 label: "Custom",
//                                 icon: Icons.tune_rounded,
//                                 primary: true,
//                                 onTap: _onCustomTap,
//                               ),
//                               30.horizontalSpace,
//                               _rowButton(
//                                 label: "Scan",
//                                 icon: Icons.qr_code_scanner_rounded,
//                                 onTap: _onScanTap,
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           30.verticalSpace,
//                           _buildBottom(),
//                         ],
//                       ).horizontalPadding(120.w),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLogo() {
//     return Column(
//       children: [
//         Container(
//           height: 300.h,
//           width: 300.h,
//           padding: EdgeInsets.all(10.h),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: kBevcoRedLight, width: 6.h),
//             boxShadow: [
//               BoxShadow(
//                 color: kBevcoRed.withOpacity(0.5),
//                 blurRadius: 50,
//                 spreadRadius: 4,
//               ),
//             ],
//           ),
//           child: Container(
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.all(14.h),
//             child: ClipOval(
//               child: Image.asset(
//                 "assets/images/bevco_logo.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//         26.verticalSpace,
//         Text(
//           "KSBC",
//           style: TextStyle(
//             fontSize: 70.sp,
//             fontWeight: FontWeight.w900,
//             color: Colors.white,
//             letterSpacing: 10,
//           ),
//         ),
//         6.verticalSpace,
//         Text(
//           "Kerala State Beverages (M&M) Corporation Ltd.",
//           style: TextStyle(
//             fontSize: 30.sp,
//             fontWeight: FontWeight.w500,
//             color: Colors.white.withOpacity(0.7),
//           ),
//         ),
//         6.verticalSpace,
//         Text(
//           "A Govt. of Kerala Undertaking",
//           style: TextStyle(
//             fontSize: 30.sp,
//             fontWeight: FontWeight.w500,
//             color: Colors.white.withOpacity(0.7),
//           )
//         ),
//       ],
//     );
//   }

//   Widget _bgIcon(IconData icon, double size) {
//     return Icon(icon, size: size, color: Colors.white.withOpacity(0.06));
//   }

//   // Silver metallic gradient shared by all buttons
//   LinearGradient get _silverGradient => const LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       Color(0xFFFAFAFB),
//       Color(0xFFD5D8DC),
//       Color(0xFFB4B9BF),
//       Color(0xFFE3E5E8),
//     ],
//     stops: [0.0, 0.45, 0.55, 1.0],
//   );

// Widget _rowButton({
//   required String label,
//   required IconData icon,
//   required VoidCallback onTap,
//   bool primary = false,
// }) {
//   final BorderRadius radius = BorderRadius.circular(24.r);

//   return Expanded(
//     child: Material(
//       color: primary ? kBevcoRed : Colors.transparent,
//       borderRadius: radius,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: radius,
//         splashColor: Colors.white.withOpacity(0.15),
//         child: Container(
//           height: 180.h,
//           decoration: BoxDecoration(
//             borderRadius: radius,
//             border: primary ? null : Border.all(color: kBevcoRed, width: 3),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 80.w, color: Colors.white),
//               18.verticalSpace,
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 42.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

//   Widget _buildBottom() {
//     return Column(
//       children: [
//         Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: _logout,
//             borderRadius: BorderRadius.circular(100.r),
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
//               decoration: BoxDecoration(
//                 gradient: _silverGradient,
//                 borderRadius: BorderRadius.circular(100.r),
//                 border: Border.all(color: Colors.white, width: 2),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     blurRadius: 14,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.logout_rounded, color: kBevcoRed, size: 36.w),
//                   12.horizontalSpace,
//                   Text(
//                     "LOGOUT",
//                     style: TextStyle(
//                       fontSize: 30.sp,
//                       fontWeight: FontWeight.w800,
//                       color: kBevcoInk,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         20.verticalSpace,
//         GestureDetector(
//           onLongPress: _logout,
//           child: Text(
//             "BEVCO • Beverage Kiosk",
//             style: TextStyle(
//               fontSize: 24.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.white.withOpacity(0.4),
//               letterSpacing: 1,
//             ),
//           ),
//         ),
//         24.verticalSpace,
//       ],
//     );
//   }
// }

// navigatescrren({BuildContext? context, required page}) {
//   Navigator.of(context!).push(
//     PageRouteBuilder(
//       transitionDuration: const Duration(milliseconds: 500),
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(opacity: animation, child: child);
//       },
//     ),
//   );
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/extension.dart';
import 'package:kiosk/fontpallate.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/services/shared_preference_helper.dart';
import 'package:kiosk/view/bill_screen.dart';
import 'package:kiosk/view/loginscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBevcoRed = Color(0xFFE53238);
const Color kBevcoRedLight = Color(0xFFFF5A5F);
const Color kBevcoDark = Color(0xFF14161A);
const Color kBevcoInk = Color(0xFF23262B);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrowController;

  @override
  void initState() {
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    getCounterID();
    super.initState();
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  getCounterID() async {
    String id = await SharedPreferenceHelper.getCounterID();
    if (id == '') {
      _showCounters();
    }
  }

  String? _chosenValue;
  String? selectedCounterID;

  // void _showCounters() {
  //   Future.microtask(() {
  //     context.read<HomeProvider>().getCounter().then((value) {
  //       showDialog<bool>(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //               return PopScope(
  //                 canPop: false,
  //                 child: Consumer<HomeProvider>(
  //                   builder: (context, provider, _) {
  //                     return AlertDialog(
  //                       title: Text(
  //                         "Choose Counter",
  //                         style: Fontpalette.blackinter45400,
  //                       ),
  //                       content: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Text(
  //                             "Please select a counter.",
  //                             style: Fontpalette.blackinter40400,
  //                           ),
  //                           SingleChildScrollView(
  //                             scrollDirection: Axis.horizontal,
  //                             child: DropdownButton<String>(
  //                               hint: Text(
  //                                 'Select',
  //                                 style: Fontpalette.blackinter28400,
  //                               ),
  //                               value: _chosenValue,
  //                               underline: Container(),
  //                               items:
  //                                   provider.counterName.map((String value) {
  //                                     return DropdownMenuItem<String>(
  //                                       value: value,
  //                                       child: Text(
  //                                         value,
  //                                         style: Fontpalette.blackinter30600,
  //                                       ),
  //                                     );
  //                                   }).toList(),
  //                               onChanged: (value) async {
  //                                 final SharedPreferences prefs =
  //                                     await SharedPreferences.getInstance();

  //                                 setState(() {
  //                                   _chosenValue = value;
  //                                   for (
  //                                     int i = 0;
  //                                     i < provider.counterName.length;
  //                                     i++
  //                                   ) {
  //                                     if (provider.counterName[i] ==
  //                                         _chosenValue) {
  //                                       selectedCounterID =
  //                                           provider.counterId[i];

  //                                       prefs.setString(
  //                                         "counterid",
  //                                         selectedCounterID.toString(),
  //                                       );
  //                                     }
  //                                   }
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             children: [
  //                               TextButton(
  //                                 child: Text(
  //                                   "SAVE",
  //                                   style: Fontpalette.blackinter42700,
  //                                 ),
  //                                 onPressed: () async {
  //                                   if ((selectedCounterID != null)) {
  //                                     await SharedPreferenceHelper.saveCounterID(
  //                                       selectedCounterID ?? "",
  //                                     ).then((value) async {
  //                                       Navigator.of(context).pop();
  //                                     });
  //                                   } else {
  //                                     Helpers.successToast(
  //                                       "Should Select Counter",
  //                                     );
  //                                   }
  //                                 },
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     });
  //   });
  // }

  void _showCounters() {
    Future.microtask(() async {
      if (!mounted) return;

      final provider = context.read<HomeProvider>();

      // Fetch counters from API first
      await provider.getCounter();

      if (!mounted) return;

      debugPrint("Counter Names: ${provider.counterName}");
      debugPrint("Counter IDs: ${provider.counterId}");

      if (provider.counterName.isEmpty) {
        Helpers.successToast("No counters available");
        return;
      }

      // Reset selection
      _chosenValue = null;
      selectedCounterID = null;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: Text(
                    "Choose Counter",
                    style: Fontpalette.blackinter45400,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please select a counter.",
                        style: Fontpalette.blackinter40400,
                      ),
                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _chosenValue,
                        hint: Text(
                          "Select Counter",
                          style: Fontpalette.blackinter28400,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: List.generate(provider.counterName.length, (
                          index,
                        ) {
                          return DropdownMenuItem<String>(
                            value: provider.counterName[index],
                            child: Text(
                              provider.counterName[index],
                              style: Fontpalette.blackinter30600,
                            ),
                          );
                        }),
                        onChanged: (value) {
                          setDialogState(() {
                            _chosenValue = value;

                            final index = provider.counterName.indexOf(value!);

                            if (index != -1) {
                              selectedCounterID = provider.counterId[index];
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (selectedCounterID == null) {
                                Helpers.successToast("Please select a counter");
                                return;
                              }

                              await SharedPreferenceHelper.saveCounterID(
                                selectedCounterID!,
                              );

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }

                              debugPrint(
                                "Selected Counter ID: $selectedCounterID",
                              );
                            },
                            child: Text(
                              "SAVE",
                              style: Fontpalette.blackinter42700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  void _logout() {
    SharedPreferenceHelper.clearWholeData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onScanTap() {
    navigatescrren(context: context, page: BillScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBevcoDark,
      body: Stack(
        children: [
          // red glow behind the logo
          Positioned(
            top: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 700.h,
                width: 700.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      kBevcoRed.withOpacity(0.45),
                      kBevcoRed.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // faint decorative icons
          Positioned(
            top: 120.h,
            left: 90.w,
            child: _bgIcon(Icons.local_drink_rounded, 90.w),
          ),
          Positioned(
            top: 220.h,
            right: 100.w,
            child: _bgIcon(Icons.sports_bar_rounded, 100.w),
          ),
          Positioned(
            top: 520.h,
            left: 150.w,
            child: _bgIcon(Icons.wine_bar_rounded, 80.w),
          ),
          Positioned(
            top: 560.h,
            right: 170.w,
            child: _bgIcon(Icons.local_bar_rounded, 84.w),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          60.verticalSpace,
                          _buildLogo(),
                          70.verticalSpace,
                          // Text(
                          //   "Choose your choice",
                          //   style: TextStyle(
                          //     fontSize: 54.sp,
                          //     fontWeight: FontWeight.w700,
                          //     color: Colors.white,
                          //     letterSpacing: 0.5,
                          //   ),
                          // ),
                          14.verticalSpace,
                          Container(
                            height: 5.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: kBevcoRed,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          56.verticalSpace,
                          _scanHint(),
                          16.verticalSpace,
                          _scanButton(),
                          const Spacer(),
                          30.verticalSpace,
                          //_buildBottom(),
                        ],
                      ).horizontalPadding(120.w),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          height: 300.h,
          width: 300.h,
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kBevcoRedLight, width: 6.h),
            boxShadow: [
              BoxShadow(
                color: kBevcoRed.withOpacity(0.5),
                blurRadius: 50,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(14.h),
            child: ClipOval(
              child: Image.asset(
                "assets/images/bevco_logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        26.verticalSpace,
        Text(
          "KSBC",
          style: TextStyle(
            fontSize: 70.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 10,
          ),
        ),
        6.verticalSpace,
        Text(
          "Kerala State Beverages (M&M) Corporation Ltd.",
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        6.verticalSpace,
        Text(
          "A Govt. of Kerala Undertaking",
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _bgIcon(IconData icon, double size) {
    return Icon(icon, size: size, color: Colors.white.withOpacity(0.06));
  }

  // Bouncing arrow pointing down at the Scan button
  Widget _scanHint() {
    return AnimatedBuilder(
      animation: _arrowController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 14.h * _arrowController.value),
          child: child,
        );
      },
      child: Icon(
        Icons.keyboard_double_arrow_down_rounded,
        size: 70.w,
        color: kBevcoRedLight,
      ),
    );
  }

  // Black button with red border, Malayalam text inside
  Widget _scanButton() {
    final BorderRadius radius = BorderRadius.circular(24.r);

    return Material(
      color: Colors.black,
      borderRadius: radius,
      child: InkWell(
        onTap: _onScanTap,
        borderRadius: radius,
        splashColor: kBevcoRed.withOpacity(0.25),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 24.w),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: kBevcoRed, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.qr_code_scanner_rounded,
                size: 90.w,
                color: Colors.white,
              ),
              18.verticalSpace,
              Text(
                "സ്കാൻ ചെയ്യുന്നതിനായി ഇവിടെ അമർത്തുക\n(Tap here to scan.)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Silver metallic gradient used by the logout button
  LinearGradient get _silverGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAFAFB),
      Color(0xFFD5D8DC),
      Color(0xFFB4B9BF),
      Color(0xFFE3E5E8),
    ],
    stops: [0.0, 0.45, 0.55, 1.0],
  );

  Widget _buildBottom() {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _logout,
            borderRadius: BorderRadius.circular(100.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: _silverGradient,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_rounded, color: kBevcoRed, size: 36.w),
                  12.horizontalSpace,
                  Text(
                    "LOGOUT",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      color: kBevcoInk,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        20.verticalSpace,
        GestureDetector(
          onLongPress: _logout,
          child: Text(
            "BEVCO • Beverage Kiosk",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 1,
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}

navigatescrren({BuildContext? context, required page}) {
  Navigator.of(context!).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
