class OrderModel {
  final int id;
  final String status;
  final String totalPrice;
  final String createdAt;
  final String image;

  OrderModel(
      {required this.id,
      required this.status,
      required this.totalPrice,
      required this.createdAt,
      required this.image});

  String get secureImageUrl {
    if ( image.isEmpty) return 'assets/images/splash.png';
    return image.startsWith('http://')
        ? image.replaceFirst('http://', 'https://')
        : image;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        id: json['id'],
        status: json['status'],
        totalPrice: json['total_price'],
        createdAt: json['created_at'],
        image: json['product_image']);
  }
}

class OrdersResponse {
  final int code;
  final String message;
  final List<OrderModel> orders;

  OrdersResponse({required this.code, required this.message, required this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
        code: json['code'],
        message: json['message'],
        orders:
            (json['data'] as List? ?? []).map((e) => OrderModel.fromJson(e)).toList());
  }
}
