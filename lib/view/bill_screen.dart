// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:kiosk/app_colors.dart';
// // import 'package:provider/provider.dart';
// // import 'package:kiosk/app_header.dart';
// // import 'package:kiosk/confirm_dialog.dart';
// // import 'package:kiosk/empty_bill_state.dart';
// // import 'package:kiosk/models/dummy_products.dart';
// // import 'package:kiosk/models/product.dart';
// // import 'package:kiosk/product_tile.dart';
// // import 'package:kiosk/provider/homeprovider.dart';
// // import 'package:kiosk/responsive.dart';
// // import 'package:kiosk/view/bill_summary_screen.dart';
// // import 'package:kiosk/view/billpreview.dart';
// // import 'package:kiosk/view/homepage.dart';


// // class BillScreen extends StatefulWidget {
// //   const BillScreen({super.key});

// //   @override
// //   State<BillScreen> createState() => _BillScreenState();
// // }

// // class _BillScreenState extends State<BillScreen> {
// //   final TextEditingController _barcodeController =
// //     TextEditingController();

// // bool _isSearchingBarcode = false;

// // final StringBuffer _scanBuffer = StringBuffer();
// // DateTime _lastKeyTime = DateTime.now();
// // Timer? _scanTimer; // needs: import 'dart:async';

// // static const _beep = MethodChannel('kerala_beverage_app/beep');

// // @override
// // void initState() {
// //   super.initState();
// //   HardwareKeyboard.instance.addHandler(_onKey);
// // }

// // @override
// // void dispose() {
// //   HardwareKeyboard.instance.removeHandler(_onKey);
// //   _scanTimer?.cancel();
// //   _barcodeController.dispose();
// //   super.dispose();
// // }

// // bool _onKey(KeyEvent event) {
// //   if (event is! KeyDownEvent) return false; // ignore key-up / repeat

// //   final now = DateTime.now();
// //   // Scanners type very fast (<50 ms per key). A long gap means a new scan
// //   // (or a human typing), so start over.
// //   if (now.difference(_lastKeyTime).inMilliseconds > 100) {
// //     _scanBuffer.clear();
// //   }
// //   _lastKeyTime = now;

// //   final key = event.logicalKey;
// //   if (key == LogicalKeyboardKey.enter ||
// //       key == LogicalKeyboardKey.numpadEnter ||
// //       key == LogicalKeyboardKey.tab) {
// //     _submitScan();
// //     return true;
// //   }

// //   final ch = event.character;
// //   if (ch != null && ch.isNotEmpty && ch.codeUnitAt(0) >= 32) {
// //     _scanBuffer.write(ch);
// //     // Fallback for scanners configured with no Enter suffix.
// //     _scanTimer?.cancel();
// //     _scanTimer = Timer(const Duration(milliseconds: 150), _submitScan);
// //     return true; // consume so nothing else reacts
// //   }
// //   return false;
// // }

// // void _submitScan() {
// //   _scanTimer?.cancel();
// //   final code = _scanBuffer.toString().trim();
// //   _scanBuffer.clear();
// //   if (code.length >= 4) _searchBarcode(code); // ignore stray keypresses
// // }


// // Future<void> _searchBarcode(String value) async {
// //   final barcode = value.trim();
// //   if (barcode.isEmpty) return;

// //   debugPrint('scanned: "$barcode"'); // remove after testing

// //   Product? product;
// //   for (final item in dummyProducts) {
// //     if (item.barcode.trim().toLowerCase() == barcode.toLowerCase()) {
// //       product = item;
// //       break;
// //     }
// //   }

// //   if (!mounted) return;

// //   if (product == null) {
// //     _beep.invokeMethod('error');                 // ADDED
// //     _snack('Product not found: $barcode');
// //     return;
// //   }

// //   final found = product; // non-null copy, so no `!` is needed below
// //   final index = _items.indexWhere(
// //     (item) => item.product.barcode.toLowerCase() == found.barcode.toLowerCase(),
// //   );

