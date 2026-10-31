// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:kiosk/color_pallatte.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/services/helpers.dart';
// import 'package:kiosk/services/provider_helper_class.dart';
// import 'package:kiosk/view/billpreview.dart';
// import 'package:kiosk/view/homepage.dart';
// import 'package:provider/provider.dart';

// class Bookpoojascreen extends StatefulWidget {
//   const Bookpoojascreen({super.key, this.lanid, this.isDonate = false});
//   final int? lanid;
//   final bool isDonate;
//   @override
//   State<Bookpoojascreen> createState() => _BookpoojascreenState();
// }

// class _BookpoojascreenState extends State<Bookpoojascreen> {
//   TextEditingController name = TextEditingController();
//   TextEditingController amt = TextEditingController();
//   DateTime? selectedDate;

//   // Live English-to-Malayalam transliteration for the Name field.
//   // _romanName tracks what the user actually typed (Latin letters); the
//   // visible `name` field is replaced with the transliterated Malayalam
//   // once they pause typing, only when the Malayalam language is selected.
//   String _romanName = '';
//   int _lastNameFieldLength = 0;
//   bool _isProgrammaticNameUpdate = false;
//   Timer? _transliterateDebounce;

//   void _resetNameTransliterationState() {
//     _romanName = '';
//     _lastNameFieldLength = 0;
//     _transliterateDebounce?.cancel();
//   }

//   void _onNameChanged(String value) {
//     if (_isProgrammaticNameUpdate) {
//       _isProgrammaticNameUpdate = false;
//       _lastNameFieldLength = value.length;
//       return;
//     }

//     if (widget.lanid == 1) {
//       // English selected — type as-is, no transliteration.
//       _lastNameFieldLength = value.length;
//       return;
//     }

//     // Mirror this edit onto the roman (Latin) buffer.
//     final delta = value.length - _lastNameFieldLength;
//     if (delta > 0) {
//       _romanName += value.substring(value.length - delta);
//     } else if (delta < 0) {
//       final removeCount = -delta;
//       _romanName = _romanName.length >= removeCount
//           ? _romanName.substring(0, _romanName.length - removeCount)
//           : '';
//     }
//     _lastNameFieldLength = value.length;

//     _transliterateDebounce?.cancel();
//     if (_romanName.trim().isEmpty) return;
//     _transliterateDebounce = Timer(
//       const Duration(milliseconds: 1500),
//       _transliterateName,
//     );
//   }

//   Future<void> _transliterateName() async {
//     final source = _romanName;
//     if (source.trim().isEmpty) return;
//     try {
//       final uri = Uri.parse(
//         'https://inputtools.google.com/request?text=${Uri.encodeComponent(source)}'
//         '&itc=ml-t-i0-und&num=1&cp=0&cs=1&ie=utf-8&oe=utf-8',
//       );
//       final response = await http.get(uri);
//       if (response.statusCode != 200) return;
//       final decoded = jsonDecode(response.body);
//       if (decoded is! List || decoded.isEmpty || decoded[0] != 'SUCCESS') {
//         return;
//       }
//       final results = decoded[1] as List;
//       if (results.isEmpty) return;
//       final suggestions = results[0][1] as List;
//       if (suggestions.isEmpty) return;
//       final malayalam = suggestions[0] as String;

//       if (!mounted || source != _romanName) return;
//       _isProgrammaticNameUpdate = true;
//       name.value = TextEditingValue(
//         text: malayalam,
//         selection: TextSelection.collapsed(offset: malayalam.length),
//       );
//       _lastNameFieldLength = malayalam.length;
//     } catch (e) {
//       debugPrint('Transliteration error: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _transliterateDebounce?.cancel();
//     super.dispose();
//   }

//   Future<void> pickDate() async {
//     final home = context.read<HomeProvider>();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != selectedDate) {
//       home.updateSelectedDate(date: picked);
//     }
//   }

//   final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);


