class SellerModel {
  final String sellerId;
  final String sellerName;
  final String ateleName;
  final String sellerImages;
  final String ateleImages;
  final String email;
  final String phoneNumber;
  final String location;

  SellerModel({required this.sellerId, required this.sellerName, required this.ateleName, required this.sellerImages, required this.ateleImages, required this.email, required this.phoneNumber, required this.location});
  
  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      sellerId: json['sellerId'],
      sellerName: json['fristname'],
      ateleName: json['ateleName'],
      sellerImages: json['sellerImages'],
      ateleImages: json['ateleImages'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
    );
  }
}
