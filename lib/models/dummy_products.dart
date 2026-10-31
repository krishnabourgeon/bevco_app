

import 'package:kiosk/models/product.dart';

/// Set to true to preview the empty-state screen.
const bool kPreviewEmptyState = false;

const dummyProducts = <Product>[
  Product(barcode: '8901030865278', name: 'Basmati Rice 1 kg', category: 'Grocery', price: 129.00),
  Product(barcode: '8901063010116', name: 'Britannia Marie Gold', category: 'Biscuits', price: 35.00),
  Product(barcode: '8901233023004', name: 'Amul Butter 100 g', category: 'Dairy', price: 58.00),
  Product(barcode: '8904043901015', name: 'Coconut Oil 500 ml', category: 'Oil', price: 185.00),
  Product(barcode: '8901491101837', name: 'Lux Soap Pack of 3', category: 'Personal Care', price: 120.00),
  Product(barcode: '8901725181213', name: 'Tea Powder 250 g', category: 'Beverages', price: 98.00),
//   Product(
//     barcode: 'N820W3D6604',
//     name: 'Test POS Product',
//     category: 'Beverages',
//     price: 100.00,
//   ),
// ];

Product(barcode: 'N820W3D6604', name: 'Test POS Product', category: 'Beverages',
        price: 100.00, productId: 1, categoryId: 1),
];

/// Dummy "already scanned" list used to preview the product details screen.
const dummyCart = <CartItem>[
  CartItem(Product(barcode: '8901030865278', name: 'Basmati Rice 1 kg', category: 'Grocery', price: 129.00), qty: 2),
  CartItem(Product(barcode: '8901063010116', name: 'Britannia Marie Gold', category: 'Biscuits', price: 35.00), qty: 3),
  CartItem(Product(barcode: '8901233023004', name: 'Amul Butter 100 g', category: 'Dairy', price: 58.00)),
  CartItem(Product(barcode: '8904043901015', name: 'Coconut Oil 500 ml', category: 'Oil', price: 185.00)),
];