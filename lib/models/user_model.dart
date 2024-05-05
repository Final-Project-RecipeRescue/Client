class UserModel {
  final String firstName;
  final String lastName;
  final String? email;
  final String country;
  final String state;
  final List<String> ingredients;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.country,
      required this.state,
      required this.ingredients});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      ingredients: json['ingredients'] as List<String>);

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'country': country,
        'state': state,
        'ingredients': ingredients
      };
}
