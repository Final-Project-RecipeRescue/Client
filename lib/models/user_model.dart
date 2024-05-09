class UserModel {
  final String firstName;
  final String lastName;
  final String? email;
  final String country;
  final String? state;
  final String? image; // New field for image
  final List<String> households; // New field for households
  final Map<String, dynamic> meals; // New field for meals

  UserModel({
    this.firstName = "firstName",
    this.lastName = "lastName",
    this.email,
    this.country = "country",
    this.state = "state",
    this.image,
    this.households = const [],
    this.meals = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['user_email'] as String?,
        country: json['country'] as String,
        state: json['state'] as String?,
        image: json['image'] as String?,
        households: List<String>.from(json['households'] ?? []),
        meals: Map<String, dynamic>.from(json['meals'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'user_email': email,
        'country': country,
        'state': state,
        'image': image,
        'households': households,
        'meals': meals,
      };

  @override
  String toString() {
    return 'UserModel{firstName: $firstName, lastName: $lastName, email: $email, country: $country, state: $state, image: $image, households: $households, meals: $meals}';
  }
}
