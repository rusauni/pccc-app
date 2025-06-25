class AccountDetailModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String dateOfBirth;
  final String gender;
  final String occupation;
  final String company;

  AccountDetailModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    required this.occupation,
    required this.company,
  });

  factory AccountDetailModel.fromJson(Map<String, dynamic> json) {
    return AccountDetailModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      occupation: json['occupation'] ?? '',
      company: json['company'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'occupation': occupation,
      'company': company,
    };
  }

  AccountDetailModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? dateOfBirth,
    String? gender,
    String? occupation,
    String? company,
  }) {
    return AccountDetailModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
    );
  }
} 