import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String avatarUrl = 'https://api.dicebear.com/9.x/adventurer-neutral/svg?seed=Avery';
  final String email;
  final String fullName;

  const User({
    required this.uid,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object> get props => [uid, email, fullName];

  // Factory constructor for empty user
  factory User.empty() => const User(
    uid: '',
    email: '',
    fullName: '',
  );

  bool get isEmpty => uid.isEmpty && email.isEmpty && fullName.isEmpty;
  bool get isNotEmpty => !isEmpty;

  // Copy with method
  User copyWith({
    String? uid,
    String? email,
    String? fullName,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
    );
  }
}