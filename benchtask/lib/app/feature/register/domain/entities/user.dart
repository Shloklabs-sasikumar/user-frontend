import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String age;
  final String address;
  final String pinCode;

  const User(
      {this.id,
      required this.name,
      required this.age,
      required this.email,
      required this.address,
      required this.pinCode});

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? age,
    String? address,
    String? pinCode,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        email: email ?? this.email,
        address: address ?? this.address,
        pinCode: pinCode ?? this.pinCode);
  }
  // Convert the User object into a Map
  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'address': address,
      'pinCode': pinCode,
    };
  }
  // Convert a JSON map into a User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as String,
      address: json['address'] as String,
      pinCode: json['pinCode'] as String,
    );
  }

  // Convert a User object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'address': address,
      'pinCode': pinCode,
    };
  }
  @override
  // TODO: implement props
  List<Object?> get props => [id,name, email, age, address, pinCode];
}