// //   setState(() {
// //     if (index >= 0) {
// //       _items[index] = _items[index].copyWith(qty: _items[index].qty + 1);
// //     } else {
// //       _items.add(CartItem(found, qty: 1));
// //     }
// //   });

// //   _beep.invokeMethod('success');                 // ADDED
// //   _snack('${found.name} added to bill');
// // }
// //   // Dummy data for now. Later, fill this list from your backend.
// //   //late final List<CartItem> _items = kPreviewEmptyState ? [] : [...dummyCart];
// //   final List<CartItem> _items = [];

// //   double get _subtotal => _items.fold(0, (s, i) => s + i.lineTotal);
// //   int get _count => _items.fold(0, (s, i) => s + i.qty);

// //   void _setQty(int index, int qty) => setState(() => _items[index] = _items[index].copyWith(qty: qty));

// //   Future<void> _remove(int index) async {
// //     final ok = await showConfirmDialog(
// //       context,
// //       title: 'Remove item?',
// //       message: '${_items[index].product.name} will be removed from this bill.',
// //       confirmLabel: 'Remove',
// //     );
// //     if (ok && mounted) setState(() => _items.removeAt(index));
// //   }

// //   Future<void> _clearAll() async {
// //     final ok = await showConfirmDialog(
// //       context,
// //       title: 'Clear all items?',
// //       message: 'All products will be removed from this bill.',
// //       confirmLabel: 'Clear all',
// //     );
// //     if (ok && mounted) setState(_items.clear);
// //   }

// //   // Future<void> _openPreview() async {
// //   //   final mode = await Navigator.push<String>(
// //   //     context,
// //   //     MaterialPageRoute(builder: (_) => BillPreviewScreen(items: List.of(_items))),
// //   //   );
// //   //   if (mode == null || !mounted) return;
// //   //   // TODO: start the actual payment here ("CARD" or "UPI").
// //   //   _snack('Paying via $mode — payment integration coming next');
// //   // }

