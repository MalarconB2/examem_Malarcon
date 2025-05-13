class ProductModel {
  final int productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final String productState;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productState,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      productPrice: (json['product_price'] as num).toDouble(),
      productImage: json['product_image'] as String,
      productState: json['product_state'] as String,
    );
  }
}
