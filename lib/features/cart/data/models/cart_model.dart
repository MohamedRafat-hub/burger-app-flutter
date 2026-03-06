import 'package:food_app/features/product/data/models/topping_model.dart';

class CartModel {
  final int id;
  int quantity;
  final double spicy;
  final List<int> toppings;
  final List<int> options;

  CartModel(
      {required this.id,
      this.quantity = 1,
      required this.spicy,
      required this.toppings,
      required this.options});

  Map<String, dynamic> toJson() => {
        'product_id': id,
        'quantity': quantity,
        'spicy': spicy,
        'side_options': options,
        'toppings': toppings,
      };
}

class CartRequestModel {
  final List<CartModel> cartItems;

  CartRequestModel({required this.cartItems});

  Map<String, dynamic> toJson() => {
        'items': cartItems.map((e) => e.toJson()).toList(),
      };
}

class GetCartResponse {
  final int code;
  final String message;
  final CartData cartData;

  GetCartResponse(
      {required this.code, required this.message, required this.cartData});

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
        code: json['code'],
        message: json['message'],
        cartData: CartData.fromJson(json['data']));
  }
}

class CartData {
  final int id;
  final String totalPrice;
  final List<CartItemModel> items;

  CartData({required this.id, required this.totalPrice, required this.items});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
        id: json['id'],
        totalPrice: json['total_price'],
        items: (json['items'] as List)
            .map((item) => CartItemModel.fromJson(item))
            .toList());
  }
}

class CartItemModel {
  final int itemId;
  final int productId;
  final String name;
  final String image;
   int quantity;
  final String price;
  final double spicy;
  final List<ToppingModel> toppings;
  final List<ToppingModel> sideOptions;

  String get secureImageUrl {
    if (image == null || image!.isEmpty) return 'assets/images/splash.png';
    return image!.startsWith('http://')
        ? image!.replaceFirst('http://', 'https://')
        : image!;
  }

  CartItemModel(
      {required this.itemId,
      required this.productId,
      required this.name,
      required this.image,
      required this.quantity,
      required this.price,
      required this.spicy,
      required this.toppings,
      required this.sideOptions});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json['item_id'],
      productId: json['product_id'],
      name: json['name'],
      image: json['image'],
      quantity: json['quantity'],
      price: json['price'],
      spicy: double.tryParse(json['spicy'].toString()) ?? 0.0,
      toppings: (json['toppings'] as List? ?? [])
          .map((e) => ToppingModel.fromJson(e))
          .toList(),

      sideOptions: (json['side_options'] as List? ?? [])
          .map((e) => ToppingModel.fromJson(e))
          .toList(),
    );
  }
}