//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final home = context.read<HomeProvider>();
//       if (widget.isDonate) {
//         //home.updateDietyId(id: null, name: "DONATION");
//         home.updateDietyId(id: 8, name: "DONATION");
//         // Pull the Malayalam label straight from the deities API (name_mal for
//         // id 8) instead of a hand-maintained translation, with the previous
//         // hardcoded guess kept only as a fallback if that data isn't loaded yet.
//         final donationDeities =
//             home.deitiesResponse?.data?.where((d) => d.id == 8).toList() ?? [];
//         final donationNameMal =
//             donationDeities.isNotEmpty ? donationDeities.first.nameMal : null;
//         home.updateSelextedPoojaId(
//           poojaname: widget.lanid == 1 ? "DONATION" : (donationNameMal ?? "ദാനം"),
//           poojaid: 29,
//           rate: null,
//         );

//       } else {
//         if (home.deitiesResponse?.data != null && home.deitiesResponse!.data!.isNotEmpty) {
//           final firstDeity = home.deitiesResponse!.data!.first;
//           home.updateDietyId(
//             id: firstDeity.id,
//             name: widget.lanid == 1 ? firstDeity.name : firstDeity.nameMal,
//           );
//           home.updateSelextedPoojaId(poojaid: null, poojaname: null, rate: null);
//         }
//       }
//     });
//   }

//   // Resolves the diety text saved with a pooja entry. For a normal deity
//   // selection this is already correctly localized by updateDietyId(); for
//   // Donation (an internal "DONATION" sentinel, kept in English so the many
//   // == "DONATION" checks elsewhere keep working) this looks up the real
//   // Malayalam label from the deities API (id 8) instead of a guessed one.
//   String? _dietyDisplayName(HomeProvider home) {
//     if (home.dietyIName != "DONATION") return home.dietyIName;
//     if (widget.lanid == 1) return "DONATION";
//     final donationDeities =
//         home.deitiesResponse?.data?.where((d) => d.id == 8).toList() ?? [];
//     return donationDeities.isNotEmpty
//         ? (donationDeities.first.nameMal ?? "ദാനം")
//         : "ദാനം";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: AlignmentDirectional.topCenter,
//             end: AlignmentDirectional.bottomCenter,
//             colors: [
//               const Color.fromARGB(255, 243, 233, 98),
//               const Color.fromARGB(255, 244, 245, 199),
//               Colors.white,
//               Colors.white,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -30.h,
//               right: -150.w,
//               child: Container(
//                 height: 220.h,
//                 width: 702.w,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage("assets/images/flwr.png"),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -45.h,
//               left: -250.w,
//               child: Container(
//                 height: 220.h,
//                 width: 702.w,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage("assets/images/flwr.png"),
//                   ),
//                 ),
//               ),
//             ),

//             Consumer<HomeProvider>(
//               builder: (context, home, child) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           25.verticalSpace,
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(45.r),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Sree Kadampuzha Bhagavathy Temple",
//                                       style: Fontpalette.brown65700,
//                                     ),
//                                     Text(
//                                       "Melmuri, Kadampuzha, Kerala",
//                                       style: Fontpalette.grey45600,
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   height: 80.h,
//                                   width: 200.w,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       fit: BoxFit.contain,
//                                       image: AssetImage(
//                                         "assets/images/poojabookingimg.png",
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ).horizontalPadding(60.w).verticalPadding(15.h),
//                           ),
//                           20.verticalSpace,
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(45.r),
//                                 color: Colors.white,
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Name",
//                                               style:
//                                                   Fontpalette.blackinter40400,
//                                             ),
//                                             5.verticalSpace,
//                                             Container(
//                                               height: 50.h,

