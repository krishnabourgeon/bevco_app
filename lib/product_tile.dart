import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/app_colors.dart';
import 'package:kiosk/models/product.dart';



class ProductTile extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  const ProductTile({
    super.key,
    required this.item,
    required this.onQtyChanged,
    required this.onRemove,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return LayoutBuilder(builder: (context, c) {
  //     final wide = c.maxWidth >= 520;
  //     return Container(
  //       padding: EdgeInsets.all(wide ? 14 : 12),
  //       decoration: BoxDecoration(
  //         color: AppColors.surface,
  //         borderRadius: BorderRadius.circular(14),
  //         border: Border.all(color: AppColors.border),
  //       ),
  //       child: wide ? _wide() : _compact(),
  //     );
  //   });
  // }

  @override
Widget build(BuildContext context) {
  final p = item.product;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  Text('${p.category}  •  Barcode ${p.barcode}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 32.sp, color: AppColors.textMuted)),
                ],
              ),
            ),
            10.horizontalSpace,
            _QtyStepper(qty: item.qty, onChanged: onQtyChanged),
            20.horizontalSpace,
            _RemoveButton(onPressed: onRemove),
          ],
        ),
        15.verticalSpace,
        Container(height: 1.h, width: double.infinity, color: AppColors.border),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${rupees(item.product.price)}  x  ${item.qty}',
                style: TextStyle(
                    fontSize: 45.sp, color: AppColors.textDark)),
            Text(rupees(item.lineTotal),
                style: TextStyle(
                    fontSize: 45.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
          ],
        ),
      ],
    ),
  );
}

  Widget _thumb(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: size * 0.5),
      );

  Widget _info() {
    final p = item.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(p.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 3),
        Text('${p.category}  •  Barcode ${p.barcode}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _compact() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _thumb(44),
            const SizedBox(width: 10),
            Expanded(child: _info()),
            const SizedBox(width: 8),
            _RemoveButton(onPressed: onRemove),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: AppColors.border),
        ),
        Row(
          children: [
            Expanded(
              child: Text('${rupees(item.product.price)} each',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ),
            _QtyStepper(qty: item.qty, onChanged: onQtyChanged),
            Expanded(
              child: Text(rupees(item.lineTotal),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _wide() {
    return Row(
      children: [
        _thumb(56),
        const SizedBox(width: 14),
        Expanded(child: _info()),
        const SizedBox(width: 12),
        SizedBox(
          width: 88,
          child: Text('${rupees(item.product.price)} each',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ),
        _QtyStepper(qty: item.qty, onChanged: onQtyChanged),
        SizedBox(
          width: 100,
          child: Text(rupees(item.lineTotal),
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ),
        const SizedBox(width: 12),
        _RemoveButton(onPressed: onRemove),
      ],
    );
  }
  String rupees(double v) => '₹${v.toStringAsFixed(2)}';
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _RemoveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Remove item',
      child: Material(
        color: AppColors.primarySoft,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.close_rounded, size: 18, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  const _QtyStepper({required this.qty, required this.onChanged});

  Widget _btn(IconData icon, Color color, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(icon, size: 18, color: color),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quantity never goes below 1. Use the X button to remove a product.
          _btn(Icons.remove, qty > 1 ? AppColors.primary : AppColors.border, () {
            if (qty > 1) onChanged(qty - 1);
          }),
          SizedBox(
            width: 28,
            child: Text('$qty',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
          ),
          _btn(Icons.add, AppColors.primary, () => onChanged(qty + 1)),
        ],
      ),
    );
  }

}