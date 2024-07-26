class UserModel {
  final String firstName;
  final String lastName;
  final String? email;
  final String? country;
  final String? state;
  final String? image;
  final List<String> households;
  final Map<String, dynamic> meals;
  final double sumOfGasPollution;

  UserModel({
    this.firstName = "firstName",
    this.lastName = "lastName",
    this.email,
    this.country,
    this.state,
    this.image,
    this.households = const [],
    this.meals = const {},
    this.sumOfGasPollution = 0.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final meals = Map<String, dynamic>.from(json['meals'] ?? {});

    return UserModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['user_email'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      image: json['image'] as String?,
      households: List<String>.from(json['households'] ?? []),
      meals: meals,
      sumOfGasPollution: json['sum_gas_pollution']['CO2'],
    );
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'user_email': email,
        'country': country,
        'state': state,
        'image': image,
        'households': households,
        'meals': meals,
        'sum_of_gas_pollution': sumOfGasPollution,
      };

  @override
  String toString() {
    return 'UserModel{firstName: $firstName, lastName: $lastName, email: $email, country: $country, state: $state, image: $image, households: $households, meals: $meals, sumOfGasPollution: $sumOfGasPollution}';
  }
}
