import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/app_colors.dart';


class EmptyBillState extends StatelessWidget {
  const EmptyBillState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      // Illustration scales with the smaller side so it fits phones in landscape too.
      final d = (c.biggest.shortestSide * 0.45).clamp(120.0, 200.0);
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: d,
                  height: d,
                  decoration:
                      const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: d * 0.3, color: AppColors.primary),
                      SizedBox(height: d * 0.08),
                      // BarcodeGlyph(width: d * 0.5, height: d * 0.15, color: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                 Center(
                   child: Text('സ്കാൻ ചെയ്യുന്നതിനായി നിങ്ങളുടെ പ്രോഡക്റ്റ്  ക്യാമറയ്ക്ക്  മുന്നിൽ വെക്കുക.\n(Please Hold Your Product Near the Scanner)',
                      style: TextStyle(
                          fontSize: 40.sp, fontWeight: FontWeight.w800, color: AppColors.textDark,),textAlign: TextAlign.center,),
                 ),
                // const SizedBox(height: 8),
                //  Text(
                //   'Scan a product to view its details\nand add it to your shopping list.',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 30.sp, height: 1.5, color: AppColors.textMuted),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}