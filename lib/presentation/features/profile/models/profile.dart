class Profile {
  final String name;
  final String email;
  final String mobile;

  const Profile({
    required this.name,
    required this.email,
    required this.mobile,
  });

  Profile copyWith({
    String? name,
    String? email,
    String? mobile,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
    );
  }
}
