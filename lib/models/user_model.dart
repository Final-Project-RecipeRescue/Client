class UserModel {
  final String firstName;
  final String lastName;
  final String? email;
  final String? country;
  final String? state;
  final String? image;
  final List<String> householdsIds;
  final Map<String, dynamic> meals;
  final double sumOfGasPollution;

  UserModel({
    this.firstName = "",
    this.lastName = "lastName",
    this.email,
    this.country,
    this.state,
    this.image,
    this.householdsIds = const [],
    this.meals = const {},
    this.sumOfGasPollution = 0.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final meals = Map<String, dynamic>.from(json['meals'] ?? {});
    //final userHouseholds = Map<String, dynamic>.from(json['households'] ?? {});
    return UserModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['user_email'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      image: json['image'] as String?,
      householdsIds: List<String>.from(json['households_ids'] ?? []),
      meals: meals,
      sumOfGasPollution: (json['sum_gas_pollution']['CO2'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'user_email': email,
        'country': country,
        'state': state,
        'image': image,
        'households': householdsIds,
        'meals': meals,
        'sum_of_gas_pollution': sumOfGasPollution,
      };

  @override
  String toString() {
    return 'UserModel{firstName: $firstName, lastName: $lastName, email: $email, country: $country, state: $state, image: $image, households: $householdsIds, meals: $meals, sumOfGasPollution: $sumOfGasPollution, households: $householdsIds}';
  }
}

// class UserModelHouseholdNamesRef extends UserModel {
//   final Map<String, dynamic> households;

//   UserModelHouseholdNamesRef({
//     String firstName = "",
//     String lastName = "lastName",
//     String? email,
//     String? country,
//     String? state,
//     String? image,
//     List<String> householdsIds = const [],
//     Map<String, dynamic> meals = const {},
//     double sumOfGasPollution = 0.0,
//     required this.households,
//   }) : super(
//           firstName: firstName,
//           lastName: lastName,
//           email: email,
//           country: country,
//           state: state,
//           image: image,
//           householdsIds: householdsIds,
//           meals: meals,
//           sumOfGasPollution: sumOfGasPollution,
//         );
//   factory UserModelHouseholdNamesRef.fromJson(Map<String, dynamic> json) {
//     // Parsing the households map from JSON
//     final Map<String, Household> households = {};
//     if (json['households'] != null) {
//       json['households'].forEach((key, value) {
//         households[key] = Household.fromJson(value);
//       });
//     }

//     return UserModelHouseholdNamesRef(
//       firstName: json['first_name'] as String? ?? "",
//       lastName: json['last_name'] as String? ?? "lastName",
//       email: json['user_email'] as String?,
//       country: json['country'] as String?,
//       state: json['state'] as String?,
//       image: json['image'] as String?,
//       householdsIds: households.values.map((e) => e.householdName).toList(),
//       meals: Map<String, dynamic>.from(json['meals'] ?? {}),
//       sumOfGasPollution: json['sum_gas_pollution'] != null
//           ? json['sum_gas_pollution']['CO2']
//           : 0.0,
//       households: households,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     final householdsJson =
//         households.map((key, value) => MapEntry(key, value.toJson()));

//     return {
//       ...super.toJson(),
//       'households': householdsJson,
//     };
//   }

//   @override
//   String toString() {
//     return 'UserModelHouseholdNamesRef{firstName: $firstName, lastName: $lastName, email: $email, country: $country, state: $state, image: $image, householdsNames: $householdsIds, meals: $meals, sumOfGasPollution: $sumOfGasPollution, households: $households}';
//   }
// }
