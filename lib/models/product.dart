// class Product {
//   final String barcode;
//   final String name;
//   final String category;
//   final double price;

//   const Product({
//     required this.barcode,
//     required this.name,
//     required this.category,
//     required this.price,
//   });
// }

class Product {
  final String barcode;
  final String name;
  final String category;
  final double price;
  final int? productId;   // → poojaId sent to preview-bill
  final int? categoryId;  // → deityId sent to preview-bill

  const Product({
    required this.barcode,
    required this.name,
    required this.category,
    required this.price,
    this.productId,
    this.categoryId,
  });
}

class CartItem {
  final Product product;
  final int qty;

  const CartItem(this.product, {this.qty = 1});

  double get lineTotal => product.price * qty;
  CartItem copyWith({int? qty}) => CartItem(product, qty: qty ?? this.qty);
}