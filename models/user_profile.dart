class UserProfile {
  String email;
  String name;
  String village;
  String city;
  String pincode;
  String gender;
  String phone;
  String bio;
  String password;

  UserProfile({
    required this.email,
    required this.name,
    this.village = '',
    this.city = '',
    this.pincode = '',
    this.gender = '',
    this.phone = '',
    this.bio = '',
    this.password = '',
  });
}