//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(21.r),
//                                                 border: Border.all(
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               child: TextField(
//                                                 controller: name,
//                                                 //onChanged: _onNameChanged,
//                                                 style:
//                                                     Fontpalette.blackinter45400,
//                                                 textAlignVertical:
//                                                     TextAlignVertical.center,
//                                                 decoration: InputDecoration(
//                                                   isDense: true,
//                                                   contentPadding:
//                                                       EdgeInsets.symmetric(
//                                                         vertical: 15.h,
//                                                         horizontal: 40.w,
//                                                       ),

//                                                   hintText: " ",
//                                                   hintStyle:
//                                                       Fontpalette
//                                                           .blackinter24400,
//                                                   border: InputBorder.none,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       30.horizontalSpace,
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Choose date",
//                                             style: Fontpalette.blackinter40400,
//                                           ),
//                                           5.verticalSpace,
//                                           InkWell(
//                                             onTap: () => pickDate(),
//                                             child: Container(
//                                               height: 50.h,
//                                               width: 500.w,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(21.r),
//                                                 border: Border.all(
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     home.selecteddate ?? '',
//                                                     style:
//                                                         Fontpalette
//                                                             .blackinter45400,
//                                                   ).horizontalPadding(40.w),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   10.verticalSpace,
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Select star",
//                                         style: Fontpalette.blackinter40400,
//                                       ),
//                                     ],
//                                   ),
//                                   5.verticalSpace,
//                                   SizedBox(
//                                     height: 35.h,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount:
//                                           home.starsResponse?.data?.length ?? 0,
//                                       itemBuilder: (context, index) {
//                                         return Padding(
//                                           padding: EdgeInsets.only(right: 15.w),
//                                           child: InkWell(
//                                             onTap: () {
//                                               FocusScope.of(context).unfocus();
//                                               home.updateSelextedStarId(
//                                                 starid:
//                                                     home
//                                                         .starsResponse
//                                                         ?.data![index]
//                                                         .id,
//                                                 starname: widget.lanid == 1
//                                                     ? home
//                                                         .starsResponse
//                                                         ?.data![index]
//                                                         .nameEng
//                                                     : home
//                                                         .starsResponse
//                                                         ?.data![index]
//                                                         .nameMal,
//                                               );
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12.r),
//                                                 color:
//                                                     home.selectedStarId ==
//                                                             home
//                                                                 .starsResponse
//                                                                 ?.data![index]
//                                                                 .id
//                                                         ? Colors.black
//                                                             .withOpacity(0.5)
//                                                         : Colors.white,
//                                                 border: Border.all(
//                                                   color: HexColor("#D2D2D2"),
//                                                 ),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   widget.lanid == 1
//                                                       ? "${home.starsResponse?.data![index].nameEng}"
//                                                       : "${home.starsResponse?.data![index].nameMal}",
//                                                   style:
//                                                       home.selectedStarId !=
//                                                               home
//                                                                   .starsResponse
//                                                                   ?.data![index]
//                                                                   .id
//                                                           ? Fontpalette
//                                                               .black52700
//                                                           : Fontpalette
//                                                               .white52700,
//                                                 ).horizontalPadding(30.w),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   if (!widget.isDonate) ...[
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Select diety",
//                                           style: Fontpalette.blackinter40400,
//                                         ),
//                                       ],
//                                     ),
//                                     5.verticalSpace,
//                                     Builder(
//                                       builder: (context) {
//                                         final filteredDeities = (home.deitiesResponse?.data ?? [])
//                                             .where((d) => d.name?.toUpperCase() != "DONATION")
//                                             .toList();
//                                         return SizedBox(
//                                           height: 65.h,
//                                           child: ListView.builder(
//                                             scrollDirection: Axis.horizontal,
//                                             itemCount: filteredDeities.length,
//                                             itemBuilder: (context, index) {
//                                               final deity = filteredDeities[index];
//                                               return Padding(
//                                                 padding: EdgeInsets.only(right: 30.w),
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     FocusScope.of(context).unfocus();
//                                                     home.updateDietyId(
//                                                       id: deity.id,
//                                                       name: widget.lanid == 1
//                                                           ? deity.name
//                                                           : deity.nameMal,
//                                                     );
//                                                   },
//                                                   child: Column(
//                                                     children: [
//                                                       Expanded(
//                                                         child: Stack(
//                                                           children: [
//                                                             Container(
//                                                               width: 200.w,
//                                                               decoration: BoxDecoration(
//                                                                 color: Colors.black,
//                                                                 borderRadius:
//                                                                     BorderRadius.circular(27.r),
//                                                                 image: DecorationImage(
//                                                                   image: AssetImage(
//                                                                     "assets/images/pooja.png",
//                                                                   ),
//                                                                   fit: BoxFit.cover,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             if (home.dietyId == deity.id)
//                                                               Container(
//                                                                 width: 200.w,
//                                                                 decoration: BoxDecoration(
//                                                                   color: Colors.black
//                                                                       .withOpacity(0.5),
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(27.r),
//                                                                 ),
//                                                               ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       5.verticalSpace,
//                                                       Text(
//                                                         widget.lanid == 1
//                                                             ? "${deity.name}"
//                                                             : "${deity.nameMal}",
//                                                         style: Fontpalette.black45600,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                   10.verticalSpace,
//                                   home.dietyIName == "DONATION"
//                                       ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Amount",
//                                             style: Fontpalette.blackinter40400,
//                                           ),
//                                           5.verticalSpace,
//                                           Container(
//                                             height: 50.h,

