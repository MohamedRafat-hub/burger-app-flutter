
class UserModel {
  final String name;
  final String email;
  String? token;
  String? phone;
  String? image;
  String? visa;
  String? address;

  UserModel(
      {required this.name, required this.email, this.token, this.image,
      this.phone,
      this.visa,
      this.address});


  String get secureImageUrl {
    if (image == null || image!.isEmpty) return 'assets/images/splash.png';
    return image!.startsWith('http://')
        ? image!.replaceFirst('http://', 'https://')
        : image!;
  }



  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        token: json['token'],
        image: json['image'],
        phone: json['phone'],
        visa: json['Visa'],
        address: json['address']);
  }
}
