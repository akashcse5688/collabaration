class ProductModel {
  String? id;
  String? productName;
  String? productCode;
  String? unitPrice;
  String? quantity;
  String? totalPrice;
  String? image;

  ProductModel.fromJson(
      {required this.id,
      required this.productName,
      required this.productCode,
      required this.unitPrice,
      required this.quantity,
      required this.totalPrice,
      required this.image
      });
}