//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(21.r),
//                                               border: Border.all(
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             child: 
//                                             // TextField(
//                                             //   keyboardType:
//                                             //       TextInputType.numberWithOptions(decimal: true),
//                                             //   controller: amt,
//                                             //   style:
//                                             //       Fontpalette.blackinter45400,
//                                             //   textAlignVertical:
//                                             //       TextAlignVertical.center,
//                                             //   decoration: InputDecoration(
//                                             //     isDense: true,
//                                             //     contentPadding:
//                                             //         EdgeInsets.symmetric(
//                                             //           vertical: 15.h,
//                                             //           horizontal: 40.w,
//                                             //         ),

//                                             //     hintText: " ",
//                                             //     hintStyle:
//                                             //         Fontpalette.blackinter24400,
//                                             //     border: InputBorder.none,
//                                             //   ),
//                                             // ),

//                                             TextField(
//                                               keyboardType:
//                                                   TextInputType.numberWithOptions(decimal: true),
//                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                                               controller: amt,
//                                               style:
//                                                   Fontpalette.blackinter45400,
//                                               textAlignVertical:
//                                                   TextAlignVertical.center,
//                                               decoration: InputDecoration(
//                                                 isDense: true,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                       vertical: 15.h,
//                                                       horizontal: 40.w,
//                                                     ),

