import 'package:food_app/features/product/data/models/topping_model.dart';

class CartResponseModel {
  final int code;
  final String message;
  final int id;
  final String totalPrice;
  final List<CartItem> items;

  CartResponseModel(
      {required this.code,
      required this.message,
      required this.id,
      required this.totalPrice,
      required this.items});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
        code: json['code'],
        message: json['message'],
        id: json['data']['id'],
        totalPrice: json['data']['total_price'],
        items: (json['data']['items'] ?? [] as List).map((e) => CartItem.fromJson(e)).toList());
  }
}

class CartItem {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final String spicy;
  final List<ToppingModel> toppings;
  final List<ToppingModel> options;

  CartItem(
      {required this.itemId,
      required this.productId,
      required this.name,
      required this.image,
      required this.quantity,
      required this.price,
      required this.spicy,
      required this.toppings,
      required this.options});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        itemId: json['item_id'],
        productId: json['product_id'],
        name: json['name'],
        image: json['image'],
        quantity: json['quantity'],
        price: json['price'],
        spicy: json['spicy'],
        toppings: (json['toppings']  as List).map((e) => ToppingModel.fromJson(e)).toList(),
        options: (json['side_options']  as List).map((e)=> ToppingModel.fromJson(e)).toList());
  }
}
