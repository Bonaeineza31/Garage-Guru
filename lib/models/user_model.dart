enum UserRole { customer, garageOwner }

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final UserRole role;
  final String? address;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.role,
    this.address,
    required this.createdAt,
  });

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? address,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role,
      address: address ?? this.address,
      createdAt: createdAt,
    );
  }
}
