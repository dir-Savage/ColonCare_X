import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coloncare/features/auth/domain/entities/user_en.dart';
import 'package:equatable/equatable.dart';


class UserModel extends Equatable {
  final String uid;
  final String email;
  final String fullName;
  final Timestamp? createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.createdAt,
  });

  User toEntity() => User(
    uid: uid,
    email: email,
    fullName: fullName,
  );

  factory UserModel.fromEntity(User user) => UserModel(
    uid: user.uid,
    email: user.email,
    fullName: user.fullName,
  );

  @override
  List<Object?> get props => [uid, email, fullName, createdAt];
}