//                                                 hintText: " ",
//                                                 hintStyle:
//                                                     Fontpalette.blackinter24400,
//                                                 border: InputBorder.none,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                       : home.len > 15
//                                       ? SizedBox(
//                                         height: 400.h,
//                                         child: Listpooja(
//                                           len: home.len,
//                                           lanid: widget.lanid,
//                                         ),
//                                       )
//                                       : Listpooja(
//                                         len: home.len,
//                                         lanid: widget.lanid,
//                                       ),
//                                   10.verticalSpace,
//                                   Container(
//                                     height: 2.h,
//                                     color: HexColor("#D97000"),
//                                   ),
//                                   15.verticalSpace,
//                                   if (!widget.isDonate)
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       InkWell(
//                                         onTap: () async {
//                                           if (name.text.isEmpty) {
//                                             Helpers.successToast(
//                                               "Please enter your name",
//                                             );
//                                             return;
//                                           }
//                                           if (home.selectedStarId == null) {
//                                             Helpers.successToast(
//                                               "Please select your star",
//                                             );
//                                             return;
//                                           }
//                                           if (home.selectedPoojaId == null &&
//                                               home.dietyIName != "DONATION") {
//                                             Helpers.successToast(
//                                               "Please a pooja",
//                                             );
//                                             return;
//                                           }
//                                           if (amt.text.isEmpty &&
//                                               home.dietyIName == "DONATION") {
//                                             Helpers.successToast(
//                                               "Please enter the amount",
//                                             );
//                                             return;
//                                           }
//                                           if (home.dietyIName == "DONATION") {
//                                             final enteredAmount =
//                                                 double.tryParse(amt.text);
//                                             if (enteredAmount == null ||
//                                                 enteredAmount <= 0) {
//                                               Helpers.successToast(
//                                                 "Please enter a valid  amount",
//                                               );
//                                               return;
//                                             }
//                                           }
//                                           FocusScope.of(context).unfocus();
//                                           await home.addToPoojaDetails(
//                                             name: name.text,
//                                             star: home.selectedStarrname,
//                                             date: home.dateapi,
//                                             dietyid: home.dietyId,
//                                             diety: _dietyDisplayName(home),

//                                             poojaname: home.selectedPoojaName,
//                                             poojaid: home.selectedPoojaId,

//                                             rate:
//                                                 home.dietyIName == "DONATION"
//                                                     ? amt.text
//                                                     : home.selectedpoojarate,
//                                             starid: home.selectedStarId,
//                                           );
//                                           home.clearStoredData();
//                                           name.clear();
//                                           _resetNameTransliterationState();
//                                           amt.clear();
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             color: HexColor("#FDEFD3"),
//                                             borderRadius: BorderRadius.circular(
//                                               33.r,
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "Add more person",
//                                             style: Fontpalette.blackinter40400,
//                                           ).symmetricPadding(
//                                             vertical: 10.h,
//                                             horizontal: 50.w,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ).horizontalPadding(60.w).verticalPadding(20.h),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [],
//                             ),
//                             ValueListenableBuilder<bool>(
//                               valueListenable: isEnabled,
//                               builder:
//                                   (context, value, child) => InkWell(
//                                     onTap: () async {
//                                       if (widget.isDonate) {
//                                         home.clearGrossAmount();
//                                       }
//                                       if (home.pooja.isEmpty) {
//                                         print("no pooja added");
//                                         if (name.text.isEmpty) {
//                                           Helpers.successToast(
//                                             "Please enter your name",
//                                           );
//                                           return;
//                                         }
//                                         if (home.selectedStarId == null) {
//                                           Helpers.successToast(
//                                             "Please select your star",
//                                           );
//                                           return;
//                                         }
//                                         if (home.selectedPoojaId == null &&
//                                             home.dietyIName != "DONATION") {
//                                           Helpers.successToast(
//                                             "Please a pooja",
//                                           );
//                                           return;
//                                         }
//                                         if (amt.text.isEmpty &&
//                                             home.dietyIName == "DONATION") {
//                                           Helpers.successToast(
//                                             "Please enter the amount",
//                                           );
//                                           return;
//                                         }
//                                         if (home.dietyIName == "DONATION") {
//                                               final enteredAmount =
//                                                   double.tryParse(amt.text);
//                                               if (enteredAmount == null ||
//                                                   enteredAmount <= 0) {
//                                                 Helpers.successToast(
//                                                   "Please enter a valid  amount",
//                                                 );
//                                                 return;
//                                               }
//                                             }
//                                         isEnabled.value = true;
//                                         await home.addToPoojaDetails(
//                                           name: name.text,
//                                           diety: _dietyDisplayName(home),
//                                           star: home.selectedStarrname,

//                                           poojaname: home.selectedPoojaName,
//                                           date: home.dateapi,
//                                           dietyid: home.dietyId,

//                                           poojaid: home.selectedPoojaId,

//                                           rate:
//                                               home.dietyIName == "DONATION"
//                                                   ? amt.text
//                                                   : home.selectedpoojarate,
//                                           starid: home.selectedStarId,
//                                         );

//                                         await home.getPreviewBill(
//                                           onSuccess: () async {
//                                             navigatescrren(
//                                               page: PreviewScreen(),
//                                               context: context,
//                                             );
//                                             home.clearStoredData();
//                                             name.clear();
//                                             _resetNameTransliterationState();
//                                             amt.clear();
//                                             isEnabled.value = false;
//                                           },
//                                           onFailure: () {
//                                             isEnabled.value = false;
//                                           },
//                                         );
//                                       } else {
//                                         print(" pooja added");
//                                         isEnabled.value = true;
//                                         if (name.text.isNotEmpty &&
//                                             home.selectedStarId != null) {
//                                           if (home.selectedPoojaId == null &&
//                                                   home.dietyIName ==
//                                                       "DONATION" ||
//                                               home.selectedPoojaId != null) {
//                                             await home.addToPoojaDetails(
//                                               name: name.text,
//                                               diety: _dietyDisplayName(home),
//                                               star: home.selectedStarrname,

//                                               poojaname: home.selectedPoojaName,
//                                               poojaid: home.selectedPoojaId,
//                                               date: home.dateapi,
//                                               dietyid: home.dietyId,
//                                               rate:
//                                                   home.dietyIName == "DONATION"
//                                                       ? amt.text
//                                                       : home.selectedpoojarate,
//                                               starid: home.selectedStarId,
//                                             );
//                                           }
//                                         }
//                                         await home.getPreviewBill(
//                                           onSuccess: () async {
//                                             navigatescrren(
//                                               page: PreviewScreen(),
//                                               context: context,
//                                             );
//                                             amt.clear();
//                                             home.clearStoredData();
//                                             name.clear();
//                                             _resetNameTransliterationState();
//                                             isEnabled.value = false;
//                                           },
//                                           onFailure: () {
//                                             isEnabled.value = false;
//                                           },
//                                         );
//                                       }
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(
//                                           27.r,
//                                         ),
//                                         color: HexColor("#EC5002"),
//                                       ),
//                                       child:
//                                           isEnabled.value == true
//                                               ? CircularProgressIndicator(
//                                                 color: Colors.white,
//                                               ).horizontalPadding(190.w)
//                                               : Text(
//                                                 "Continue",
//                                                 style: Fontpalette.white50700,
//                                               ).symmetricPadding(
//                                                 vertical: 18.h,
//                                                 horizontal: 150.w,
//                                               ),
//                                     ),
//                                   ),
//                             ),
//                           ],
//                         ),
//                         20.verticalSpace,
//                         Text(
//                           "www.punnyamtemplesuite.com",
//                           style: Fontpalette.brown30600,
//                         ),
//                       ],
//                     ).horizontalPadding(100.w),
//                   ],
//                 ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Listpooja extends StatelessWidget {
//   const Listpooja({super.key, this.len = 0, this.lanid});
//   final int? len;
//   final int? lanid;
//   @override
//   Widget build(BuildContext context) {
//     final ScrollController scrollController =
//         ScrollController(); // Place this in your State class

//     return Consumer<HomeProvider>(
//       builder:
//           (context, home, child) =>
//               home.poojaload == LoaderState.loading
//                   ? SizedBox()
//                   : Scrollbar(
//                     controller: scrollController,
//                     thumbVisibility: true,
//                     child: GridView.count(
//                       controller: scrollController,
//                       crossAxisCount: 3,
//                       childAspectRatio: 400.w / 80.h,
//                       mainAxisSpacing: 10.h,
//                       crossAxisSpacing: 10.w,
//                       shrinkWrap: len! <= 15,
//                       physics:
//                           len! > 15
//                               ? AlwaysScrollableScrollPhysics()
//                               : NeverScrollableScrollPhysics(),
//                       padding: EdgeInsets.all(8.w),
//                       children: List.generate(len ?? 0, (index) {
//                         final item = home.poojaResponse!.data![index];
//                         return InkWell(
//                           onTap: () {
//                             FocusScope.of(context).unfocus();
//                             home.updateSelextedPoojaId(
//                               poojaname: lanid == 1 ? item.name : item.nameMal,
//                               poojaid: item.poojaId,
//                               rate: item.rate,
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color:
//                                   home.selectedPoojaId == item.poojaId
//                                       ? Colors.black.withOpacity(0.5)
//                                       : Colors.white,
//                               border: Border.all(color: HexColor("#D2D2D2")),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               vertical: 8.h,
//                               horizontal: 5.w,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   lanid == 1
//                                       ? item.name ?? ''
//                                       : item.nameMal ?? '',
//                                   textAlign: TextAlign.center,

//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 5,
//                                   style:
//                                       home.selectedPoojaId == item.poojaId
//                                           ? Fontpalette.white45600
//                                           : Fontpalette.black45600,
//                                 ),
//                                 3.verticalSpace,
//                                 Text(
//                                   "₹ ${item.rate}",
//                                   style:
//                                       home.selectedPoojaId == item.poojaId
//                                           ? Fontpalette.white38500
//                                           : Fontpalette.black38500,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/services/provider_helper_class.dart';
import 'package:kiosk/view/billpreview.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:provider/provider.dart';

// One dummy image used for every category and product for now.
const String _dummyImage = "assets/images/pooja.png";

// The backend still expects these fields on each entry, but this screen
// no longer collects them. Change here if the API needs real values.
const String _defaultName = "BEVCO";

class _CartItem {
  _CartItem({
    required this.productId,
    required this.name,
    required this.rate,
    required this.categoryId,
    required this.categoryName,
    this.qty = 1,
  });

  final dynamic productId;
  final String name;
  final dynamic rate;
  final dynamic categoryId;
  final String? categoryName;
  int qty;
}

class Bookpoojascreen extends StatefulWidget {
  const Bookpoojascreen({super.key, this.lanid, this.isDonate = false});
  final int? lanid;
  final bool isDonate; // kept so existing callers don't break (unused now)
  @override
  State<Bookpoojascreen> createState() => _BookpoojascreenState();
}

class _BookpoojascreenState extends State<Bookpoojascreen> {
  static const Color _bg = Colors.white;
  static const Color _card = Color(0xFF2A2A2D);
  static const Color _red = Color(0xFFD71920);
  static const Color _silver = Color(0xFFC8CBD0);

  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);

  // productId -> cart item. Kept locally so products from different
  // categories can be selected together.
  final Map<dynamic, _CartItem> _cart = {};

  bool get _isEnglish => widget.lanid == 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final home = context.read<HomeProvider>();
      final list = _categories(home);
      if (list.isNotEmpty) {
        final first = list.first;
        home.updateDietyId(
          id: first.id,
          name: _isEnglish ? first.name : (first.nameMal ?? first.name),
        );
        home.updateSelextedPoojaId(poojaid: null, poojaname: null, rate: null);
      }
    });
  }

  @override
  void dispose() {
    isEnabled.dispose();
    super.dispose();
  }

  // Same deities API; the old DONATION entry is not a BEVCO category.
  List<dynamic> _categories(HomeProvider home) => (home.deitiesResponse?.data ?? [])
      .where((d) => d.name?.toUpperCase() != "DONATION")
      .toList();

  double _rateOf(dynamic rate) => double.tryParse(rate?.toString() ?? '') ?? 0;

  int get _totalQty => _cart.values.fold(0, (a, b) => a + b.qty);

  double get _totalAmount =>
      _cart.values.fold(0.0, (a, b) => a + _rateOf(b.rate) * b.qty);

  void _increase(HomeProvider home, dynamic item) {
    final existing = _cart[item.poojaId];
    setState(() {
      if (existing != null) {
        existing.qty++;
      } else {
        _cart[item.poojaId] = _CartItem(
          productId: item.poojaId,
          name: (_isEnglish ? item.name : (item.nameMal ?? item.name)) ?? '',
          rate: item.rate,
          categoryId: home.dietyId,
          categoryName: home.dietyIName,
        );
      }
    });
  }

  void _decrease(dynamic item) {
    final existing = _cart[item.poojaId];
    if (existing == null) return;
    setState(() {
      existing.qty--;
      if (existing.qty <= 0) _cart.remove(item.poojaId);
    });
  }

  Future<void> _onContinue(HomeProvider home) async {
    if (_cart.isEmpty && home.pooja.isEmpty) {
      Helpers.successToast("Please select a product");
      return;
    }
    FocusScope.of(context).unfocus();
    isEnabled.value = true;

    // One entry per unit so the bill total reflects the quantity.
    for (final c in _cart.values) {
      for (int i = 0; i < c.qty; i++) {
        await home.addToPoojaDetails(
          name: _defaultName,
          star: null,
          date: home.dateapi,
          dietyid: c.categoryId,
          diety: c.categoryName,
          poojaname: c.name,
          poojaid: c.productId,
          rate: c.rate,
          starid: 28,
        );
      }
    }

    await home.getPreviewBill(
      onSuccess: () async {
        navigatescrren(page: PreviewScreen(), context: context);
        home.clearStoredData();
        if (mounted) setState(() => _cart.clear());
        isEnabled.value = false;
      },
      onFailure: () {
        isEnabled.value = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Consumer<HomeProvider>(
            builder: (context, home, child) {
              return Padding(
                padding: EdgeInsets.fromLTRB(60.w, 30.h, 60.w, 20.h),
                child: Column(
                  children: [
                    _buildHeader(),
                    20.verticalSpace,
                    _sectionTitle("Categories"),
                    10.verticalSpace,
                    _buildCategories(home),
                    20.verticalSpace,
                    _sectionTitle("Products"),
                    10.verticalSpace,
                    Expanded(child: _buildProducts(home)),
                    15.verticalSpace,
                    _buildBottomBar(home),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
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
              Text(
                "BEVCO",
                style: TextStyle(
                  color: _red,
                  fontSize: 50.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
              Text(
                "Select your products",
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
    );
  }

  Widget _sectionTitle(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          t,
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

    // ---------------- CATEGORIES (deities API) ----------------
  Widget _buildCategories(HomeProvider home) {
    final categories = _categories(home);
    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final c = categories[i];
          final selected = home.dietyId == c.id;
          final label = _isEnglish ? "${c.name}" : "${c.nameMal ?? c.name}";
          return Padding(
            padding: EdgeInsets.only(right: 25.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: () {
                home.updateDietyId(id: c.id, name: label);
              },
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 170.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: selected ? _red : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(21.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(_dummyImage, fit: BoxFit.cover),
                            if (selected)
                              Container(color: _red.withOpacity(0.25)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- PRODUCTS (pooja API) ----------------
  Widget _buildProducts(HomeProvider home) {
    if (home.poojaload == LoaderState.loading) {
      return const Center(child: CircularProgressIndicator(color: _red));
    }
    final products = home.poojaResponse?.data ?? [];
    if (products.isEmpty) {
      return Center(
        child: Text(
          "No products available",
          style: TextStyle(color: Colors.black, fontSize: 24.sp),
        ),
      );
    }
    return Scrollbar(
      thumbVisibility: true,
      child: GridView.builder(
        padding: EdgeInsets.all(8.w),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.w,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, i) => _productCard(home, products[i]),
      ),
    );
  }

  Widget _productCard(HomeProvider home, dynamic item) {
    final qty = _cart[item.poojaId]?.qty ?? 0;
    final selected = qty > 0;
    final name = _isEnglish ? "${item.name ?? ''}" : "${item.nameMal ?? item.name ?? ''}";

    return GestureDetector(
      onTap: selected ? null : () => _increase(home, item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: selected ? _red : _silver.withOpacity(0.2),
            width: selected ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(23.r)),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(_dummyImage, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    "₹ ${item.rate}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.verticalSpace,
                  selected ? _qtyControl(home, item, qty) : _addButton(home, item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton(HomeProvider home, dynamic item) {
    return InkWell(
      onTap: () => _increase(home, item),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: _red),
        ),
        child: Text(
          "ADD",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _red,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _qtyControl(HomeProvider home, dynamic item, int qty) {
    return Container(
      decoration: BoxDecoration(
        color: _red,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _qtyBtn(Icons.remove, () => _decrease(item)),
          Text(
            "$qty",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          _qtyBtn(Icons.add, () => _increase(home, item)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Icon(icon, color: Colors.white, size: 26.sp),
        ),
      );

  // ---------------- BOTTOM BAR ----------------
  Widget _buildBottomBar(HomeProvider home) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
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
              Text(
                "$_totalQty item${_totalQty == 1 ? '' : 's'}",
                style: TextStyle(color: Colors.black, fontSize: 22.sp),
              ),
              Text(
                "₹ ${_totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isEnabled,
            builder: (context, loading, child) => InkWell(
              onTap: loading ? null : () => _onContinue(home),
              borderRadius: BorderRadius.circular(27.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 18.h,
                  horizontal: loading ? 150.w : 120.w,
                ),
                decoration: BoxDecoration(
                  color: (_cart.isEmpty && home.pooja.isEmpty)
                      ? _red.withOpacity(0.4)
                      : _red,
                  borderRadius: BorderRadius.circular(27.r),
                ),
                child: loading
                    ? SizedBox(
                        height: 34.h,
                        width: 34.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}