// //   void _snack(String msg) => ScaffoldMessenger.of(context)
// //     ..hideCurrentSnackBar()
// //     ..showSnackBar(SnackBar(content: Text(msg)));

  

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: AnnotatedRegion<SystemUiOverlayStyle>(
// // //         value: SystemUiOverlayStyle.dark,
// // //         child: Column(
// // //           children: [
// // //             const AppHeader(),
// // //             Expanded(child: _body()),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _body() {
// // //     return LayoutBuilder(builder: (context, c) {
// // //       if (_items.isEmpty) return const EmptyBillState();

// // //       final w = c.maxWidth;
// // //       final h = c.maxHeight;
// // //       // Side panel on wide screens, and on phones held in landscape.
// // //       final split = w >= Responsive.splitBreakpoint || (w >= Responsive.tabletBreakpoint && h < 520);
// // //       final hPad = w >= Responsive.desktopBreakpoint ? 24.0 : 16.0;

// // //       final list = _buildList(hPad);

// // //       if (split) {
// // //         final panelWidth = (w * 0.34).clamp(340.0, 420.0);
// // //         return Center(
// // //           child: ConstrainedBox(
// // //             constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
// // //             child: Row(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Expanded(child: list),
// // //                 SizedBox(
// // //                   width: panelWidth,
// // //                   child: SingleChildScrollView(
// // //                     padding: EdgeInsets.fromLTRB(0, 16, hPad, 16),
// // //                     child: _summary(isPanel: true),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       }

// // //       // Phones and tablets in portrait: list on top, bill bar at the bottom.
// // //       return Center(
// // //         child: ConstrainedBox(
// // //           constraints: const BoxConstraints(maxWidth: 720),
// // //           child: Column(
// // //             children: [
// // //               Expanded(child: list),
// // //               _summary(isPanel: false),
// // //             ],
// // //           ),
// // //         ),
// // //       );
// // //     });
// // //   }

// // //   Widget _summary({required bool isPanel}) => BillSummary(
// // //         itemCount: _count,
// // //         subtotal: _subtotal,
// // //         isPanel: isPanel,
// // //         //onPay: _openPreview,
// // //         onPrint: () => _snack('Print bill coming next'),
// // //       );

// // //   Widget _buildList(double hPad) {
// // //     return Column(
// // //       children: [
// // //         Padding(
// // //           padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 6),
// // //           child: Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             children: [
// // //               Text('Items (${_items.length})',
// // //                   style: const TextStyle(
// // //                       fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
// // //               TextButton.icon(
// // //                 onPressed: _clearAll,
// // //                 icon: const Icon(Icons.delete_outline, size: 18),
// // //                 label: const Text('Clear all'),
// // //                 style: TextButton.styleFrom(foregroundColor: AppColors.primary),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         Expanded(
// // //           child: ListView.separated(
// // //             padding: EdgeInsets.fromLTRB(hPad, 6, hPad, 16),
// // //             itemCount: _items.length,
// // //             separatorBuilder: (_, __) => const SizedBox(height: 10),
// // //             itemBuilder: (_, i) => ProductTile(
// // //               item: _items[i],
// // //               onQtyChanged: (q) => _setQty(i, q),
// // //               onRemove: () => _remove(i),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }



// // Color get _red => const Color(0xFFD32F2F); // same _red as your product screen

// // @override
// // Widget build(BuildContext context) {
// //   return Scaffold(
// //     backgroundColor: Colors.white,
// //     body: AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.dark,
// //       child: Padding(
// //         padding: EdgeInsets.fromLTRB(90.w, 40.h, 90.w, 5.h),
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: Column(
// //                 children: [
// //                   25.verticalSpace,
// //                   _buildHeader(),
// //                   20.verticalSpace,
// //                   Expanded(child: _buildBillCard()),
// //                 ],
// //               ),
// //             ),
// //             _buildBottomBar(),
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }

// // // ---------------- HEADER ----------------
// // Widget _buildHeader() {
// //   return Container(
// //     padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
// //     decoration: BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(30.r),
// //       border: Border.all(color: Colors.black),
// //     ),
// //     child: Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("BEVCO",
// //                 style: TextStyle(
// //                   color: _red,
// //                   fontSize: 50.sp,
// //                   fontWeight: FontWeight.w800,
// //                   letterSpacing: 4,
// //                 )),
// //             Text("Your bill",
// //                 style: TextStyle(color: Colors.black, fontSize: 30.sp)),
// //           ],
// //         ),
// //         SizedBox(
// //           height: 70.h,
// //           width: 250.w,
// //           child: Image.asset(
// //             "assets/images/bevco_logo.png",
// //             fit: BoxFit.contain,
// //             errorBuilder: (_, __, ___) => const SizedBox(),
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// // // ---------------- BILL CARD ----------------
// // Widget _buildBillCard() {
// //   return Container(
// //     decoration: BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(45.r),
// //       border: Border.all(color: Colors.black),
// //     ),
// //     padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 20.h),
// //     child: Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Items (${_items.length})',
// //                 style: TextStyle(
// //                     fontSize: 50.sp,
// //                     fontWeight: FontWeight.w500,
// //                     color: AppColors.textDark)),
// //             if (_items.isNotEmpty)
// //               TextButton.icon(
// //                 onPressed: _clearAll,
// //                 icon: Icon(Icons.delete_outline, size: 50.w),
// //                 label: Text('Clear all', style: TextStyle(fontSize: 40.sp)),
// //                 style: TextButton.styleFrom(foregroundColor: _red),
// //               ),
// //           ],
// //         ),
// //         10.verticalSpace,
// //         Container(height: 2.h, width: double.infinity, color: _red),
// //         20.verticalSpace,
// //         Expanded(
// //           child: _items.isEmpty
// //               ? const EmptyBillState()
// //               : ListView.separated(
// //                   itemCount: _items.length,
// //                   separatorBuilder: (_, __) => 10.verticalSpace,
// //                   itemBuilder: (_, i) => ProductTile(
// //                     item: _items[i],
// //                     onQtyChanged: (q) => _setQty(i, q),
// //                     onRemove: () => _remove(i),
// //                   ),
// //                 ),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// // bool _loading = false;

// // Future<void> _onContinue() async {
// //   if (_items.isEmpty || _loading) return;
// //   final home = context.read<HomeProvider>();

// //   setState(() => _loading = true);

// //   // Start from a clean bill so repeated taps / coming back don't duplicate lines.
// //   home.clearGrossAmount();
// //   if (home.dateapi == null) home.updateSelectedDate();

// //   // One entry per unit, same as bookpooja, so the total reflects quantity.
// //   for (final item in _items) {
// //     for (int i = 0; i < item.qty; i++) {
// //       await home.addToPoojaDetails(
// //         name: 'BEVCO',
// //         star: null,
// //         date: home.dateapi,
// //         dietyid: item.product.categoryId,
// //         diety: item.product.category,
// //         poojaname: item.product.name,
// //         poojaid: item.product.productId,
// //         rate: item.product.price.toString(),
// //         starid: 28,
// //       );
// //     }
// //   }

// //   await home.getPreviewBill(
// //     onSuccess: () {
// //       if (!mounted) return;
// //       navigatescrren(page: const PreviewScreen(), context: context);
// //       setState(() => _loading = false);
// //     },
// //     onFailure: () {
// //       if (mounted) setState(() => _loading = false);
// //     },
// //   );
// // }

// // // ---------------- BOTTOM BAR ----------------
// // Widget _buildBottomBar() {
// //   return Padding(
// //     padding: EdgeInsets.symmetric(horizontal: 100.w),
// //     child: Column(
// //       children: [
// //         20.verticalSpace,
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Total Amount',
// //                     style: TextStyle(fontSize: 50.sp, color: Colors.black)),
// //                 Text('₹ ${_subtotal.toStringAsFixed(0)}',
// //                     style: TextStyle(
// //                         fontSize: 60.sp,
// //                         fontWeight: FontWeight.w700,
// //                         color: Colors.black)),
// //               ],
// //             ),
// //             InkWell(
// //               // onTap: _items.isEmpty
// //               //     ? null
// //               //     : () => _snack('Print bill coming next'), // later: _openPreview
// //                 onTap: (_items.isEmpty || _loading) ? null : _onContinue,
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(27.r),
// //                   color: _items.isEmpty ? Colors.grey : _red,
// //                 ),
// //                 padding:
// //                     EdgeInsets.symmetric(vertical: 18.h, horizontal: 150.w),
// //                 child: Text('Continue',
// //                     style: TextStyle(
// //                         fontSize: 50.sp,
// //                         fontWeight: FontWeight.w700,
// //                         color: Colors.white)),
// //               ),
// //             ),
// //           ],
// //         ),
// //         20.verticalSpace,
// //       ],
// //     ),
// //   );
// // }
// // }



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/app_colors.dart';
// import 'package:provider/provider.dart';
// import 'package:kiosk/app_header.dart';
// import 'package:kiosk/confirm_dialog.dart';
// import 'package:kiosk/empty_bill_state.dart';
// import 'package:kiosk/models/dummy_products.dart';
// import 'package:kiosk/models/product.dart';
// import 'package:kiosk/product_tile.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/responsive.dart';
// import 'package:kiosk/view/bill_summary_screen.dart';
// import 'package:kiosk/view/billpreview.dart';
// import 'package:kiosk/view/homepage.dart';


// class BillScreen extends StatefulWidget {
//   const BillScreen({super.key});

//   @override
//   State<BillScreen> createState() => _BillScreenState();
// }

// class _BillScreenState extends State<BillScreen> {
//   final TextEditingController _barcodeController =
//     TextEditingController();

// bool _isSearchingBarcode = false;

// final StringBuffer _scanBuffer = StringBuffer();
// DateTime _lastKeyTime = DateTime.now();
// Timer? _scanTimer; // needs: import 'dart:async';

// static const _beep = MethodChannel('punnyam_kiosk_kadampuzha/beep');

// @override
// void initState() {
//   super.initState();
//   HardwareKeyboard.instance.addHandler(_onKey);
// }

// @override
// void dispose() {
//   HardwareKeyboard.instance.removeHandler(_onKey);
//   _scanTimer?.cancel();
//   _barcodeController.dispose();
//   super.dispose();
// }

// bool _onKey(KeyEvent event) {
//   if (event is! KeyDownEvent) return false; // ignore key-up / repeat

//   final now = DateTime.now();
//   // Scanners type very fast (<50 ms per key). A long gap means a new scan
//   // (or a human typing), so start over.
//   if (now.difference(_lastKeyTime).inMilliseconds > 100) {
//     _scanBuffer.clear();
//   }
//   _lastKeyTime = now;

//   final key = event.logicalKey;
//   if (key == LogicalKeyboardKey.enter ||
//       key == LogicalKeyboardKey.numpadEnter ||
//       key == LogicalKeyboardKey.tab) {
//     _submitScan();
//     return true;
//   }

//   final ch = event.character;
//   if (ch != null && ch.isNotEmpty && ch.codeUnitAt(0) >= 32) {
//     _scanBuffer.write(ch);
//     // Fallback for scanners configured with no Enter suffix.
//     _scanTimer?.cancel();
//     _scanTimer = Timer(const Duration(milliseconds: 150), _submitScan);
//     return true; // consume so nothing else reacts
//   }
//   return false;
// }

// void _submitScan() {
//   _scanTimer?.cancel();
//   final code = _scanBuffer.toString().trim();
//   _scanBuffer.clear();
//   if (code.length >= 4) _searchBarcode(code); // ignore stray keypresses
// }


// Future<void> _searchBarcode(String value) async {
//   final barcode = value.trim();
//   if (barcode.isEmpty) return;

//   debugPrint('scanned: "$barcode"'); // remove after testing

//   Product? product;
//   for (final item in dummyProducts) {
//     if (item.barcode.trim().toLowerCase() == barcode.toLowerCase()) {
//       product = item;
//       break;
//     }
//   }

//   if (!mounted) return;

//   if (product == null) {
//     _beep.invokeMethod('error');                 // ADDED
//     _snack('Product not found: $barcode');
//     return;
//   }

//   final found = product; // non-null copy, so no `!` is needed below
//   final index = _items.indexWhere(
//     (item) => item.product.barcode.toLowerCase() == found.barcode.toLowerCase(),
//   );

//   setState(() {
//     if (index >= 0) {
//       _items[index] = _items[index].copyWith(qty: _items[index].qty + 1);
//     } else {
//       _items.add(CartItem(found, qty: 1));
//     }
//   });

//   _beep.invokeMethod('success');                 // ADDED
//   _snack('${found.name} added to bill');
// }
//   // Dummy data for now. Later, fill this list from your backend.
//   //late final List<CartItem> _items = kPreviewEmptyState ? [] : [...dummyCart];
//   final List<CartItem> _items = [];

//   double get _subtotal => _items.fold(0, (s, i) => s + i.lineTotal);
//   int get _count => _items.fold(0, (s, i) => s + i.qty);

//   void _setQty(int index, int qty) => setState(() => _items[index] = _items[index].copyWith(qty: qty));

//   Future<void> _remove(int index) async {
//     final ok = await showConfirmDialog(
//       context,
//       title: 'Remove item?',
//       message: '${_items[index].product.name} will be removed from this bill.',
//       confirmLabel: 'Remove',
//     );
//     if (ok && mounted) setState(() => _items.removeAt(index));
//   }

//   Future<void> _clearAll() async {
//     final ok = await showConfirmDialog(
//       context,
//       title: 'Clear all items?',
//       message: 'All products will be removed from this bill.',
//       confirmLabel: 'Clear all',
//     );
//     if (ok && mounted) setState(_items.clear);
//   }


//   void _snack(String msg) => ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(SnackBar(content: Text(msg)));



// Color get _red => const Color(0xFFD32F2F); // same _red as your product screen

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.white,
//     body: AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(90.w, 40.h, 90.w, 5.h),
//         child: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   25.verticalSpace,
//                   _buildHeader(),
//                   20.verticalSpace,
//                   Expanded(child: _buildBillCard()),
//                 ],
//               ),
//             ),
//             _buildBottomBar(),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// // ---------------- HEADER ----------------
// Widget _buildHeader() {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(30.r),
//       border: Border.all(color: Colors.black),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("BEVCO",
//                 style: TextStyle(
//                   color: _red,
//                   fontSize: 50.sp,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 4,
//                 )),
//             Text("Your bill",
//                 style: TextStyle(color: Colors.black, fontSize: 30.sp)),
//           ],
//         ),
//         SizedBox(
//           height: 70.h,
//           width: 250.w,
//           child: Image.asset(
//             "assets/images/bevco_logo.png",
//             fit: BoxFit.contain,
//             errorBuilder: (_, __, ___) => const SizedBox(),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // ---------------- BILL CARD ----------------
// Widget _buildBillCard() {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(45.r),
//       border: Border.all(color: Colors.black),
//     ),
//     padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 20.h),
//     child: Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Items (${_items.length})',
//                 style: TextStyle(
//                     fontSize: 50.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.textDark)),
//             if (_items.isNotEmpty)
//               TextButton.icon(
//                 onPressed: _clearAll,
//                 icon: Icon(Icons.delete_outline, size: 50.w),
//                 label: Text('Clear all', style: TextStyle(fontSize: 40.sp)),
//                 style: TextButton.styleFrom(foregroundColor: _red),
//               ),
//           ],
//         ),
//         10.verticalSpace,
//         Container(height: 2.h, width: double.infinity, color: _red),
//         20.verticalSpace,
//         Expanded(
//           child: _items.isEmpty
//               ? const EmptyBillState()
//               : ListView.separated(
//                   itemCount: _items.length,
//                   separatorBuilder: (_, __) => 10.verticalSpace,
//                   itemBuilder: (_, i) => ProductTile(
//                     item: _items[i],
//                     onQtyChanged: (q) => _setQty(i, q),
//                     onRemove: () => _remove(i),
//                   ),
//                 ),
//         ),
//       ],
//     ),
//   );
// }

// bool _loading = false;

// Future<void> _onContinue() async {
//   if (_items.isEmpty || _loading) return;
//   final home = context.read<HomeProvider>();

//   setState(() => _loading = true);

//   // Start from a clean bill so repeated taps / coming back don't duplicate lines.
//   home.clearGrossAmount();
//   if (home.dateapi == null) home.updateSelectedDate();

//   // One entry per unit, same as bookpooja, so the total reflects quantity.
//   for (final item in _items) {
//     for (int i = 0; i < item.qty; i++) {
//       await home.addToPoojaDetails(
//         name: 'BEVCO',
//         star: null,
//         date: home.dateapi,
//         dietyid: item.product.categoryId,
//         diety: item.product.category,
//         poojaname: item.product.name,
//         poojaid: item.product.productId,
//         rate: item.product.price.toString(),
//         starid: 28,
//       );
//     }
//   }

//   await home.getPreviewBill(
//     onSuccess: () {
//       if (!mounted) return;
//       navigatescrren(page: const PreviewScreen(), context: context);
//       setState(() => _loading = false);
//     },
//     onFailure: () {
//       if (mounted) setState(() => _loading = false);
//     },
//   );
// }

// // ---------------- BOTTOM BAR ----------------
// Widget _buildBottomBar() {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 100.w),
//     child: Column(
//       children: [
//         20.verticalSpace,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Total Amount',
//                     style: TextStyle(fontSize: 50.sp, color: Colors.black)),
//                 Text('₹ ${_subtotal.toStringAsFixed(0)}',
//                     style: TextStyle(
//                         fontSize: 60.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black)),
//               ],
//             ),
//             InkWell(
//               // onTap: _items.isEmpty
//               //     ? null
//               //     : () => _snack('Print bill coming next'), // later: _openPreview
//                 onTap: (_items.isEmpty || _loading) ? null : _onContinue,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(27.r),
//                   color: _items.isEmpty ? Colors.grey : _red,
//                 ),
//                 padding:
//                     EdgeInsets.symmetric(vertical: 18.h, horizontal: 150.w),
//                 child: Text('Continue',
//                     style: TextStyle(
//                         fontSize: 50.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//         20.verticalSpace,
//       ],
//     ),
//   );
// }
// }





import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:kiosk/app_header.dart';
import 'package:kiosk/confirm_dialog.dart';
import 'package:kiosk/empty_bill_state.dart';
import 'package:kiosk/models/product.dart';
import 'package:kiosk/models/product_model.dart' as api;
import 'package:kiosk/product_tile.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/responsive.dart';
import 'package:kiosk/view/bill_summary_screen.dart';
import 'package:kiosk/view/billpreview.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:kiosk/view/loginscreen.dart' show LoginScreen;
import 'package:kiosk/services/shared_preference_helper.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  // The API doesn't return a deity/category, but addToPoojaDetails needs one.
  // TODO: set these to the BEVCO deity id/name used in your backend.
  static const int _bevcoCategoryId = 1;
  static const String _bevcoCategoryName = 'BEVCO';

  final StringBuffer _scanBuffer = StringBuffer();
  DateTime _lastKeyTime = DateTime.now();
  Timer? _scanTimer;

  static const _beep = MethodChannel('punnyam_kiosk_kadampuzha/beep');

  final List<CartItem> _items = [];
  int _pendingLookups = 0; // API calls currently in flight
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _scanTimer?.cancel();
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final now = DateTime.now();
    if (now.difference(_lastKeyTime).inMilliseconds > 100) {
      _scanBuffer.clear();
    }
    _lastKeyTime = now;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.tab) {
      _submitScan();
      return true;
    }

    final ch = event.character;
    if (ch != null && ch.isNotEmpty && ch.codeUnitAt(0) >= 32) {
      _scanBuffer.write(ch);
      _scanTimer?.cancel();
      _scanTimer = Timer(const Duration(milliseconds: 150), _submitScan);
      return true;
    }
    return false;
  }

  void _submitScan() {
    _scanTimer?.cancel();
    final code = _scanBuffer.toString().trim();
    _scanBuffer.clear();
    if (code.length >= 4) _searchBarcode(code);
  }

  // Maps the API response to the Product model used by the cart.
  // If your Product constructor differs, only this method needs changing.
  Product _toProduct(api.Data d) => Product(
        productId: int.tryParse(d.productId) ?? 0,
        barcode: d.barcode1,
        name: d.name,
        price: d.price.toDouble(),
        categoryId: _bevcoCategoryId,
        category: _bevcoCategoryName,
      );

  Future<void> _searchBarcode(String value) async {
    final barcode = value.trim();
    if (barcode.isEmpty) return;

    debugPrint('scanned: "$barcode"');

    setState(() => _pendingLookups++);
    final model = await context.read<HomeProvider>().getProduct(
          Uri.encodeComponent(barcode),
        );
    if (!mounted) return;
    setState(() => _pendingLookups--);

    if (model == null) {
      _beep.invokeMethod('error');
      _snack('Product not found: $barcode');
      return;
    }

    final data = model.data;

    if (!data.inStock) {
      _beep.invokeMethod('error');
      _snack('${data.name} is out of stock');
      return;
    }

    final product = _toProduct(data);

    // Match on product id, since a product can have two barcodes.
    final index = _items.indexWhere(
      (item) => item.product.productId == product.productId,
    );

    setState(() {
      if (index >= 0) {
        _items[index] = _items[index].copyWith(qty: _items[index].qty + 1);
      } else {
        _items.add(CartItem(product, qty: 1));
      }
    });

    _beep.invokeMethod('success');
    _snack('${product.name} added to list');
  }

  double get _subtotal => _items.fold(0, (s, i) => s + i.lineTotal);
  int get _count => _items.fold(0, (s, i) => s + i.qty);

  void _setQty(int index, int qty) =>
      setState(() => _items[index] = _items[index].copyWith(qty: qty));

  Future<void> _remove(int index) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Remove item?',
      message: '${_items[index].product.name} will be removed from this list.',
      confirmLabel: 'Remove',
    );
    if (ok && mounted) setState(() => _items.removeAt(index));
  }

  Future<void> _clearAll() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Clear all items?',
      message: 'All products will be removed from this list.',
      confirmLabel: 'Clear all',
    );
    if (ok && mounted) setState(_items.clear);
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Color get _red => const Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Padding(
          padding: EdgeInsets.fromLTRB(90.w, 40.h, 90.w, 5.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    25.verticalSpace,
                    _buildHeader(),
                    20.verticalSpace,
                    Expanded(child: _buildBillCard()),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
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
              Text("BEVCO",
                  style: TextStyle(
                    color: _red,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  )),
              Text("Your bill",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ],
          ),
          // Tapping the logo opens a dropdown with Logout.
          PopupMenuButton<String>(
            tooltip: "",
            offset: Offset(0, 80.h),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            onSelected: (value) {
              if (value == "logout") _logout();
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: _red, size: 36.w),
                    12.horizontalSpace,
                    Text(
                      "LOGOUT",
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: SizedBox(
              height: 70.h,
              width: 250.w,
              child: Image.asset(
                "assets/images/bevco_logo.png",
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Same as the home screen logout; also drops the items in the cart.
  void _logout() {
    context.read<HomeProvider>().clearGrossAmount();
    SharedPreferenceHelper.clearWholeData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // ---------------- BILL CARD ----------------
  Widget _buildBillCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45.r),
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items (${_items.length})',
                  style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
              if (_items.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(Icons.delete_outline, size: 50.w),
                  label: Text('Clear all', style: TextStyle(fontSize: 40.sp)),
                  style: TextButton.styleFrom(foregroundColor: _red),
                ),
            ],
          ),
          10.verticalSpace,
          // Doubles as a "looking up product" indicator while the API call runs.
          _pendingLookups > 0
              ? SizedBox(
                  height: 2.h,
                  child: LinearProgressIndicator(
                    color: _red,
                    backgroundColor: _red.withOpacity(0.2),
                  ),
                )
              : Container(height: 2.h, width: double.infinity, color: _red),
          20.verticalSpace,
          Expanded(
            child: _items.isEmpty
                ? const EmptyBillState()
                : ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => 10.verticalSpace,
                    itemBuilder: (_, i) => ProductTile(
                      item: _items[i],
                      onQtyChanged: (q) => _setQty(i, q),
                      onRemove: () => _remove(i),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_items.isEmpty || _loading) return;
    final home = context.read<HomeProvider>();

    setState(() => _loading = true);

    home.clearGrossAmount();
    if (home.dateapi == null) home.updateSelectedDate();

    // One entry per unit, same as bookpooja, so the total reflects quantity.
    for (final item in _items) {
      for (int i = 0; i < item.qty; i++) {
        await home.addToPoojaDetails(
          name: 'BEVCO',
          star: null,
          date: home.dateapi,
          dietyid: item.product.categoryId,
          diety: item.product.category,
          poojaname: item.product.name,
          poojaid: item.product.productId,
          rate: item.product.price.toString(),
          starid: 28,
        );
      }
    }

    await home.getPreviewBill(
      onSuccess: () {
        if (!mounted) return;
        navigatescrren(page: const PreviewScreen(), context: context);
        setState(() => _loading = false);
      },
      onFailure: () {
        if (mounted) setState(() => _loading = false);
      },
    );
  }

  // ---------------- BOTTOM BAR ----------------
  Widget _buildBottomBar() {
    final disabled = _items.isEmpty || _loading || _pendingLookups > 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: Column(
        children: [
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount',
                      style: TextStyle(fontSize: 50.sp, color: Colors.black)),
                  Text('₹ ${_subtotal.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ],
              ),
              InkWell(
                onTap: disabled ? null : _onContinue,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27.r),
                    color: disabled ? Colors.grey : _red,
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 18.h, horizontal: 150.w),
                  child: Text('Continue',
                      style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}