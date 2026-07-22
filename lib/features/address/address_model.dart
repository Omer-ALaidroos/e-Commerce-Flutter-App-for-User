class AddressModel {
  final int? id;
  final String? country;
  final String? city;
  final String? street;
  

  AddressModel({
    this.id,
    this.country,
    this.city,
    this.street,
   
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      street: json['street'] as String?,
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
      'street': street,
      
    };
  }
}