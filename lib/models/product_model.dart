// // To parse this JSON data, do
// //
// //     final productModel = productModelFromJson(jsonString);

// import 'dart:convert';

// ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

// String productModelToJson(ProductModel data) => json.encode(data.toJson());

// class ProductModel {
//     bool status;
//     String message;
//     Data data;

//     ProductModel({
//         required this.status,
//         required this.message,
//         required this.data,
//     });

//     factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
//         status: json["status"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data.toJson(),
//     };
// }

// class Data {
//     String productId;
//     String barcode1;
//     String barcode2;
//     String name;
//     String nameMal;
//     int price;
//     int mrp;
//     int taxRatePercent;
//     dynamic unit;
//     dynamic imageUrl;
//     bool inStock;

//     Data({
//         required this.productId,
//         required this.barcode1,
//         required this.barcode2,
//         required this.name,
//         required this.nameMal,
//         required this.price,
//         required this.mrp,
//         required this.taxRatePercent,
//         required this.unit,
//         required this.imageUrl,
//         required this.inStock,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         productId: json["product_id"],
//         barcode1: json["barcode1"],
//         barcode2: json["barcode2"],
//         name: json["name"],
//         nameMal: json["name_mal"],
//         price: json["price"],
//         mrp: json["mrp"],
//         taxRatePercent: json["tax_rate_percent"],
//         unit: json["unit"],
//         imageUrl: json["image_url"],
//         inStock: json["in_stock"],
//     );

//     Map<String, dynamic> toJson() => {
//         "product_id": productId,
//         "barcode1": barcode1,
//         "barcode2": barcode2,
//         "name": name,
//         "name_mal": nameMal,
//         "price": price,
//         "mrp": mrp,
//         "tax_rate_percent": taxRatePercent,
//         "unit": unit,
//         "image_url": imageUrl,
//         "in_stock": inStock,
//     };
// }




import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

double _toDouble(dynamic v) =>
    v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0.0;

class ProductModel {
  bool status;
  String message;
  Data data;

  ProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        status: json["status"] == true || json["status"] == 1,
        message: json["message"]?.toString() ?? '',
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String productId;
  String barcode1;
  String barcode2;
  String name;
  String nameMal;
  double price;
  double mrp;
  double taxRatePercent;
  dynamic unit;
  dynamic imageUrl;
  bool inStock;

  Data({
    required this.productId,
    required this.barcode1,
    required this.barcode2,
    required this.name,
    required this.nameMal,
    required this.price,
    required this.mrp,
    required this.taxRatePercent,
    required this.unit,
    required this.imageUrl,
    required this.inStock,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        productId: json["product_id"]?.toString() ?? '',
        barcode1: json["barcode1"]?.toString() ?? '',
        barcode2: json["barcode2"]?.toString() ?? '',
        name: json["name"]?.toString() ?? '',
        nameMal: json["name_mal"]?.toString() ?? '',
        price: _toDouble(json["price"]),
        mrp: _toDouble(json["mrp"]),
        taxRatePercent: _toDouble(json["tax_rate_percent"]),
        unit: json["unit"],
        imageUrl: json["image_url"],
        inStock: json["in_stock"] == true || json["in_stock"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "barcode1": barcode1,
        "barcode2": barcode2,
        "name": name,
        "name_mal": nameMal,
        "price": price,
        "mrp": mrp,
        "tax_rate_percent": taxRatePercent,
        "unit": unit,
        "image_url": imageUrl,
        "in_stock": inStock,
      };
}