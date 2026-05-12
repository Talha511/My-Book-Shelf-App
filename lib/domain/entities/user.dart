import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String? profileImage;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, email, password, phoneNumber, profileImage];
}
