class ProductModel {
  final int id;
  final String image;
  final String name;
  final String desc;
  final String rating;
  final String price;

  String get secureImageUrl {
    if (image == null || image!.isEmpty) return 'assets/images/splash.png';
    return image!.startsWith('http://')
        ? image!.replaceFirst('http://', 'https://')
        : image!;
  }

  ProductModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.desc,
      required this.rating,
      required this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        name: json['name'],
        desc: json['description'],
        image: json['image'],
        rating: json['rating'],
        price: json['price']);
  }
}
