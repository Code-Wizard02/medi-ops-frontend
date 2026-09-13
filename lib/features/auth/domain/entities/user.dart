import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.status,
    this.displayName,
  });

  final String id;
  final String email;
  final String status;
  final String? displayName;

  @override
  List<Object?> get props => [id, email, status, displayName];
}