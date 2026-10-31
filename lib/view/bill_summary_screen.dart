import 'package:flutter/material.dart';
import 'package:kiosk/app_colors.dart';



class BillSummary extends StatelessWidget {
  final int itemCount;
  final double subtotal;
  final double taxRate;
  final bool isPanel;
  //final VoidCallback onPay;
  final VoidCallback onPrint;

  const BillSummary({
    super.key,
    required this.itemCount,
    required this.subtotal,
    //required this.onPay,
    required this.onPrint,
    this.isPanel = false,
    this.taxRate = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    final tax = subtotal * taxRate;
    final total = subtotal + tax;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isPanel) ...[
          const Text('Bill summary',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 14),
        ],
        _row('Items', '$itemCount'),
        const SizedBox(height: 6),
        _row('Subtotal', rupees(subtotal)),
        const SizedBox(height: 6),
        _row('GST (${(taxRate * 100).toStringAsFixed(0)}%)', rupees(tax)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: AppColors.border),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text('Total amount',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text(rupees(total),
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: OutlinedButton.icon(
            //     onPressed: onPrint,
            //     icon: const Icon(Icons.print_outlined, size: 20),
            //     label: const Text('Print bill'),
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: AppColors.primary,
            //       minimumSize: const Size.fromHeight(48),
            //       side: const BorderSide(color: AppColors.primary),
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                //onPressed: onPay,
                onPressed: () {
                  
                },
                icon: const Icon(Icons.payments_outlined, size: 20),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Pay ${rupees(total)}'),
                ),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              ),
            ),
          ],
        ),
      ],
    );

    if (isPanel) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: content,
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, -3)),
        ],
      ),
      child: SafeArea(top: false, child: content),
    );
  }

  Widget _row(String l, String r) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          Text(r,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ],
      );

      String rupees(double v) => '₹${v.toStringAsFixed(2)}';
}