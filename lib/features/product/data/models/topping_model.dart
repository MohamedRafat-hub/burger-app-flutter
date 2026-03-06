class ToppingModel {
  int id;
  String name;
  String image;


  String get secureImageUrl {
    if (image == null || image!.isEmpty) return 'assets/images/splash.png';
    return image!.startsWith('http://')
        ? image!.replaceFirst('http://', 'https://')
        : image!;
  }

  ToppingModel({required this.id ,required  this.name ,required this.image});

  factory ToppingModel.fromJson(Map<String , dynamic>json)
  {
    return ToppingModel(
      image: json['image'],
      id: json['id'],
      name: json['name'],
    );
  }
}